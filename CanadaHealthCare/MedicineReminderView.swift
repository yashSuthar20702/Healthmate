import SwiftUI
import UserNotifications
//
struct MedicineReminder: Identifiable {
    let id = UUID()
    let name: String
    let time: Date
}
//
class ReminderViewModel: ObservableObject {
    @Published var reminders: [MedicineReminder] = []

    init() {
        // Add some static data
        addStaticReminders()
    }

    func addStaticReminders() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"

        // Example static reminders
        let remindersData = [
            ("Aspirin", "2023/10/05 09:00"),
            ("Metformin", "2023/10/05 13:00"),
            ("Lisinopril", "2023/10/05 20:00")
        ]

        for (name, timeString) in remindersData {
            if let time = dateFormatter.date(from: timeString) {
                let newReminder = MedicineReminder(name: name, time: time)
                reminders.append(newReminder)
                scheduleNotification(for: newReminder)
            }
        }
    }

    func addReminder(name: String, time: Date) {
        let newReminder = MedicineReminder(name: name, time: time)
        DispatchQueue.main.async {
            self.reminders.append(newReminder)
        }
        scheduleNotification(for: newReminder)
    }

    func scheduleNotification(for reminder: MedicineReminder) {
        let content = UNMutableNotificationContent()
        content.title = "Medicine Reminder"
        content.body = "It's time to take your medicine: \(reminder.name)"
        content.sound = .default
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: reminder.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
}
//
//struct MedicineReminderCardView: View {
//    @ObservedObject var viewModel: ReminderViewModel
//    @State private var medicineName = ""
//    @State private var selectedDate = Date()
//    @State private var selectedTime = Date()
//    @State private var isSheetPresented = false
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Medicine Reminders")
//                .font(.title2)
//                .fontWeight(.bold)
//                .padding(.bottom, 5)
//
//            if viewModel.reminders.isEmpty {
//                Text("No reminders now. Please add one.")
//                    .foregroundColor(.gray)
//                    .padding()
//            } else {
//                List(viewModel.reminders) { reminder in
//                    HStack {
//                        Text(reminder.name)
//                        Spacer()
//                        Text(reminder.time, style: .time)
//                            .foregroundColor(.gray)
//                    }
//                }
//            }
//
//            Button(action: {
//                isSheetPresented = true
//            }) {
//                Text("Add Reminder")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding(.top, 10)
//
//            Spacer()
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
//        .sheet(isPresented: $isSheetPresented) {
//            VStack {
//                Form {
//                    Section(header: Text("Add New Reminder")) {
//                        TextField("Medicine Name", text: $medicineName)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .padding(.bottom, 10)
//                            .disableAutocorrection(true)
//                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
//                            .datePickerStyle(GraphicalDatePickerStyle())
//                        DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
//                    }
//                }
//                Button("Add Reminder") {
//                    // Combine the date and time
//                    let calendar = Calendar.current
//                    let hour = calendar.component(.hour, from: selectedTime)
//                    let minute = calendar.component(.minute, from: selectedTime)
//
//                    // Create a combined date using the selected date and selected time
//                    var components = calendar.dateComponents(in: .current, from: selectedDate)
//                    components.hour = hour
//                    components.minute = minute
//                    components.second = 0 // reset seconds if needed
//
//                    if let combinedDate = calendar.date(from: components) {
//                        viewModel.addReminder(name: medicineName, time: combinedDate)
//                        medicineName = ""
//                        isSheetPresented = false
//                    }
//                }
//                .padding()
//            }
//            .padding()
//            .presentationDetents([.fraction(0.5)])
//        }
//        .onAppear {
//            viewModel.requestNotificationPermission()
//        }
//    }
//}
//
//#Preview {
//    MedicineReminderCardView(viewModel: ReminderViewModel())
//}
