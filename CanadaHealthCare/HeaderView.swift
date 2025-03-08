//
//  HeaderView.swift
//  CanadaHealthCare
//
//  Created by Yash Suthar on 2025-03-08.
//

import SwiftUI

struct HeaderView: View {
    var buttonAction: () -> Void
    var heading: String

    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    buttonAction()
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

            Text(heading)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .frame(height: 60)
        .shadow(radius: 3)
    }
}

#Preview {
    HeaderView(buttonAction: {
        
    }, heading: "Yash")
}
