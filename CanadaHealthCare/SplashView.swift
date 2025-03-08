//
//  SplashView.swift
//  CanadaHealthCare
//
//  Created by Yash Suthar on 2025-03-08.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Image(uiImage: UIImage(named: "icon") ?? UIImage()) // Fetch app icon from Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Text("HealthMate")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue.opacity(0.8))
                
                Text("Because Your Health Matters.")
                    .font(.subheadline)
                    .foregroundColor(.green.opacity(0.8))
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SplashView()
}
