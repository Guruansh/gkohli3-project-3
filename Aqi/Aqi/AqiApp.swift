//  AqiApp.swift
//  Aqi
//
//  Created by Guruansh  Kohli  on 7/30/25.
//

import SwiftUI
import UserNotifications

@main
struct AqiApp: App {
    // theme choice from SettingsView
    @AppStorage("themeMode") private var themeModeRaw: String = ThemeMode.system.rawValue

    init() {
        // Asking for notification permission
        NotificationManager.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .accentColor(.purple)
                .preferredColorScheme(resolveColorScheme())
        }
    }

    // Converting saved string to ColorScheme
    private func resolveColorScheme() -> ColorScheme? {
        switch themeModeRaw {
        case ThemeMode.light.rawValue: return .light
        case ThemeMode.dark.rawValue:  return .dark
        default: return nil
        }
    }
}

