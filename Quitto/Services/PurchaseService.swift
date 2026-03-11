//
//  PurchaseService.swift
//  Quitto
//

import Foundation
import RevenueCat

actor PurchaseService {
    func fetchOfferings() async throws -> Offerings {
        try await Purchases.shared.offerings()
    }
    
    func purchase(package: Package) async throws -> (customerInfo: CustomerInfo, userCancelled: Bool) {
        let result = try await Purchases.shared.purchase(package: package)
        return (result.customerInfo, result.userCancelled)
    }
    
    func restore() async throws -> CustomerInfo {
        try await Purchases.shared.restorePurchases()
    }
    
    func currentCustomerInfo() async throws -> CustomerInfo {
        try await Purchases.shared.customerInfo()
    }
}
