//
//  Models.swift
//  CanadaHealthCare
//
//  Created by Yash Suthar on 2025-03-08.
//

import Foundation
import Foundation

struct Product: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let price: Double
    let imageName: String
}
