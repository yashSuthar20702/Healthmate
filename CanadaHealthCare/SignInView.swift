import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isNavigating = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Sticky Header
                    headerSection

                    Spacer()

                    // Welcome Message
                    welcomeSection

                    // Card UI for Sign In Form
                    signInForm

                    // Sign Up Navigation
                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign Up")
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                    }

                    // Sign In Navigation
                    NavigationLink(destination: HomeView(), isActive: $isNavigating) {                   }

                    Spacer()
                }
            }
        }
        .onTapGesture {
            self.hideKeyboard()
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private var headerSection: some View {
        Text("Sign In")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(height: 80)
            .shadow(radius: 3)
    }

    private var welcomeSection: some View {
        VStack(spacing: 5) {
            Text("Welcome Back! 👋")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)

            Text("Sign in to access your account and continue using our services.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 10)
    }

    private var signInForm: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)

            CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
            CustomSecureField(placeholder: "Password", text: $password)

            // Forgot Password?
            Button(action: {
                // Handle forgot password
            }) {
                Text("Forgot Password?")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .fontWeight(.semibold)
            }
            .padding(.top, -10)

            // Sign In Button
            Button(action: signIn) {
                HStack {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Sign In")
                    }
                }
                .foregroundColor(.white)
                .font(.headline)
                .frame(width: 250, height: 50)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(25)
                .shadow(radius: 3)
            }
            .disabled(isLoading) // Disable button during loading
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white.opacity(0.4))
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
    
    private func socialMediaLoginButton(label: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(label)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(width: 150, height: 45)
            .background(color)
            .cornerRadius(10)
            .shadow(radius: 3)
        }
    }

    // Function to handle sign-in logic
    private func signIn() {
        // Perform validation
        guard isValidEmail(email) && !password.isEmpty else {
            alertMessage = "Please enter a valid email and password."
            showAlert = true
            return
        }
        
        isLoading = true

        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if email.lowercased() == "admin@gmail.com" && password == "admin" {
                isNavigating = true
            } else {
                alertMessage = "Invalid email or password."
                showAlert = true
            }
            isLoading = false
        }
    }

    // Email validation function
    private func isValidEmail(_ email: String) -> Bool {
        // Basic email validation regex
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

#Preview {
    SignInView()
}
