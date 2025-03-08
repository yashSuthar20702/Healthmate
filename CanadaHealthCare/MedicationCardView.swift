//
//  MedicationCardView.swift
//  CanadaHealthCare
//
//  Created by Yash Suthar on 2025-03-07.
//

import SwiftUI

struct MedicationCardView: View {
    let prescription: Prescription
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(prescription.medicationName)
                .font(.title3)
                .fontWeight(.bold)
            HStack {
                Text("Dosage: \(prescription.dosage)")
                Spacer()
                Text("Frequency: \(prescription.frequency)")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            Text("Duration: \(prescription.duration)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Instructions: \(prescription.instructions)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.1))
                .shadow(radius: 3)
        )
        .padding(.bottom, 10)
    }
}


#Preview {
    MedicationCardView(prescription: .init(medicationName: "", dosage: "", frequency: "", duration: "", instructions: ""))
}
