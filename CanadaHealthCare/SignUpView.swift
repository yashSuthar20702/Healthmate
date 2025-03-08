import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var dateOfBirth = Date()
    @State private var selectedGender = "Male"
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isNavigating = false
    @Environment(\.dismiss) var dismiss
    
    let genders = ["Male", "Female", "Other"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    VStack {
                        // Custom Back Button
                        ZStack {
                            HStack {
                                Button(action: {
                                    dismiss()
                                }) {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .padding()
                                        .background(Color.blue.opacity(0.7))
                                        .clipShape(Circle())
                                }
                                Spacer()
                            }
                            .padding(.leading)

                            Text("Sign Up")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        .frame(height: 80)
                        .shadow(radius: 3)
                        
                        // Card Layout
                        VStack(spacing: 20) {
                            
                            CustomTextField(placeholder: "Full Name", text: $fullName)
                            CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                            CustomTextField(placeholder: "Phone Number", text: $phoneNumber, keyboardType: .phonePad)
                            
                            // DOB Picker
                            VStack(alignment: .leading) {
                                Text("Date of Birth")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 10)
                                DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                                    .padding(.horizontal)
                            }
                            
                            // Gender Picker
                            VStack(alignment: .leading) {
                                Text("Gender")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                    .padding(.leading, 10)
                                Picker("Gender", selection: $selectedGender) {
                                    ForEach(genders, id: \.self) { gender in
                                        Text(gender).tag(gender)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .padding(.horizontal)
                            }
                            
                            CustomSecureField(placeholder: "Password", text: $password)
                            CustomSecureField(placeholder: "Confirm Password", text: $confirmPassword)
                            
                            // Sign Up Button
                            Button(action: {
                                isNavigating = true
                            }) {
                                Text("Sign Up")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .frame(width: 250, height: 50)
                                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                    .cornerRadius(25)
                                    .shadow(radius: 3)
                            }
                            .padding(.top, 20)
                        }
                        .padding()
                        .background(Color.white.opacity(0.4))
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        
                        .navigationDestination(isPresented: $isNavigating, destination: {
                            HomeView()
                        })
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
            }
        }
        
        .navigationBarBackButtonHidden()
    }
}

// Reusable Custom TextField
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
            .padding(.horizontal)
            .keyboardType(keyboardType)
            .autocapitalization(.none)
    }
}

// Reusable Custom SecureField
struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
            .padding(.horizontal)
    }
}

#Preview {
    SignUpView()
}

