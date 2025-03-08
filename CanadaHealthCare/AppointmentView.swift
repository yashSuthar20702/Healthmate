import SwiftUI

struct AppointmentView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var selectedDate = Date()
    @State private var showingAlert = false
    @State private var showingConfirmation = false
    @State private var alertMessage: String = ""
    let doctor: Doctor
    @Environment(\.dismiss) var dismiss
    
    init(doctor: Doctor) {
        self.doctor = doctor
    }
    
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
                    }, heading: doctor.name)
                    Spacer()
                    
                    Form {
                        Section(header: Text("Your Details")) {
                            TextField("Full Name", text: $name)
                                .textContentType(.name)
                                .autocapitalization(.words)
                            TextField("Email", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                        }
                        Section(header: Text("Select Appointment Date & Time")) {
                            DatePicker("Date & Time", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(GraphicalDatePickerStyle())
                        }
                        Section {
                            Button(action: bookAppointment) {
                                Text("Book Appointment")
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                }
            }
            .edgesIgnoringSafeArea(.all)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $showingConfirmation) {
                Alert(
                    title: Text("Appointment Confirmed"),
                    message: Text("You have booked an appointment with \(doctor.name) on \(formattedDate())"),
                    dismissButton: .default(Text("OK")) {
                        dismiss() // Dismiss the appointment view after confirmation
                    }
                )
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
    }

    func bookAppointment() {
        // Basic validation
        guard !name.isEmpty, !email.isEmpty else {
            alertMessage = "Please fill in all details."
            showingAlert = true
            return
        }
        
        // If validation passes, show confirmation alert
        showingConfirmation = true
    }

    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: selectedDate)
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentView(doctor: .init(name: "Sophia Carter", specialty: "Cardiologist", info: "Heart specialist", experience: "10+ years", hospital: "Heart Hospital", image: "doctor1", contactNumber: "123-456-7890", email: "sophia.carter@example.com", location: "123 Heart St, City", availability: ["Monday 9AM - 5PM", "Tuesday 10AM - 3PM"]))
    }
}
