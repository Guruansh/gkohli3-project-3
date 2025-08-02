//  NotificationManager.swift
//  Aqi
//
//  Created by Guruansh  Kohli  on 8/1/25.
//
import Foundation
import UserNotifications

// Manages notification
enum NotificationManager {
    
    // Ask the user to authorize
    static func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification auth error:", error)
            }
        }
    }

    // Notify if Aqi is above threshold
    static func scheduleAQINotification(for obs: AQObservation, threshold: Int = 100) {
        guard obs.AQI > threshold else { return }
        let content = UNMutableNotificationContent()
        content.title = "Air Quality Alert"
        content.body  = "AQI for \(obs.ParameterName) in \(obs.ReportingArea) is \(obs.AQI) (\(obs.Category.Name))."
        content.sound = .default

        // Deliver promptly
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "AQI_\(obs.ParameterName)_\(obs.ReportingArea)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Scheduling notification error:", error)
            }
        }
    }
}


