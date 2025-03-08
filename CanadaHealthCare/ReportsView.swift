//
//  ReportsView.swift
//  CanadaHealthCare
//
//  Created by Yash Suthar on 2025-03-07.
//

import SwiftUI

struct ReportsView: View {
    var body: some View {
        VStack {
            Text("Appointments")
                .font(.title)
                .bold()
            // Example of a graph representation
            Image(systemName: "chart.bar")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding()
            Text("Your recent appointment history is displayed here.")
                .padding()
        }
    }
}


#Preview {
    ReportsView()
}
