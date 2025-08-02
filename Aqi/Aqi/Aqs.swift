//  Aqs.swift
//  Aqi
//
//  Created by Guruansh  Kohli  on 7/31/25.
//

import Foundation

// Model for each pollutant
struct AQObservation: Codable, Identifiable {
    var id: UUID { UUID() }
    let DateObserved: String
    let HourObserved: Int
    let LocalTimeZone: String
    let ReportingArea: String
    let ParameterName: String
    let AQI: Int
    let Category: Category

    struct Category: Codable {
        let Number: Int
        let Name: String
    }
}

// Service to fetch by ZIP and parameter
class AirQualityService {
    private let apiKey: String

    // using AirNow Api
    init() {
        apiKey = Bundle.main.object(forInfoDictionaryKey: "AirNowAPIKey") as? String ?? ""
    }

    func fetchObservations(zip: String, completion: @escaping (Result<[AQObservation], Error>) -> Void) {
        guard
            let url = URL(string:
                "https://www.airnowapi.org/aq/observation/zipCode/current/?format=application/json&zipCode=\(zip)&distance=25&API_KEY=\(apiKey)"
            )
        else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error)); return
            }
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse))); return
            }
            do {
                let decoder = JSONDecoder()
                let observations = try decoder.decode([AQObservation].self, from: data)
                completion(.success(observations))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}

