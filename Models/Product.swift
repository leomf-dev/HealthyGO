//
//  Producto.swift
//  HealthyGO
//
//  Created by DESIGN on 16/04/26.
//

import UIKit

struct Product {
    var name: String
    var description: String
    var price: Double
    var category: String
    var imageNames: [String]
    var isAvailable: Bool // Mantenerlo al final para coincidir con el error de Xcode
}

extension Product {
    static func sampleData() -> [Product] {
        return [
            Product(name: "Ensalada Proteica", description: "Pollo, quinua y palta", price: 18.50, category: "Almuerzo", imageNames: ["leaf.fill"], isAvailable: true),
            Product(name: "Jugo Detox", description: "Manzana verde y apio", price: 12.00, category: "Bebidas", imageNames: ["cup.and.saucer.fill"], isAvailable: true)
        ]
    }
}
