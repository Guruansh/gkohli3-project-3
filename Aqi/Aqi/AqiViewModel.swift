//  AqiViewModel.swift
//  Aqi
//
//  Created by Guruansh  Kohli  on 8/1/25.
//
import Foundation
import Combine

class AQIViewModel: ObservableObject {
    @Published var observations: [AQObservation] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = AirQualityService()

    func load(zip: String) {
        isLoading = true
        errorMessage = nil

        service.fetchObservations(zip: zip) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let obs):
                    self?.observations = obs
                    if let firstUnhealthy = obs.first(where: { $0.AQI > 150 }){
                        NotificationManager.scheduleAQINotification(for: firstUnhealthy)
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


