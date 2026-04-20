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
    
    // MARK: - Método de Limpieza
    func clearCart() {
        // Vaciamos el arreglo por completo
        self.items.removeAll()
            
        // Opcional: Si usas notificaciones o delegados para avisar a otras pantallas
        // que el carrito cambió, deberías dispararlos aquí.
        print("Carrito vaciado con éxito.")
    }
        
    // Propiedad calculada para saber si hay algo en el carrito
    var isNotEmpty: Bool {
        return !items.isEmpty
    }
        
    // Propiedad para calcular el total acumulado
    var totalAmount: Double {
        return items.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
}
