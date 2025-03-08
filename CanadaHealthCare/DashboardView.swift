//
//  DashboardView.swift
//  CanadaHealthCare
//
//  Created by Yash Suthar on 2025-03-07.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            FindDoctorView()
                .tabItem {
                    Image(systemName: "stethoscope")
                    Text("Doctors")
                }
            MapView()
                .tabItem {
                    Image(systemName: "location")
                    Text("Map")
                }
//            ProfileView()
//                .tabItem {
//                    Image(systemName: "person.fill")
//                    Text("Profile")
//                }
        }
        .navigationBarBackButtonHidden()

    }
}

#Preview {
    DashboardView()
}
