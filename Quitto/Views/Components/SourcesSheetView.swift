//
//  SourcesSheetView.swift
//  Quitto
//
//  Displays all medical sources and citations for health information.
//

import SwiftUI

struct SourcesSheetView: View {
    let habitName: String
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    private var relevantSources: [MedicalSource] {
        MedicalSources.sources(for: habitName)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    disclaimerSection
                    sourcesSection
                    generalSourcesSection
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.bottom, Theme.Spacing.xl)
            }
            .background(colorScheme == .dark ? Color.surfaceDark : Color.surfacePrimary)
            .navigationTitle("Sources & Citations")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accent)
                }
            }
        }
    }
    
    private var disclaimerSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(Color.warmth)
                Text("Important Disclaimer")
                    .font(.titleSmall)
                    .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            }
            
            Text(MedicalSources.generalDisclaimer)
                .font(.bodySmall)
                .foregroundStyle(colorScheme == .dark ? Color.textSecondaryDark : Color.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Theme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(Color.warmth.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                        .stroke(Color.warmth.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.top, Theme.Spacing.sm)
    }
    
    private var sourcesSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Sources for \(habitName) Information")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            ForEach(relevantSources) { source in
                sourceCard(source)
            }
        }
    }
    
    private var generalSourcesSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("General Health Sources")
                .font(.titleSmall)
                .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
            
            ForEach([MedicalSources.apa, MedicalSources.nida, MedicalSources.who, MedicalSources.harvard]) { source in
                sourceCard(source)
            }
        }
    }
    
    private func sourceCard(_ source: MedicalSource) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            HStack(alignment: .top, spacing: Theme.Spacing.sm) {
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.accent)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(source.fullTitle)
                        .font(.bodyMedium)
                        .fontWeight(.semibold)
                        .foregroundStyle(colorScheme == .dark ? Color.textPrimaryDark : Color.textPrimary)
                    
                    Text(source.organization)
                        .font(.labelSmall)
                        .foregroundStyle(Color.textSecondary)
                }
                
                Spacer()
            }
            
            if let url = URL(string: source.url) {
                Link(destination: url) {
                    HStack(spacing: 4) {
                        Text(source.url)
                            .font(.caption2)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 8))
                    }
                    .foregroundStyle(Color.accent.opacity(0.8))
                }
            }
        }
        .padding(Theme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                .fill(colorScheme == .dark ? Color.surfaceElevatedDark : Color.surfaceElevated)
        )
    }
}
