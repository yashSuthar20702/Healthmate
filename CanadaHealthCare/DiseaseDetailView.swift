//
//  DiseaseDetailView.swift
//  CanadaHealthCare
//
//  Created by Yash Suthar on 2025-03-07.
//

import SwiftUI

struct DiseaseDetailView: View {
    let disease: Disease
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
                }, heading: "Disease details")
                Spacer()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Image(disease.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 10)
                        Text(disease.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text(disease.description)
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        VStack(alignment: .leading, spacing: 10) {
                            SectionHeader(title: "Causes")
                            Text(disease.causes)
                            SectionHeader(title: "Symptoms")
                            ForEach(disease.symptoms, id: \ .self) { symptom in
                                Text("• " + symptom)
                            }
                            SectionHeader(title: "Treatment")
                            Text(disease.treatment)
                            SectionHeader(title: "Prevention")
                            Text(disease.prevention)
                            SectionHeader(title: "FAQs")
                            ForEach(disease.faq, id: \ .self) { question in
                                Text("Q: " + question)
                            }
                            SectionHeader(title: "Resources")
                            ForEach(disease.resources, id: \.self) { resource in
                                if let url = URL(string: resource) {
                                    Link("🔗 " + resource, destination: url)
                                        .padding() // Optional: Add padding for better tap area
                                } else {
                                    Text("Invalid URL: " + resource)
                                        .foregroundColor(.red) // Show an error message for invalid URLs
                                }
                            }                        }
                        .padding()
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
        .navigationBarHidden(true)
    }
}
struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .padding(.top, 10)
    }
}

// Preview
struct DiseaseListView_Previews: PreviewProvider {
    static var previews: some View {
        DiseaseDetailView(disease: .init(name: "", description: "", image: "", causes: "", symptoms: [""], treatment: "", prevention: "", faq: [""], resources: [""]))
    }
}
