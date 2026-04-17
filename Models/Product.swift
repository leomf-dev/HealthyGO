//
//  Producto.swift
//  HealthyGO
//
//  Created by DESIGN on 16/04/26.
//

import Foundation
import CoreData

@objc(Product)
public class Product: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var nombre: String?
    @NSManaged public var precio: Double
    @NSManaged public var categoria: String?
    @NSManaged public var stock: Int32
    @NSManaged public var imagenURL: String? // Link local o remoto
    
    // Relación inversa
    @NSManaged public var emprendedor: User?
}
