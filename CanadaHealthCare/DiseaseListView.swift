import SwiftUI

// Disease Model
struct Disease: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let image: String // Image name in assets
    let causes: String
    let symptoms: [String]
    let treatment: String
    let prevention: String
    let faq: [String]
    let resources: [String]
}

// Sample Diseases Data
let diseases = [
    Disease(
        name: "Diabetes",
        description: "A chronic disease that affects how your body processes blood sugar.",
        image: "sugar-blood-level",
        causes: "Caused by genetic factors, poor diet, lack of exercise, and obesity.",
        symptoms: ["Increased thirst", "Frequent urination", "Fatigue", "Blurred vision"],
        treatment: "Medications like insulin or metformin. Lifestyle changes like a balanced diet and regular exercise.",
        prevention: "Maintain a healthy weight, exercise regularly, avoid sugary foods.",
        faq: ["What is diabetes?", "How do I know if I have diabetes?", "Can diabetes be reversed?"],
        resources: ["https://www.diabetes.ca/campaigns/information-referral-virtual-care#:~:text=Here%20are%20examples%20of%20how,and%20services%20in%20your%20community"]
    ),
    Disease(
        name: "Hypertension",
        description: "A condition in which blood pressure is consistently too high.",
        image: "hypertension",
        causes: "Caused by stress, high salt intake, obesity, and lack of exercise.",
        symptoms: ["Headaches", "Dizziness", "Shortness of breath"],
        treatment: "Lifestyle changes such as a low-sodium diet, medication, and regular exercise.",
        prevention: "Reduce salt intake, exercise regularly, maintain a healthy weight.",
        faq: ["What is hypertension?", "Can hypertension be cured?"],
        resources: ["https://www.mayoclinic.org/diseases-conditions/high-blood-pressure/symptoms-causes/syc-20373410", "https://www.hqontario.ca/Portals/0/documents/evidence/quality-standards/qs-hypertension-en.pdf"]
    ),
    Disease(
        name: "Cancer",
        description: "A group of diseases involving abnormal cell growth.",
        image: "ribbon",
        causes: "Genetic mutations, exposure to carcinogens, smoking, and poor lifestyle choices.",
        symptoms: ["Unexplained weight loss", "Persistent cough", "Lumps or swelling", "Fatigue"],
        treatment: "Chemotherapy, radiation therapy, surgery, and immunotherapy.",
        prevention: "Avoid smoking, eat a healthy diet, exercise regularly, get regular screenings.",
        faq: ["What are the early signs of cancer?", "Can cancer be prevented?"],
        resources: ["https://www.cancerresearch.org", "https://www.muraloncology.com/?gad_source=1&gbraid=0AAAAAqgztq4bBJpB3Rk-hGEVy7rp608vt&gclid=Cj0KCQiA8q--BhDiARIsAP9tKI3ogrMjSGsjxAObgVsMuEybdLHDfxW5jLLCr41zPDD_iq9pk_KtevkaAvyyEALw_wcB"]
    ),
    Disease(
        name: "Asthma",
        description: "A respiratory condition that causes difficulty in breathing.",
        image: "asthma",
        causes: "Allergens, pollution, respiratory infections, and genetic factors.",
        symptoms: ["Shortness of breath", "Wheezing", "Chest tightness", "Coughing"],
        treatment: "Inhalers, bronchodilators, and anti-inflammatory medications.",
        prevention: "Avoid allergens, use air purifiers, follow prescribed medications.",
        faq: ["What triggers asthma attacks?", "Can asthma be cured?"],
        resources: ["https://asthma.ca", "https://www.smgh.ca/areas-of-care/respiratory-thoracic-care/outpatient-respiratory-care"]
    )
]

// Main View (Disease List)
struct DiseaseListView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                VStack {
                    Spacer()
                        .frame(height: 60)
                    HeaderView(buttonAction: {
                        dismiss()
                    }, heading: "Disease")
                    Spacer()
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(diseases) { disease in
                                NavigationLink(destination: DiseaseDetailView(disease: disease)) {
                                    DiseaseCardView(disease: disease)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)

    }
}

// Disease Card View (Each disease displayed as a card)
struct DiseaseCardView: View {
    let disease: Disease
    var body: some View {
        HStack(spacing: 15) {
            // Disease Image
            Image(uiImage: UIImage(named: disease.image) ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            VStack(alignment: .leading, spacing: 5) {
                Text(disease.name)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(disease.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding()
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    DiseaseListView()
}
