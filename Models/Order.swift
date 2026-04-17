//
//  Pedido.swift
//  HealthyGO
//
//  Created by DESIGN on 16/04/26.
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var fecha: Date?
    @NSManaged public var total: Double
    @NSManaged public var estado: String? // "En camino", "Entregado"
    @NSManaged public var metodoPago: String? // "Yape", "Plin", "Efectivo"
    
    // Relaciones
    @NSManaged public var cliente: User?
    @NSManaged public var items: NSSet? // Relación con OrderItem
}
