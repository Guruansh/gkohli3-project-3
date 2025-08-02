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

struct ContentView: View {
    @StateObject private var vm = AQIViewModel()
    @AppStorage("defaultZip") private var zipCode: String = ""
    @State private var showErrorAlert = false
    @AppStorage("languageOverride") private var languageOverrideRaw: String = LanguageOption.system.rawValue

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // ZIP code input & Fetch AQI button
                HStack {
                    TextField(NSLocalizedString("Enter ZIP Code", comment: ""), text: $zipCode)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 200)
                        .padding(.horizontal)

                    Button(NSLocalizedString("Fetch AQI", comment: "")) {
                        vm.load(zip: zipCode)
                    }
                    .disabled(zipCode.isEmpty || vm.isLoading)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(
                        Color.purple
                            .opacity(zipCode.isEmpty || vm.isLoading ? 0.3 : 0.2)
                    )
                    .cornerRadius(8)
                }

                // City & Date info
                if let obs0 = vm.observations.first {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(format: NSLocalizedString("City: %@", comment: ""), obs0.ReportingArea))
                        Text(String(format: NSLocalizedString("Date: %@ @ %02d:00 %@", comment: ""), obs0.DateObserved, obs0.HourObserved, obs0.LocalTimeZone))
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                }

                // Loading indicator or pollutant list with tappable rows
                if vm.isLoading {
                    ProgressView(NSLocalizedString("Loading…", comment: ""))
                        .frame(maxHeight: .infinity)
                } else {
                    List(Pollutant.allCases) { type in
                        if let obs = vm.observations.first(where: {
                            $0.ParameterName.caseInsensitiveCompare(type.rawValue) == .orderedSame
                        }) {
                            NavigationLink(destination: AqsDetailView(observation: obs)) {
                                HStack {
                                    Text(type.rawValue)
                                        .font(.headline)
                                    Spacer()
                                    Text(String(format: NSLocalizedString("AQI: %d", comment: ""), obs.AQI))
                                        .font(.subheadline)
                                    Text(obs.Category.Name)
                                        .font(.caption)
                                        .padding(6)
                                        .background(Color.purple.opacity(0.2))
                                        .cornerRadius(6)
                                }
                                .padding(.vertical, 4)
                            }
                        } else {
                            HStack {
                                Text(type.rawValue)
                                    .font(.headline)
                                Spacer()
                                Text(NSLocalizedString("N/A", comment: ""))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
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

            .navigationTitle(NSLocalizedString("Air Quality", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // < Settings button
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text(NSLocalizedString("Settings", comment: ""))
                        }
                        .foregroundColor(.purple)
                    }
                }
            }
            .alert(NSLocalizedString("Network Error", comment: ""), isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {
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

    private func currentLocale() -> Locale {
        switch LanguageOption(rawValue: languageOverrideRaw) ?? .system {
        case .english: return Locale(identifier: "en")
        case .spanish: return Locale(identifier: "es")
        case .french: return Locale(identifier: "fr")
        case .system: return Locale.current
        }
    }
}

#Preview {
    ContentView()
}
