import SwiftUI
import MapKit

struct MapCardView: View {
    // Add a closure parameter for the button action
    var onGetDirectionsTapped: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Find Hospitals")
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
                Button(action: {
                    onGetDirectionsTapped() // Call the closure when button is tapped
                }) {
                    Text("Get Directions")
                        .font(.system(size: 16))
                        .foregroundColor(.orange)
                        .fontWeight(.bold)
                        .padding(.trailing)
                }
            }
            .padding(.top)
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                    .shadow(radius: 8)
                
                VStack {
                    Map()
                        .mapStyle(.hybrid)
                        .disabled(true)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    HStack {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(.blue)
                            .padding(.leading, 10)
                        
                        Text("Nearby Location")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                }
            }
            .frame(height: 240)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }
}

#Preview {
    MapCardView(onGetDirectionsTapped: {
        
    })
}
