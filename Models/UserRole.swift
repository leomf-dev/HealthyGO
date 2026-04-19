//
//  UserRole.swift
//  HealthyGO
//
//  Created on 18/04/26.
//

enum UserRole {
    case estudiante
    case emprendedor
}

struct SessionManager {
    static var currentUserRole: UserRole = .estudiante // Cambia esto para probar ambos roles
}
