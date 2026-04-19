//
//  User.swift
//  HealthyGO
//
//  Created by DESIGN on 16/04/26.
//

import Foundation
import CoreData

// Definición de la entidad en tu código
struct UserAccount {
    let id: UUID
    let email: String
    let passwordHash: String
    let role: UserRole // .estudiante o .emprendedor
    
    // Datos específicos
    var nombreCompleto: String
    var universidad: String? // Solo para estudiantes
    var nombreNegocio: String? // Solo para emprendedores
}
