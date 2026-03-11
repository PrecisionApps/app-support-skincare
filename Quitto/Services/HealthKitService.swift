//
//  HealthKitService.swift
//  Quitto
//
//  Reads real health vitals (heart rate, blood oxygen) from Apple Health.
//

import Foundation
import HealthKit

@Observable
final class HealthKitService {
    
    // MARK: - Published State
    
    /// Latest resting heart rate in BPM, nil if no data or not authorized
    private(set) var latestHeartRate: Double?
    
    /// Latest blood oxygen saturation as a percentage (0-100), nil if no data or not authorized
    private(set) var latestOxygenSaturation: Double?
    
    /// Whether HealthKit authorization has been requested (not necessarily granted)
    private(set) var authorizationRequested: Bool = false
    
    /// Whether HealthKit is available on this device
    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }
    
    // MARK: - Formatted Display Values
    
    /// Heart rate formatted for display, e.g. "72 bpm" or "—" if unavailable
    var heartRateDisplay: String {
        guard let hr = latestHeartRate else { return "—" }
        return "\(Int(hr)) bpm"
    }
    
    /// Oxygen saturation formatted for display, e.g. "98%" or "—" if unavailable
    var oxygenSaturationDisplay: String {
        guard let spo2 = latestOxygenSaturation else { return "—" }
        return "\(Int(spo2))%"
    }
    
    /// Whether we have real heart rate data
    var hasHeartRateData: Bool {
        latestHeartRate != nil
    }
    
    /// Whether we have real oxygen data
    var hasOxygenData: Bool {
        latestOxygenSaturation != nil
    }
    
    // MARK: - Private
    
    private let healthStore = HKHealthStore()
    
    private let heartRateType = HKQuantityType(.heartRate)
    private let oxygenType = HKQuantityType(.oxygenSaturation)
    
    // MARK: - Authorization
    
    /// Request authorization to read heart rate and blood oxygen from HealthKit.
    /// Call this when the dashboard appears. HealthKit will only show the prompt once.
    func requestAuthorization() async {
        guard isAvailable else { return }
        guard !authorizationRequested else {
            // Already requested, just refresh data
            await fetchLatestVitals()
            return
        }
        
        let typesToRead: Set<HKObjectType> = [
            heartRateType,
            oxygenType
        ]
        
        do {
            try await healthStore.requestAuthorization(toShare: [], read: typesToRead)
            authorizationRequested = true
            await fetchLatestVitals()
        } catch {
            // Authorization denied or failed — we'll show fallback UI
            authorizationRequested = true
        }
    }
    
    // MARK: - Data Fetching
    
    /// Fetch the latest heart rate and blood oxygen samples from HealthKit
    func fetchLatestVitals() async {
        guard isAvailable else { return }
        
        async let hr = fetchLatestSample(for: heartRateType)
        async let spo2 = fetchLatestSample(for: oxygenType)
        
        let (heartRateSample, oxygenSample) = await (hr, spo2)
        
        await MainActor.run {
            if let heartRateSample {
                self.latestHeartRate = heartRateSample.quantity.doubleValue(
                    for: HKUnit.count().unitDivided(by: .minute())
                )
            }
            
            if let oxygenSample {
                // HealthKit stores SpO2 as a fraction (0.0-1.0), we display as percentage
                self.latestOxygenSaturation = oxygenSample.quantity.doubleValue(
                    for: HKUnit.percent()
                ) * 100.0
            }
        }
    }
    
    /// Fetch the most recent sample for a given quantity type within the last 24 hours
    private func fetchLatestSample(for quantityType: HKQuantityType) async -> HKQuantitySample? {
        let now = Date()
        let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: now) ?? now
        
        let predicate = HKQuery.predicateForSamples(
            withStart: oneDayAgo,
            end: now,
            options: .strictEndDate
        )
        
        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false
        )
        
        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, _ in
                let sample = samples?.first as? HKQuantitySample
                continuation.resume(returning: sample)
            }
            healthStore.execute(query)
        }
    }
}
