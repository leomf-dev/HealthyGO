//
//  CartManager.swift
//  HealthyGO
//
//  Created on 18/04/26.
//


import Foundation

final class CartManager {
    static let shared = CartManager()
    private init() {}
    
    private(set) var items: [CartItem] = []
    
    // Agregar productos al carrito [cite: 90]
    func addProduct(_ product: Product) {
        if let index = items.firstIndex(where: { $0.product.name == product.name }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
    // Editar cantidades 
    func updateQuantity(for product: Product, newQuantity: Int) {
        guard newQuantity > 0 else {
            removeProduct(product)
            return
        }
        if let index = items.firstIndex(where: { $0.product.name == product.name }) {
            items[index].quantity = newQuantity
        }
    }
    
    // Eliminar productos [cite: 93]
    func removeProduct(_ product: Product) {
        items.removeAll(where: { $0.product.name == product.name })
    }
    
    // Cálculo del Total General [cite: 100, 102]
    var totalAmount: Double {
        return items.reduce(0.0) { $0 + $1.subtotal }
    }
    
    // Validación de carrito vacío para habilitar el pedido [cite: 103]
    var isNotEmpty: Bool {
        return !items.isEmpty
    }
}
