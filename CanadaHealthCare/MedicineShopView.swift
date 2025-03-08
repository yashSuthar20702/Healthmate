import SwiftUI
// Medicine Model
struct Medicine: Identifiable {
  let id = UUID()
  let name: String
  let description: String
  let price: Double
  let image: String
}
// Sample Medicines
let sampleMedicines = [
  Medicine(name: "Paracetamol", description: "Pain reliever & fever reducer.", price: 5.99, image: "pill"),
  Medicine(name: "Ibuprofen", description: "Reduces inflammation and pain.", price: 7.49, image: "capsule"),
  Medicine(name: "Cough Syrup", description: "Relieves cough & throat irritation.", price: 8.99, image: "bottle"),
  Medicine(name: "Vitamin C", description: "Boosts immunity & skin health.", price: 12.99, image: "tablet"),
  Medicine(name: "Antibiotic", description: "Fights bacterial infections.", price: 15.99, image: "medpack")
]
// ViewModel for Cart
class CartViewModel: ObservableObject {
  @Published var cart: [Medicine] = []
  @Published var isCheckedOut: Bool = false // Track if checked out
  func addToCart(medicine: Medicine) {
    cart.append(medicine)
  }
  func removeFromCart(medicine: Medicine) {
    cart.removeAll { $0.id == medicine.id }
  }
  var totalPrice: Double {
    cart.reduce(0) { $0 + $1.price }
  }
  func checkout() {
    isCheckedOut = true
  }
}
// Main Medicine Shop View
struct MedicineShopView: View {
  @StateObject var cartViewModel = CartViewModel()
  var body: some View {
    NavigationView {
      VStack {
        Text(":shopping_trolley: Medicine Shop")
          .font(.largeTitle)
          .fontWeight(.bold)
          .padding()
          .foregroundColor(.primary)
        List(sampleMedicines) { medicine in
          MedicineRow(medicine: medicine, cartViewModel: cartViewModel)
        }
        .listStyle(PlainListStyle())
        .background(Color(UIColor.systemGroupedBackground))
        NavigationLink(destination: CartView(cartViewModel: cartViewModel)) {
          Text(":shopping_bags: View Cart (\(cartViewModel.cart.count))")
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
      }
      .navigationTitle("Welcome!")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}
// Medicine Row Component
struct MedicineRow: View {
  let medicine: Medicine
  @ObservedObject var cartViewModel: CartViewModel
  var body: some View {
    HStack {
      Image(systemName: medicine.image) // Use actual images if available
        .resizable()
        .scaledToFit()
        .frame(width: 50, height: 50)
        .padding(10)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(10)
      VStack(alignment: .leading) {
        Text(medicine.name)
          .font(.headline)
        Text(medicine.description)
          .font(.subheadline)
          .foregroundColor(.gray)
        Text("$\(medicine.price, specifier: "%.2f")")
          .font(.subheadline)
          .fontWeight(.semibold)
          .foregroundColor(.green)
      }
      Spacer()
      Button(action: {
        cartViewModel.addToCart(medicine: medicine)
      }) {
        Image(systemName: "cart.badge.plus")
          .font(.title2)
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .clipShape(Circle())
      }
    }
    .padding(.vertical, 10)
    .background(Color.white)
    .cornerRadius(10)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    .padding(.horizontal)
  }
}
// Cart View
struct CartView: View {
  @ObservedObject var cartViewModel: CartViewModel
  var body: some View {
    VStack {
      Text(":shopping_trolley: Your Cart")
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding()
      List {
        ForEach(cartViewModel.cart) { medicine in
          HStack {
            VStack(alignment: .leading) {
              Text(medicine.name)
                .font(.headline)
              Text("$\(medicine.price, specifier: "%.2f")")
                .foregroundColor(.green)
            }
            Spacer()
            Button(action: {
              cartViewModel.removeFromCart(medicine: medicine)
            }) {
              Image(systemName: "trash")
                .foregroundColor(.red)
            }
          }
          .padding(.vertical, 5)
        }
      }
      .listStyle(PlainListStyle())
      Text("Total: $\(cartViewModel.totalPrice, specifier: "%.2f")")
        .font(.headline)
        .padding()
      NavigationLink(destination: PaymentView(cartViewModel: cartViewModel)) {
        Button(action: {
          cartViewModel.checkout()
        }) {
          Text("Proceed to Payment")
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
      }
      .isDetailLink(false) // Prevents double navigation
    }
    .background(Color(UIColor.systemGroupedBackground))
  }
}
// Payment View
struct PaymentView: View {
  @ObservedObject var cartViewModel: CartViewModel
  @State private var cardNumber = ""
  @State private var expirationDate = ""
  @State private var cvv = ""
  var body: some View {
    VStack {
      Text(":credit_card: Payment")
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding()
      Text("Total: $\(cartViewModel.totalPrice, specifier: "%.2f")")
        .font(.headline)
        .padding()
      VStack(spacing: 20) {
        TextField("Card Number", text: $cardNumber)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
        TextField("Expiration Date", text: $expirationDate)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
        TextField("CVV", text: $cvv)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
      }
      Button(action: {
        cartViewModel.cart.removeAll() // Simulating the payment success and clearing cart
      }) {
        Text("Pay Now")
          .font(.headline)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }
      .padding()
    }
    .background(Color(UIColor.systemGroupedBackground))
    .navigationBarTitle("Payment", displayMode: .inline)
  }
}
// Receipt View
struct ReceiptView: View {
  @ObservedObject var cartViewModel: CartViewModel
  var body: some View {
    VStack {
      Text(":receipt: Payment Receipt")
        .font(.largeTitle)
        .fontWeight(.bold)
        .padding()
      List {
        ForEach(cartViewModel.cart) { medicine in
          HStack {
            Text(medicine.name)
              .font(.headline)
            Spacer()
            Text("$\(medicine.price, specifier: "%.2f")")
              .foregroundColor(.green)
          }
        }
      }
      .listStyle(PlainListStyle())
      Text("Total: $\(cartViewModel.totalPrice, specifier: "%.2f")")
        .font(.headline)
        .padding()
      Button(action: {
        cartViewModel.cart.removeAll() // Clear the cart after showing the receipt
      }) {
        Text("Done")
          .font(.headline)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }
      .padding()
    }
    .background(Color(UIColor.systemGroupedBackground))
    .navigationBarTitle("Receipt", displayMode: .inline)
  }
}
// Preview
struct MedicineShopView_Previews: PreviewProvider {
  static var previews: some View {
    MedicineShopView()
  }
}








