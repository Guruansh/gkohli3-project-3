//
//  ContentView.swift
//  Aqi
//
//  Created by Guruansh  Kohli  on 7/30/25.
//
import SwiftUI

// Pollutant types to always display
enum Pollutant: String, CaseIterable, Identifiable {
    case pm25 = "PM2.5"
    case pm10 = "PM10"
    case o3   = "O3"
    case no2  = "NO2"
    case so2  = "SO2"
    case co   = "CO"

    var id: String { rawValue }
}

// Maping Category names to colors for the badge
func colorForCategory(_ category: String) -> Color {
    switch category.lowercased() {
    case "good": return .green
    case "moderate": return .yellow
    case "unhealthy for sensitive groups": return .orange
    case "unhealthy": return .red
    case "very unhealthy": return .purple
    case "hazardous": return .indigo
    default: return .blue
    }
}

struct ContentView: View {
    @StateObject private var vm = AQIViewModel()
    @AppStorage("defaultZip") private var zipCode: String = ""
    @State private var showErrorAlert = false
    @AppStorage("languageOverride") private var languageOverrideRaw: String = LanguageOption.system.rawValue

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                zipCodeInputView
                cityDateView
                pollutantListView

                // About button
                NavigationLink(destination: InfoView()) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text(LocalizedStringKey("About"))
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(8)
                }
            }
            .navigationTitle(LocalizedStringKey("Air Quality"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //settings button
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text(LocalizedStringKey("Settings"))
                        }
                        .foregroundColor(.purple)
                    }
                }
            }
            // if no internet displays network error as an alert
            .alert(LocalizedStringKey("Network Error"), isPresented: $showErrorAlert) {
                Button(LocalizedStringKey("OK"), role: .cancel) {
                    vm.errorMessage = nil
                }
            } message: {
                Text(vm.errorMessage ?? NSLocalizedString("Unknown error", comment: ""))
            }
        }
        .environment(\.locale, currentLocale())
        .onChange(of: vm.errorMessage) { _, newValue in
            showErrorAlert = newValue != nil
        }
    }

    private var zipCodeInputView: some View {
        
        // asking for zip code
        HStack {
            TextField(LocalizedStringKey("Enter ZIP Code"), text: $zipCode)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(maxWidth: 200)
                .padding(.horizontal)
            // button to fetch the aqi
            Button(LocalizedStringKey("Fetch AQI")) {
                vm.load(zip: zipCode)
            }
            .disabled(zipCode.isEmpty || vm.isLoading)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.purple.opacity(zipCode.isEmpty || vm.isLoading ? 0.3 : 0.2))
            .cornerRadius(8)
            .scaleEffect(vm.isLoading ? 1.0 : 1.03)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: vm.isLoading)
        }
    }

    private var cityDateView: some View {
        Group {
            if let obs0 = vm.observations.first {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(NSLocalizedString("City", comment: "")): \(obs0.ReportingArea)")
                    Text("\(NSLocalizedString("Date", comment: "")): \(obs0.DateObserved) @ \(obs0.HourObserved):00 \(obs0.LocalTimeZone)")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            }
        }
    }

    private var pollutantListView: some View {
        Group {
            if vm.isLoading {
                // spinner while loading animation
                ProgressView(LocalizedStringKey("Loading…"))
                    .frame(maxHeight: .infinity)
            } else {
                List {
                    ForEach(Array(Pollutant.allCases.enumerated()), id: \.offset) { index, pollutant in
                        let match = vm.observations.first(where: { $0.ParameterName == pollutant.rawValue })
                        PollutantRowView(index: index, type: pollutant, observation: match)
                    }

                }
                .listStyle(.insetGrouped)
                .transition(.slide)
            }
        }
    }
    // Chooses the current Locale from app settings
    private func currentLocale() -> Locale {

            switch LanguageOption(rawValue: languageOverrideRaw) ?? .system {

            case .english: return Locale(identifier: "en")

            case .spanish: return Locale(identifier: "es")

            case .french: return Locale(identifier: "fr")

            case .system: return Locale.current

            }

        }
}

struct PollutantRowView: View {
    let index: Int
    let type: Pollutant
    let observation: AQObservation?

    var body: some View {
        Group {
            if let obs = observation {
                // Tappable row navigates to detailView
                NavigationLink(destination: AqsDetailView(observation: obs)) {
                    HStack {
                        Text(type.rawValue)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Spacer()

                        Text("AQI: \(obs.AQI)")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Text(obs.Category.Name)
                            .font(.caption)
                            .padding(6)
                            .background(colorForCategory(obs.Category.Name).opacity(0.5))
                            .foregroundColor(.primary)
                            .cornerRadius(6)
                    }
                    .padding(.vertical, 8)
                }
            } else {
                HStack {
                    Text(type.rawValue)
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Spacer()

                    Text("N/A")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
        }
        .padding(.horizontal)
        // adapts to light/dark
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .transition(.opacity)
        .animation(.easeInOut.delay(Double(index) * 0.05), value: observation?.AQI ?? -1)
    }
}



#Preview {
    ContentView()
}
