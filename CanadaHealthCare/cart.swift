//
//  cart.swift
//  CanadaHealthCare
//
//  Created by Yash Suthar on 2025-03-08.
//

import Foundation

class Cart: ObservableObject {
    @Published var items: [Product] = []

    func add(product: Product) {
        items.append(product)
    }

    func total() -> Double {
        items.reduce(0) { $0 + $1.price }
    }

    func clear() {
        items.removeAll()
    }
}
