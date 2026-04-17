//
//  CarritoViewControlle.swift
//  HealthyGO
//
//  Created by DESIGN on 16/04/26.
//

import UIKit
import CoreData

class CarritoViewController: UIViewController {
    
    // UI Elements (Creados por código)
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        consultarCarrito()
    }

    private func setupUI() {
        view.addSubview(totalLabel)
        
        // Layout (Constraints)
        NSLayoutConstraint.activate([
            totalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            totalLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func consultarCarrito() {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Order> = NSFetchRequest<Order>(entityName: "Order")
        
        // Lógica de IA básica: Filtrar por fecha o estado
        request.predicate = NSPredicate(format: "estado == %@", "Pendiente")
        
        do {
            let pedidos = try context.fetch(request)
            let sumaTotal = pedidos.reduce(0.0) { $0 + $1.total }
            totalLabel.text = "Total HealthyGo: $\(sumaTotal)"
        } catch {
            print("Error al leer el carrito")
        }
    }
}
