//
//  MedicalDisclaimerView.swift
//  Quitto
//
//  Reusable medical disclaimer banner for Apple Guideline 1.4.1 compliance.
//

import SwiftUI

struct MedicalDisclaimerBanner: View {
    var compact: Bool = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.sm) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: compact ? 12 : 14))
                .foregroundStyle(Color.textTertiary)
            
            Text(compact ? "For educational purposes only. Not medical advice." : MedicalSources.generalDisclaimer)
                .font(compact ? .caption2 : .caption)
                .foregroundStyle(Color.textTertiary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(compact ? Theme.Spacing.sm : Theme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.md, style: .continuous)
                .fill((colorScheme == .dark ? Color.surfaceElevatedDark : Color.surfaceElevated).opacity(0.6))
        )
    }
}

struct SourceAttributionLabel: View {
    let source: String
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 8))
            Text(source)
                .font(.system(size: 9, weight: .medium))
        }
        .foregroundStyle(Color.textTertiary.opacity(0.8))
    }
}

struct SourcesFooterLink: View {
    let habitName: String
    @State private var showSources = false
    
    var body: some View {
        Button {
            showSources = true
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 10))
                Text("View Sources")
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundStyle(Color.accent.opacity(0.8))
        }
        .sheet(isPresented: $showSources) {
            SourcesSheetView(habitName: habitName)
        }
    }
}
