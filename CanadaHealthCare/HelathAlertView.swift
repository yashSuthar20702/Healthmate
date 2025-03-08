import SwiftUI
import UserNotifications
// Health Alert Model
struct HealthAlert: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let prevention: String
}
// Sample Health Alerts Data
let healthAlertsData = [
    HealthAlert(title: "Influenza (Flu)", description: "Influenza is a contagious respiratory illness caused by flu viruses.", prevention: "Get a flu vaccine yearly, wash hands, and avoid close contact with sick individuals."),
    HealthAlert(title: "COVID-19", description: "COVID-19 is a disease caused by the SARS-CoV-2 virus, leading to respiratory issues.", prevention: "Wear masks, maintain social distancing, and get vaccinated."),
    HealthAlert(title: "Dengue Fever", description: "Dengue is a mosquito-borne disease causing high fever and joint pain.", prevention: "Use mosquito repellents, remove standing water, and wear full sleeves."),
    HealthAlert(title: "Heart Disease", description: "Heart diseases affect the heart and blood vessels, leading to serious conditions.", prevention: "Eat a healthy diet, exercise regularly, and manage stress."),
    HealthAlert(title: "Diabetes", description: "Diabetes is a chronic disease affecting blood sugar levels.", prevention: "Maintain a balanced diet, exercise, and monitor blood sugar levels.")
]
// ViewModel to Handle Notifications
class HealthAlertViewModel: ObservableObject {
    @Published var healthAlerts: [HealthAlert] = healthAlertsData
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    func scheduleHealthNotification(for alert: HealthAlert) {
        let content = UNMutableNotificationContent()
        content.title = "Health Alert: \(alert.title)"
        content.body = "Stay safe! \(alert.prevention)"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false) // Trigger after 10 seconds for demo
        let request = UNNotificationRequest(identifier: alert.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
// Health Alerts List View
struct HealthAlertsView: View {
    @StateObject var viewModel = HealthAlertViewModel()
    @State private var searchText = ""
    @Environment(\.dismiss) var dismiss

    var filteredAlerts: [HealthAlert] {
        
        if searchText.isEmpty {
            return viewModel.healthAlerts
        } else {
            return viewModel.healthAlerts.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
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
                    }, heading: "Health Alert")
                    Spacer()
                        SearchBar(text: $searchText)
                        List(filteredAlerts) { alert in
                            NavigationLink(destination: HealthAlertDetailView(alert: alert, viewModel: viewModel)) {
                                VStack(alignment: .leading) {
                                    Text(alert.title)
                                        .font(.headline)
                                    Text(alert.description)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                    .onAppear {
                        viewModel.requestNotificationPermission()
                    }
                }
            .edgesIgnoringSafeArea(.all)

            }
            .navigationBarBackButtonHidden()
            .navigationBarHidden(true)

    }
}
// Health Alert Detail View
struct HealthAlertDetailView: View {
    let alert: HealthAlert
    let viewModel: HealthAlertViewModel
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
                }, heading: alert.title)
                Spacer()
                VStack(alignment: .leading, spacing: 15) {
                    Text(alert.title)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(alert.description)
                        .font(.body)
                    Text("Prevention:")
                        .font(.headline)
                        .padding(.top)
                    Text(alert.prevention)
                        .font(.body)
                        .foregroundColor(.green)
                    Spacer()
                    Button(action: {
                        viewModel.scheduleHealthNotification(for: alert)
                    }) {
                        Text("Remind Me")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(16)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
    }
}
// Search Bar Component
struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        HStack {
            TextField("Search health alerts...", text: $text)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}
// Preview
#Preview {
    HealthAlertsView()
}






