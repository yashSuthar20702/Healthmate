import SwiftUI

struct ChatScreenView: View {
    var doctor: Doctor
    
    @State private var message = ""
    @State private var messages = [
        ChatMessage(id: 1, sender: "Doctor", text: "Hello! How can I help you today?")
    ]
    
    var body: some View {
        VStack {
            // Chat messages
            ScrollView {
                ForEach(messages) { message in
                    HStack {
                        if message.sender == "Doctor" {
                            // Receiver message on the left
                            Text("Dr. \(doctor.name): \(message.text)")
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(15)
                                .foregroundColor(.blue)
                                .frame(maxWidth: 300, alignment: .leading)
                                .padding(.top, 5)
                        } else {
                            // Sender message on the right
                            Spacer()
                            Text(message.text)
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(15)
                                .foregroundColor(.green)
                                .frame(maxWidth: 300, alignment: .trailing)
                                .padding(.top, 5)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // Message input area
            HStack {
                TextField("Enter your message", text: $message)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.leading)
                
                Button(action: sendMessage) {
                    Text("Send")
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.trailing)
            }
            .padding(.bottom, 10)
        }
        
        .navigationTitle("Chat with Dr. \(doctor.name)")
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    func sendMessage() {
        if !message.isEmpty {
            let newMessage = ChatMessage(id: messages.count + 1, sender: "Patient", text: message)
            messages.append(newMessage)
            message = ""
        }
    }
    
    // Function to hide the keyboard
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ChatMessage: Identifiable {
    var id: Int
    var sender: String
    var text: String
}

#Preview {
    ChatScreenView(doctor: .init(name: "John Doe", specialty: "Cardiology", info: "Expert in heart diseases", experience: "10 years", hospital: "Heart Clinic", image: "", contactNumber: "123456789", email: "doctor@example.com", location: "City", availability: ["9 AM - 5 PM"]))
}
