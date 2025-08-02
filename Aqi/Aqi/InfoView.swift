//  InfoView.swift
//  Aqi
//
//  Created by Guruansh  Kohli  on 8/1/25.
//
import SwiftUI

struct InfoView: View {
    // Bundle meta-data
    
    // app name
    private var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "App"
    }
    // app version
    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
    // build number
    private var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }
    //copyright info
    private var copyrightText: String {
        Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String ?? ""
    }

    var body: some View {
        VStack(spacing: 16) {
            // display the app logo
            Image("AppLogo")
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(16)

            // App name
            Text(appName)
                .font(.title)
                .bold()

            // Version and Build
            Text(
                String(
                    format: NSLocalizedString("Version %@ (Build %@)", comment: "Version and build number display"),
                    appVersion,
                    buildNumber
                )
            )
            .font(.subheadline)

            // Copyright
            if !copyrightText.isEmpty {
                Text(copyrightText)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    InfoView()
}
    


