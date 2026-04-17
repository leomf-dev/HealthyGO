//
//  User.swift
//  HealthyGO
//
//  Created by DESIGN on 16/04/26.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var nombre: String?
    @NSManaged public var correo: String?
    @NSManaged public var rol: String? // "Estudiante", "Emprendedor", "Admin"
    @NSManaged public var objetivoSalud: String? // Para la IA de recomendaciones
    
    // Relaciones
    @NSManaged public var productos: NSSet? // Para el Emprendedor
    @NSManaged public var pedidos: NSSet?    // Para el Estudiante
}
