//  AqsListView.swift
//  Aqi
//
//  Created by Guruansh  Kohli  on 7/31/25.
//

import SwiftUI

// Showing a list of AQI observations (one per pollutant)
struct AqsListView: View {
    let observations: [AQObservation]

    var body: some View {
        List(observations) { obs in
            NavigationLink {
                AqsDetailView(observation: obs)
            } label: {
                HStack {
                    Text(obs.ParameterName)
                        .font(.headline)
                    Spacer()
                    Text("\(obs.AQI)")
                        .bold()
                }
            }
        }
        .navigationTitle("Observations")
    }
}
