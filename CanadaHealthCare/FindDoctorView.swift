//
//  FindDoctorView.swift
//  CanadaHealthCare
//
//  Created by Yash Suthar on 2025-03-07.
//

import SwiftUI
// Doctor Model
struct Doctor: Identifiable, Codable {
    let id: UUID
    let name: String
    let specialty: String
    let info: String
    let experience: String
    let hospital: String
    let image: String
    let contactNumber: String
    let email: String
    let location: String
    let availability: [String] // Example: ["Monday 9AM - 5PM", "Tuesday 10AM - 3PM"]
    init(id: UUID = UUID(), name: String, specialty: String, info: String, experience: String, hospital: String, image: String, contactNumber: String, email: String, location: String, availability: [String]) {
        self.id = id
        self.name = name
        self.specialty = specialty
        self.info = info
        self.experience = experience
        self.hospital = hospital
        self.image = image
        self.contactNumber = contactNumber
        self.email = email
        self.location = location
        self.availability = availability
    }
}


// Sample Doctor Data
let doctors = [
    Doctor(name: "Dr. Sophia Carter", specialty: "Cardiologist", info: "Expert in heart health with 10+ years of experience.", experience: "10+ years", hospital: "Heart Hospital", image: "doctor1", contactNumber: "123-456-7890", email: "sophia.carter@example.com", location: "123 Heart St, City", availability: ["Monday 9AM - 5PM", "Tuesday 10AM - 3PM"]),
    Doctor(name: "Dr. Liam Patel", specialty: "Neurologist", info: "Specializes in brain and nervous system disorders.", experience: "8 years", hospital: "NeuroCare Clinic", image: "doctor2", contactNumber: "234-567-8901", email: "liam.patel@example.com", location: "456 Brain Ave, City", availability: ["Monday 8AM - 4PM", "Wednesday 9AM - 5PM"]),
    Doctor(name: "Dr. Ava Thompson", specialty: "Dermatologist", info: "Skincare and cosmetic treatment specialist.", experience: "6 years", hospital: "SkinCare Center", image: "doctor3", contactNumber: "345-678-9012", email: "ava.thompson@example.com", location: "789 Skin Rd, City", availability: ["Tuesday 9AM - 3PM", "Friday 11AM - 6PM"]),
    Doctor(name: "Dr. Noah Kim", specialty: "Pediatrician", info: "Passionate about child healthcare & well-being.", experience: "5 years", hospital: "Kids Care Clinic", image: "doctor4", contactNumber: "456-789-0123", email: "noah.kim@example.com", location: "101 Kids Blvd, City", availability: ["Monday 10AM - 2PM", "Thursday 9AM - 4PM"])
]

import SwiftUI

// Main View (Doctor List)
struct FindDoctorView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                VStack {
                    Spacer()
                        .frame(height: 60)
                    HeaderView(buttonAction: {
                        dismiss()
                    }, heading: "Doctors")
                    Spacer()
                    
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(doctors) { doctor in
                            NavigationLink(destination: DoctorDetailView(doctor: doctor)) {
                                VStack {
                                    DoctorCardView(doctor: doctor)
                                    Spacer()
                                        .frame(height: 10)
                                }
                            }
                            .buttonStyle(PlainButtonStyle()) // To remove default link styling
                        }
                    }
                    .padding()
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)

    }
}

// Doctor Card View
struct DoctorCardView: View {
    let doctor: Doctor
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
            HStack {
                Spacer()
                    .frame(width: 16)

                VStack {
                    Spacer()
                        .frame(height: 10)
                    VStack(alignment: .leading, spacing: 15) {
                        HStack(spacing: 15) {
                            Image(uiImage: UIImage(named: doctor.image) ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 3)
                            VStack(alignment: .leading, spacing: 5) {
                                Text(doctor.name)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text(doctor.specialty)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Text(doctor.info)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Experience: \(doctor.experience)")
                                .font(.subheadline)
                            Text("Hospital: \(doctor.hospital)")
                                .font(.subheadline)
                            Text("Location: \(doctor.location)")
                                .font(.subheadline)
                            Text("Contact: \(doctor.contactNumber)")
                                .font(.subheadline)
                            Text("Email: \(doctor.email)")
                                .font(.subheadline)
                            Text("Availability:")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            ForEach(doctor.availability, id: \.self) { time in
                                Text(time)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    Spacer()
                        .frame(height: 10)
                    
                }
                Spacer()
                    .frame(width: 16)
            }
        }
    }
}

// Preview
struct FindDoctorView_Previews: PreviewProvider {
    static var previews: some View {
        FindDoctorView()
    }
}
