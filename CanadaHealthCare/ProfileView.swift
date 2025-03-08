import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    let features: [(String, AnyView, String)] = [
        ("Mental Wellness", AnyView(MentalWellnessPageView()), "heart.fill"),
        ("Prescriptions", AnyView(PrescriptionPageView()), "pills.fill"),
        ("Find Doctor", AnyView(FindDoctorView()), "person.3.fill"),
        ("Health Alerts", AnyView(HealthAlertsView()), "exclamationmark.circle.fill"),
        ("Emergency", AnyView(EmergencyPage()), "waveform.path.ecg"),
    ]
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
                    }, heading: "Profile")
                    
                    Spacer()
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(features, id: \.0) { feature in
                                NavigationLink(destination: feature.1) {
                                    CardView(title: feature.0, imageName: feature.2)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle logout here
                        isLoggedIn = false
                    }) {
                        Text("Logout")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
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

struct CardView: View {
    let title: String
    let imageName: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)

            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                    .padding()

                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.leading, 5)

                Spacer()
            }
            .padding()
        }
        .frame(height: 100) // Set a fixed height for the card
    }
}

#Preview {
    ProfileView(isLoggedIn: .constant(true))
}
