import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default to San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var locations: [CustomPointAnnotation] = []
    @State private var isSearching = false // Track if searching
    @StateObject private var locationManager = LocationManager()

    // Create a state variable for userTrackingMode
    @State private var userTrackingMode: MapUserTrackingMode = .follow
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
                }, heading: "Map")
                Spacer()
                
                // Map with custom annotations for hospitals and doctors
                Map(coordinateRegion: $region,
                    showsUserLocation: true,
                    userTrackingMode: $userTrackingMode, // Bind the state variable
                    annotationItems: locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            if location.title?.lowercased().contains("hospital") == true {
                                // Use hospital logo for hospitals
                                Image(systemName: "house.fill") // Replace with hospital logo
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                            } else {
                                // Use pin for doctors or medicine shops
                                Image(systemName: "mappin.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.red)
                            }
                        }
                        .onTapGesture {
                            // Handle tap to show directions
                            showDirections(to: location.coordinate)
                        }
                    }
                }
                    .onAppear {
                        locationManager.requestLocation()
                    }
                
                VStack {
                    // Top row with hospital and medicine icons
                    HStack {
                        Image(systemName: "house.fill") // Replace with hospital logo
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                            .padding(.leading, 10)
                        
                        Text("Hospital")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.leading, 5)
                        
                        Spacer()
                        
                        Text("Medicine Shop")
                            .font(.headline)
                            .foregroundColor(.red)
                        
                        Image(systemName: "mappin.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                            .padding(.trailing, 10)
                    }
                    .padding(.top, 40) // Add padding to top
                                        
                    // Show ProgressView if searching
                    if isSearching {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .padding()
                    }
                    
                    // Button to find nearby hospitals and doctors
                    Button(action: {
                        findNearbyHospitalsAndDoctors()
                    }) {
                        Text("Find Nearby Hospitals & Doctors")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
    }

    func findNearbyHospitalsAndDoctors() {
        guard let currentLocation = locationManager.location else { return }

        // Set the isSearching state to true to show the ProgressView
        isSearching = true

        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "hospital"
        searchRequest.region = MKCoordinateRegion(
            center: currentLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let error = error {
                print("Error searching for hospitals: \(error.localizedDescription)")
                return
            }
            if let mapItems = response?.mapItems {
                self.locations = mapItems.map { item in
                    let annotation = CustomPointAnnotation()
                    annotation.id = UUID()
                    annotation.title = item.name
                    annotation.subtitle = item.placemark.title
                    annotation.coordinate = item.placemark.coordinate
                    return annotation
                }
            }

            // Repeat for doctors, if necessary:
            searchRequest.naturalLanguageQuery = "doctor"
            let doctorSearch = MKLocalSearch(request: searchRequest)
            doctorSearch.start { response, error in
                if let error = error {
                    print("Error searching for doctors: \(error.localizedDescription)")
                    return
                }
                if let mapItems = response?.mapItems {
                    self.locations.append(contentsOf: mapItems.map { item in
                        let annotation = CustomPointAnnotation()
                        annotation.id = UUID()
                        annotation.title = item.name
                        annotation.subtitle = item.placemark.title
                        annotation.coordinate = item.placemark.coordinate
                        return annotation
                    })
                }

                // Set isSearching to false after search is done
                isSearching = false
            }
        }
    }

    func showDirections(to destination: CLLocationCoordinate2D) {
        guard let currentLocation = locationManager.location else { return }

        let request = MKDirections.Request()
        let sourcePlacemark = MKPlacemark(coordinate: currentLocation.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destination)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        // Since MKMapItem is not optional, we can directly append them to the array
        let mapItems: [MKMapItem] = [sourceMapItem, destinationMapItem]

        // Now you can use the mapItems array to show directions
        MKMapItem.openMaps(with: mapItems, launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }


}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var location: CLLocation? = nil

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

// Custom Point Annotation that conforms to Identifiable
class CustomPointAnnotation: MKPointAnnotation, Identifiable {
    var id: UUID?
}

#Preview {
    MapView()
}
