//  AqsDetailView.swift
//  Aqi
//
//  Created by Guruansh  Kohli  on 7/31/25.
//

import SwiftUI

struct AqsDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    let observation: AQObservation

    var body: some View {
        VStack(spacing: 16) {
            Text(observation.ParameterName)
                .font(.largeTitle)
                .bold()
            // Aqi Value
            Text(String(format: NSLocalizedString("AQI: %d", comment: ""), observation.AQI))
                .font(.title2)
            // Category name
            Text(observation.Category.Name)
                .font(.headline)
                .padding(.vertical, 4)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(8)
            // Location and timestamp details
            VStack(alignment: .leading, spacing: 8) {
                Text(String(format: NSLocalizedString("Location: %@", comment: ""), observation.ReportingArea))
                Text(String(format: NSLocalizedString("Time: %@ @ %02d:00 %@", comment: ""),
                            observation.DateObserved, observation.HourObserved, observation.LocalTimeZone))
            }
            .font(.subheadline)
            .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle(observation.ParameterName)
        
        // Back button
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text(LocalizedStringKey("Home"))
                    }
                }
                .foregroundColor(.purple)
            }
        }
    }
}

