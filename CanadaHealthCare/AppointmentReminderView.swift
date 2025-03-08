//
//  AppointmentReminderView.swift
//  CanadaHealthCare
//
//  Created by Yash Suthar on 2025-03-08.
//


import SwiftUI

struct AppointmentCardView: View {
    var appointment: Appointment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(appointment.doctorName)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(dateFormatter.string(from: appointment.date))
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack {
                Spacer()
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}

// MARK: - Appointment Model
struct Appointment: Identifiable {
    var id: UUID
    var doctorName: String
    var date: Date
}

//// MARK: - Date Formatter
//private let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    formatter.timeStyle = .short
//    return formatter
//}()

// MARK: - Notification Functions
func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
            print("Notification permission error: \(error.localizedDescription)")
        }
    }
}

func scheduleReminders() {
    let appointments: [Appointment] = [
        Appointment(id: UUID(), doctorName: "Dr. Smith", date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
        Appointment(id: UUID(), doctorName: "Dr. Johnson", date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
        Appointment(id: UUID(), doctorName: "Dr. Patel", date: Calendar.current.date(byAdding: .day, value: 5, to: Date())!)
    ]
    
    for appointment in appointments {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Appointment Reminder"
        content.body = "Your appointment with \(appointment.doctorName) is on \(dateFormatter.string(from: appointment.date))."
        content.sound = .default
        
        let triggerDate = Calendar.current.date(byAdding: .hour, value: -1, to: appointment.date) ?? appointment.date
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: appointment.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}

struct AppointmentCardView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentCardView(appointment: Appointment(id: UUID(), doctorName: "Dr. Smith", date: Date()))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.2))
    }
}
