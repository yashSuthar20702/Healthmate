import SwiftUI

// Chat Model for messages
struct Message: Identifiable {
    let id = UUID()
    var sender: String
    var content: String
    var isDoctor: Bool // To distinguish between doctor's and user's messages
}

struct ChatView: View {
    @Environment(\.dismiss) var dismiss
    let doctor: Doctor
    
    @State private var messages: [Message] = []
    
    @State private var newMessage: String = ""
    
    // Custom initializer
    init(doctor: Doctor) {
        self.doctor = doctor
        // Initialize the messages array with the doctor's welcome message
        _messages = State(initialValue: [
            Message(sender: "Dr. \(doctor.name)", content: "Hello! How can I assist you today?", isDoctor: true)
        ])
    }
    
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
                
                // Chat Messages
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(messages) { message in
                            HStack {
                                if message.isDoctor {
                                    Spacer()
                                        .frame(width: 16)
                                    // Doctor's message (left aligned)
                                    Text(message.content)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                        .frame(maxWidth: 250, alignment: .leading)
                                    Spacer()
                                } else {
                                    Spacer()

                                    // User's message (right aligned)
                                    Text(message.content)
                                        .padding()
                                        .background(Color.green)
                                        .cornerRadius(10)
                                        .frame(maxWidth: 250, alignment: .trailing)
                                    Spacer()
                                        .frame(width: 16)

                                }
                            }
                        }
                    }
                }
                
                // Input Field for new messages
                HStack {
                    TextField("Type a message...", text: $newMessage)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Button(action: sendMessage) {
                        Text("Send")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .padding(.leading, 10)
                }
                .padding()
            }
        }
        .onTapGesture(perform: {
            self.hideKeyboard()
        })
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
    
    func sendMessage() {
        // Add the user's message to the list
        if !newMessage.isEmpty {
            messages.append(Message(sender: "You", content: newMessage, isDoctor: false))
            newMessage = "" // Clear the input field
            
            // Simulate the doctor's response
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let doctorResponse = "I'm here to help you with any questions you have."
                messages.append(Message(sender: "Dr. \(doctor.name)", content: doctorResponse, isDoctor: true))
            }
        }
    }
}

#Preview {
    ChatView(doctor: .init(name: "Sophia Carter", specialty: "Cardiologist", info: "Heart specialist", experience: "10+ years", hospital: "Heart Hospital", image: "doctor1", contactNumber: "123-456-7890", email: "sophia.carter@example.com", location: "123 Heart St, City", availability: ["Monday 9AM - 5PM", "Tuesday 10AM - 3PM"]))
}
