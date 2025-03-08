//
//  CanadaHealthCareApp.swift
//  CanadaHealthCare
//
//  Created by Yash Suthar on 2025-03-07.
//

import SwiftUI

@main
struct CanadaHealthCareApp: App {
    @State private var showHomeView = false

    var body: some Scene {
        WindowGroup {
            if showHomeView {
                SignInView()

            }
            else {
                SplashView()
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showHomeView = true
                            }
                        }

                    }

            }
        }

    }
}
