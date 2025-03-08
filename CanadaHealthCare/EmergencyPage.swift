import SwiftUI

// Emergency Contact Model
struct EmergencyContact: Identifiable {
    let id = UUID()
    let name: String
    let relation: String
    let number: String
}

struct EmergencyPage: View {
    @State private var isSOSAlertSent = false
    @State private var currentLocation = "Fetching..."
    @State private var emergencyContacts = [
        EmergencyContact(name: "Yash Suthar", relation: "Friend", number: "+1 234 567 890"),
        EmergencyContact(name: "Dhwani Randeri", relation: "Friend", number: "+1 987 654 321")
    ]
    @State private var showAddContactAlert = false
    @State private var newContactName = ""
    @State private var newContactRelation = ""
    @State private var newContactNumber = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                
                    VStack(spacing: 20) {
                        Spacer()
                            .frame(height: 60)
                        
                        HeaderView(buttonAction: {
                            dismiss()
                        }, heading: "Emergency")
                        ScrollView {

                        // Emergency Contacts Section
                        SectionHeaderView(title: "Emergency Contacts")
                        HorizontalScrollView(emergencyContacts: $emergencyContacts) { contact in
                            EmergencyContactCardView(contact: contact, deleteAction: { deleteContact(contact) })
                        }
                        
                        // Add Contact Button
                        Button(action: {
                            showAddContactAlert.toggle()
                        }) {
                            Text("Add Emergency Contact")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                                .shadow(radius: 5)
                                .padding(.horizontal)
                        }
                        
                        // Emergency Numbers Section
                        SectionHeaderView(title: "Emergency Numbers")
                        HStack {
                            EmergencyNumberCardView(service: "Ambulance", number: "911", icon: "phone.fill")
                            EmergencyNumberCardView(service: "Police", number: "911", icon: "shield.fill")
                        }
                        
                        // GPS Location Sharing
                        SectionHeaderView(title: "GPS Location Sharing")
                        LocationCardView(location: currentLocation, icon: "location.fill")
                        
                        // First Aid Guidelines
                        SectionHeaderView(title: "First Aid Guidelines")
                        FirstAidCardView(type: "CPR", instructions: "Start chest compressions immediately.", icon: "heart.fill")
                        
                        // SOS Button
                        SOSButtonView(isSOSAlertSent: $isSOSAlertSent)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddContactAlert) {
            AddEmergencyContactView(
                newContactName: $newContactName,
                newContactRelation: $newContactRelation,
                newContactNumber: $newContactNumber,
                addContactAction: addNewContact
            )
        }
        .onAppear {
            // Simulating GPS location fetching
            self.currentLocation = "37.7749° N, 122.4194° W (San Francisco)"
        }
    }

    private func addNewContact() {
        let newContact = EmergencyContact(name: newContactName, relation: newContactRelation, number: newContactNumber)
        emergencyContacts.append(newContact)
        newContactName = ""
        newContactRelation = ""
        newContactNumber = ""
    }

    private func deleteContact(_ contact: EmergencyContact) {
        if let index = emergencyContacts.firstIndex(where: { $0.id == contact.id }) {
            emergencyContacts.remove(at: index)
        }
    }
}

struct SectionHeaderView: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .padding(.top)
            .padding(.horizontal)
    }
}

// MARK: - Horizontal Scroll View for Emergency Contacts
struct HorizontalScrollView<Content: View>: View {
    @Binding var emergencyContacts: [EmergencyContact]
    let content: (EmergencyContact) -> Content
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(emergencyContacts) { contact in
                    content(contact)
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Emergency Contact Card View
struct EmergencyContactCardView: View {
    let contact: EmergencyContact
    var deleteAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                VStack(alignment: .leading) {
                    Text(contact.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(contact.relation)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(contact.number)
                        .font(.body)
                        .foregroundColor(.blue)
                }

                Spacer()

                Button(action: deleteAction) {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                }
                .padding(.top, 5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding([.leading, .trailing, .bottom])
    }
}

// MARK: - Emergency Number Card
struct EmergencyNumberCardView: View {
    let service: String
    let number: String
    let icon: String
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                VStack(alignment: .leading) {
                    Text(service)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(number)
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)
        }
        .padding(.horizontal)
    }
}

// MARK: - Location Card
struct LocationCardView: View {
    let location: String
    let icon: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                Text("Current Location")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            Text(location)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}

// MARK: - First Aid Card
struct FirstAidCardView: View {
    let type: String
    let instructions: String
    let icon: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green)
                Text(type)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            Text(instructions)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.horizontal)
    }
}

// MARK: - SOS Button
struct SOSButtonView: View {
    @Binding var isSOSAlertSent: Bool
    var body: some View {
        Button(action: {
            isSOSAlertSent = true
        }) {
            Text("Send SOS Alert")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(12)
                .padding(.horizontal)
                .shadow(radius: 4)
        }
        .alert(isPresented: $isSOSAlertSent) {
            Alert(title: Text("SOS Alert Sent"),
                  message: Text("Your emergency contacts have been notified."),
                  dismissButton: .default(Text("OK")))
        }
    }
}

// MARK: - Add Emergency Contact View (Custom Modal)
struct AddEmergencyContactView: View {
    @Binding var newContactName: String
    @Binding var newContactRelation: String
    @Binding var newContactNumber: String
    var addContactAction: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add New Emergency Contact").font(.headline)) {
                    TextField("Name", text: $newContactName)
                    TextField("Relation", text: $newContactRelation)
                    TextField("Phone Number", text: $newContactNumber)
                        .keyboardType(.phonePad)
                }
                Button("Save Contact") {
                    addContactAction()
                }
                .disabled(newContactName.isEmpty || newContactRelation.isEmpty || newContactNumber.isEmpty)
            }
            .navigationBarTitle("New Contact", displayMode: .inline)
        }
    }
}

// MARK: - Preview
struct EmergencyPage_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyPage()
            .preferredColorScheme(.light)
    }
}
