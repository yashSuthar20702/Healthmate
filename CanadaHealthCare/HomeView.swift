import SwiftUI
import MapKit

struct HomeView: View {
    let features: [(String, AnyView, String, Bool)] = [
        ("Mental Wellness", AnyView(MentalWellnessPageView()), "heart.fill", false),
        ("Prescriptions", AnyView(PrescriptionPageView()), "pills.fill", false),
        ("Find Doctor", AnyView(FindDoctorView()), "person.3.fill", false),
        ("Disease", AnyView(DiseaseListView()), "diseases", true),
        ("Health Alerts", AnyView(HealthAlertsView()), "exclamationmark.circle.fill", false),
        ("Emergency", AnyView(EmergencyPage()), "waveform.path.ecg", false),
    ]
    
    let appointments: [Appointment] = [
        Appointment(id: UUID(), doctorName: "Dr. Smith", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
        Appointment(id: UUID(), doctorName: "Dr. Johnson", date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
        Appointment(id: UUID(), doctorName: "Dr. Patel", date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!)
    ]
    
    // Static reminders data
    @State private var reminders: [MedicineReminder] = [
        MedicineReminder(name: "Aspirin", time: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!),
        MedicineReminder(name: "Metformin", time: Calendar.current.date(byAdding: .hour, value: 3, to: Date())!),
        MedicineReminder(name: "Lisinopril", time: Calendar.current.date(byAdding: .hour, value: 5, to: Date())!)
    ]
    
    @State private var newMedicineName: String = ""
    @State private var newMedicineTime: Date = Date()
    
    @State private var showMapView = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)

                // Background Gradient
                VisualEffectBlur(style: .light) // Add blur as needed
                
                VStack {
                    Spacer()
                        .frame(height: 60)
                    headerSection
                        .padding(16)
                    ScrollView {
                        VStack(spacing: 15) {
                            actionsSection
                            reminderSection
                            addReminderSection
                            mapSection
                            doctorListSection
                            appointmentSection
                            footerSection
                        }
                        .padding()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)
        }

    }
    
    private var headerSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Your Health Hub")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Image(uiImage: UIImage(named: "icon") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 20)
            }
        }
    }
    
    private var appointmentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upcoming Appointments")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ForEach(appointments, id: \.id) { appointment in
                AppointmentCardView(appointment: appointment)
            }
        }
    }
    
    private var reminderSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Medicine Reminders")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ForEach(reminders) { reminder in
                MedicineReminderCard(reminder: reminder, removeAction: {
                    if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                        reminders.remove(at: index)
                    }
                })
            }
        }
    }
    
    private var addReminderSection: some View {
        VStack(alignment: .leading) {
            Text("Add Medicine Reminder")
                .font(.title3)
                .padding(.horizontal)
            
            HStack {
                TextField("Enter medicine name", text: $newMedicineName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                DatePicker("", selection: $newMedicineTime, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                Button(action: addReminder) {
                    Text("Add")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func addReminder() {
        let newReminder = MedicineReminder(name: newMedicineName, time: newMedicineTime)
        reminders.append(newReminder)
        newMedicineName = "" // Reset the text field
    }
    
    private var actionsSection: some View {
        VStack(alignment: .leading) {
            Text("Quick Actions")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            
            // Use LazyVGrid to create a vertical grid of actions
            let layout = GridItem(.flexible(), spacing: 20)
            LazyVGrid(columns: [layout, layout, layout], spacing: 20) {
                ForEach(features, id: \.0) { feature in
                    NavigationLink(destination: feature.1) {
                        SquareCardView(title: feature.0, imageName: feature.2, fromUiImage: feature.3)
                    }
                }
            }
            .padding(.vertical)
        }
    }

    // Doctor List Section (now horizontal)
    private var doctorListSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Doctors List")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                Spacer()
                
                NavigationLink(destination: FindDoctorView()) {
                    Text("See all")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(doctors) { doctor in
                        NavigationLink(destination: DoctorDetailView(doctor: doctor)) {
                            DoctorCardsView(doctor: doctor)
                        }
                    }
                }
            }
        }
    }
    
    private var mapSection: some View {
        HStack {
            Spacer()
            NavigationLink(destination: MapView()) {
                MapCardView(onGetDirectionsTapped: {})
            }
            Spacer()
        }
    }
    
    private var footerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Need Assistance?")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
            
            Text("If you need help with anything related to your health, don't hesitate to contact our support team.")
                .font(.body)
                .foregroundColor(.gray)
            
            NavigationLink(destination: SimpleView(title: "Contact Us")) {
                Text("Contact Support")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.top, 10)
            }
        }
        .padding(.top)
    }
}

// Medicine Reminder Card
struct MedicineReminderCard: View {
    let reminder: MedicineReminder
    let removeAction: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(reminder.name)
                    .font(.headline)
                Text("Time: \(reminder.time, formatter: dateFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: removeAction) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        .shadow(radius: 5)
    }
}

// Date Formatter
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

// Doctor Card View for the horizontal list
struct DoctorCardsView: View {
    let doctor: Doctor
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
                .shadow(radius: 5)
            HStack {
                Spacer()
                    .frame(width: 5)
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 5)
                    Text(doctor.name)
                        .font(.title2)
                    Text(doctor.specialty)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                        .frame(height: 5)
                }
                .padding(20)
                Spacer()
                    .frame(width: 5)
            } // Adjust the size for cards
        }
        .padding() // Adds some padding around the card
    }
}

struct SquareCardView: View {
    let title: String
    let imageName: String
    let fromUiImage: Bool
    
    var body: some View {
        VStack {
            if fromUiImage == false {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)))
            }
            else {
                Image(uiImage: UIImage(named: imageName) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)))

            }
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 5)
        }
        .frame(width: 100, height: 100)
        .background(Color("CardBackground"))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct FitnessNutritionView: View {
    var body: some View {
        SimpleView(title: "Fitness & Nutrition")
    }
}

struct SimpleView: View {
    let title: String
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .bold()
            Spacer()
        }
        .padding()
        .navigationTitle(title)
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    HomeView()
}
