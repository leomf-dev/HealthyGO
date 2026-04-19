//
//  Pedido.swift
//  HealthyGO
//
//  Created by DESIGN on 16/04/26.
//

import Foundation
import CoreData

struct Order {
    let id: String
    let date: Date
    let items: [Product]
    let total: Double
    let status: String // "Entregado", "En camino", "Cancelado"
}
