import SwiftUI

// DoctorDetailView
struct DoctorDetailView: View {
    let doctor: Doctor
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
                }, heading: doctor.name)
                Spacer()
                
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Doctor Image
                        Image(doctor.image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.bottom, 20)
                                                
                        Text(doctor.specialty)
                            .font(.title2)
                            .foregroundColor(.blue)
                            .padding(.bottom, 10)
                        
                        Text(doctor.info)
                            .font(.body)
                            .foregroundColor(.gray)
                            .lineLimit(nil)
                        
                        Divider()
                        
                        // Doctor's Contact Information
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(.white)
                            HStack {
                                Spacer()
                                    .frame(width: 16)
                                VStack(alignment: .leading) {
                                    Spacer()
                                        .frame(height: 16)
                                    Text("Experience: \(doctor.experience)")
                                    Text("Hospital: \(doctor.hospital)")
                                    Text("Location: \(doctor.location)")
                                    Text("Contact: \(doctor.contactNumber)")
                                    Text("Email: \(doctor.email)")
                                    Spacer()
                                    
                                    Text("Availability:")
                                        .fontWeight(.bold)
                                    ForEach(doctor.availability, id: \.self) { time in
                                        Text(time)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                        .frame(height: 16)
                                }
                                Spacer()
                            }
                        }
                        
                        Spacer()
                        
                        // Action Buttons
                        HStack {
                            NavigationLink(destination: ChatView(doctor: doctor)) {
                                Text("Chat with Doctor")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            NavigationLink(destination: AppointmentView(doctor: doctor)) {
                                Text("Book Appointment")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.top, 20)
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    DoctorDetailView(doctor: .init(name: "Dr. Sophia Carter", specialty: "Cardiologist", info: "Heart specialist", experience: "10+ years", hospital: "Heart Hospital", image: "doctor1", contactNumber: "123-456-7890", email: "sophia.carter@example.com", location: "123 Heart St, City", availability: ["Monday 9AM - 5PM", "Tuesday 10AM - 3PM"]))
}
