import SwiftUI
import AVKit
import WebKit

// Data Models for Each Section
struct MentalWellnessSection: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let learnMoreURL: String // Added URL property for Learn More button
}

let wellnessSections = [
    MentalWellnessSection(title: "Introduction to Mental Wellness", description: "Mental wellness is the foundation of a healthy mind and body. It's important to take care of your mental health by practicing mindfulness, self-care, and building healthy habits.", learnMoreURL: "https://www.mentalhealth.gov/basics/what-is-mental-health"),
    MentalWellnessSection(title: "Mental Health Resources", description: "Explore a variety of resources including articles, videos, and professional help to improve your mental health and well-being.", learnMoreURL: "https://www.mentalhealth.gov/get-help"),
    MentalWellnessSection(title: "Mindfulness & Meditation", description: "Take a moment for mindfulness exercises and guided meditation to help reduce stress, calm your mind, and find inner peace.", learnMoreURL: "https://www.headspace.com/meditation"),
    MentalWellnessSection(title: "Mental Wellness Tips & Habits", description: "Adopt simple daily tips and habits to maintain and improve mental wellness, such as staying active, sleeping well, and practicing gratitude.", learnMoreURL: "https://www.psychologytoday.com/us/basics/mental-health/10-ways-to-improve-your-mental-health"),
    MentalWellnessSection(title: "Mood Tracker", description: "Track your mood daily to identify patterns and better understand your mental state. Use the mood tracker to improve your emotional health.", learnMoreURL: "https://www.moodfitapp.com/"),
    MentalWellnessSection(title: "Self-Care Activities", description: "Engage in activities that help you relax, recharge, and prioritize your mental well-being, like journaling, exercising, or creative hobbies.", learnMoreURL: "https://psychcentral.com/lib/types-of-self-care")
]

// Main Mental Wellness View
struct MentalWellnessPageView: View {
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
                    }, heading: "Mental Wellness")
                    Spacer()
                    ScrollView {

                        // Sections
                        ForEach(wellnessSections) { section in
                            HStack{
                                Spacer()
                                    .frame(width: 16)
                                SectionCardView(section: section)
                                Spacer()
                                    .frame(width: 16)
                            }
                        }
                        
                        
                        // Insert relaxing video and music in between
                    HStack{
                        Spacer()
                            .frame(width: 16)
                        RelaxingVideoPlayerView(videoURL: "https://www.youtube.com/watch?v=z-qigE1ym40")
                        Spacer()
                            .frame(width: 16)
                    }
                    HStack{
                        Spacer()
                            .frame(width: 16)
                        RelaxingMusicPlayerView(songURL: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") // Example audio file URL
                        Spacer()
                            .frame(width: 16)
                    }
                    HStack{
                        Spacer()
                            .frame(width: 16)
                        
                        // Mood Tracker
                        MoodTrackerView()
                        Spacer()
                            .frame(width: 16)
                    }
                    Spacer()

                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

// Relaxing Video Player View
struct RelaxingVideoPlayerView: View {
    var videoURL: String
    
    var body: some View {
        VStack {
            Text("Relaxing Video")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            // Embed YouTube video using WKWebView
            if let url = URL(string: videoURL) {
                WebView(url: url)
                    .frame(height: 250)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            } else {
                Text("Invalid video URL")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// WebView component to load YouTube content
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

// Relaxing Music Player View
struct RelaxingMusicPlayerView: View {
    var songURL: String
    
    var body: some View {
        HStack{
            VStack {
                Text("Relaxing Music")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                // Music Player (Play/Pause) Button
                Button(action: {
                    playMusic(urlString: songURL)
                }) {
                    Text("Play Relaxing Music")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

// Function to play music using AVPlayer
func playMusic(urlString: String) {
    if let url = URL(string: urlString) {
        let player = AVPlayer(url: url)
        player.play()
    }
}

// Section Card View
struct SectionCardView: View {
    let section: MentalWellnessSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(section.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Text(section.description)
                .font(.body)
                .foregroundColor(.gray)
                .lineLimit(3)
            Button(action: {
                openURL(urlString: section.learnMoreURL)
            }) {
                Text("Learn More")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.top, 5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// Function to open the URL in the browser
func openURL(urlString: String) {
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url)
    }
}

// Mood Tracker View
struct MoodTrackerView: View {
    @State private var selectedMood: String = "Neutral"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mood Tracker")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Text("How are you feeling today?")
                .font(.body)
                .foregroundColor(.gray)
            
            HStack {
                MoodButton(mood: "Happy", selectedMood: $selectedMood)
                MoodButton(mood: "Sad", selectedMood: $selectedMood)
                MoodButton(mood: "Stressed", selectedMood: $selectedMood)
                MoodButton(mood: "Neutral", selectedMood: $selectedMood)
            }
            
            Text("Your mood: \(selectedMood)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            Button(action: {
                openYouTubePodcast(mood: selectedMood)
            }) {
                Text("Save Mood")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

// Function to Open YouTube Podcast based on mood
func openYouTubePodcast(mood: String) {
    var urlString: String
    
    switch mood {
    case "Happy":
        urlString = "https://www.youtube.com/watch?v=4pLUleLdwY4" // Guided Meditation for Happiness
    case "Sad":
        urlString = "https://www.youtube.com/watch?v=ZrPzFkGy4gs" // Uplifting Music for Sadness
    case "Stressed":
        urlString = "https://www.youtube.com/watch?v=4pLUleLdwY4" // Guided Meditation for Stress
    case "Neutral":
        urlString = "https://www.youtube.com/watch?v=Jyy0v2ezPMI" // Relaxing Music for Neutral Mood
    default:
        urlString = "https://www.youtube.com/watch?v=4pLUleLdwY4" // Default Video
    }
    
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url)
    }
}

// Mood Button
struct MoodButton: View {
    let mood: String
    @Binding var selectedMood: String
    
    var body: some View {
        Button(action: {
            selectedMood = mood
        }) {
            Text(mood)
                .padding()
                .background(selectedMood == mood ? Color.blue : Color.gray.opacity(0.3))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

// Preview
struct MentalWellnessPageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MentalWellnessPageView()
        }
    }
}
