//
//  CartItem.swift
//  HealthyGO
//
//  Created on 18/04/26.
//

import Foundation

struct CartItem {
    let product: Product
    var quantity: Int
    
    // Cálculo automático del subtotal por producto [cite: 99, 102]
    var subtotal: Double {
        return product.price * Double(quantity)
    }
}
