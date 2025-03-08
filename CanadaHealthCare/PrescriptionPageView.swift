//
//  PrescriptionPageView.swift
//  CanadaHealthCare
//
//  Created by Yash Suthar on 2025-03-07.
//

import SwiftUI

import SwiftUI
// Prescription Model
struct Prescription: Identifiable {
    let id = UUID()
    let medicationName: String
    let dosage: String
    let frequency: String
    let duration: String
    let instructions: String
}
// Sample Prescription Data
let prescriptions = [
    Prescription(medicationName: "Amoxicillin", dosage: "500mg", frequency: "Every 8 hours", duration: "7 days", instructions: "Take with food"),
    Prescription(medicationName: "Paracetamol", dosage: "250mg", frequency: "Every 4 hours", duration: "3 days", instructions: "Take after meals"),
    Prescription(medicationName: "Amlodipine", dosage: "5mg", frequency: "Once daily", duration: "30 days", instructions: "Take in the morning")
]
// Patient Info Model
struct PatientInfo {
    let name: String
    let age: Int
    let contactNumber: String
    let email: String
}
// Sample Patient Data
let patient = PatientInfo(name: "Jasjit Singh", age: 25, contactNumber: "+1 234 567 890", email: "jas@email.com")
// Main Prescription Page View
struct PrescriptionPageView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            VStack {
                Spacer()
                    .frame(height: 60)
                HeaderView(buttonAction: {
                    dismiss()
                }, heading: "Prescriptions")
                Spacer()

            
            ScrollView {
                VStack(spacing: 20){
                    HStack {
                        Spacer()
                            .frame(width: 16)
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.white)
                            HStack {
                                Spacer()
                                    .frame(width: 16)
                                VStack(alignment: .leading, spacing: 10) {
                                    Spacer()
                                        .frame(height: 10)
                                    Text("Patient Information")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                    Text("Name: \(patient.name)")
                                    Text("Age: \(patient.age) years")
                                    Text("Contact: \(patient.contactNumber)")
                                    Text("Email: \(patient.email)")
                                    Spacer()
                                        .frame(height: 10)
                                }
                                Spacer()
                            }
                        }
                        Spacer()
                            .frame(width: 16)
                    }
                    
                    HStack {
                        Spacer()
                            .frame(width: 16)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Prescribed Medications")
                                .font(.headline)
                                .foregroundColor(.blue)
                            ForEach(prescriptions) { prescription in
                                MedicationCardView(prescription: prescription)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        Spacer()
                            .frame(width: 16)
                        
                    }
                }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    PrescriptionPageView()
}
