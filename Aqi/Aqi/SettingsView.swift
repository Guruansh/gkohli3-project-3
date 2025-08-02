//  SettingsView.swift
//  Aqi
//
//  Created by Guruansh  Kohli  on 8/1/25.
//
import SwiftUI

// Theme Mode Options
enum ThemeMode: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { rawValue }

    var localizedLabel: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }
}

// Language Options
enum LanguageOption: String, CaseIterable, Identifiable {
    case system = "System"
    case english = "English"
    case spanish = "Español"
    case french = "Français"

    var id: String { rawValue }

    var localizedLabel: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }
}

struct SettingsView: View {
    // Persisted Settings
    @AppStorage("defaultZip") private var defaultZip: String = ""
    @AppStorage("themeMode") private var themeModeRaw: String = ThemeMode.system.rawValue
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @AppStorage("languageOverride") private var languageOverrideRaw: String = LanguageOption.system.rawValue

    var body: some View {
        Form {
            Section(header: Text(LocalizedStringKey("Default ZIP Code"))) {
                TextField(LocalizedStringKey("ZIP Code"), text: $defaultZip)
                    .keyboardType(.numberPad)
            }

            Section(header: Text(LocalizedStringKey("Theme"))) {
                Picker(LocalizedStringKey("Theme"), selection: $themeModeRaw) {
                    ForEach(ThemeMode.allCases) { mode in
                        Text(mode.localizedLabel).tag(mode.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section {
                Toggle(LocalizedStringKey("Enable Notifications"), isOn: $notificationsEnabled)
            }

            Section(header: Text(LocalizedStringKey("Language"))) {
                Picker(LocalizedStringKey("Language"), selection: $languageOverrideRaw) {
                    ForEach(LanguageOption.allCases) { lang in
                        Text(lang.localizedLabel).tag(lang.rawValue)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
        .navigationTitle(LocalizedStringKey("Settings"))
    }
}

#Preview {
    SettingsView()
}


