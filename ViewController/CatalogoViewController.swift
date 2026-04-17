//
//  CatalogoViewController.swift
//  HealthyGO
//
//  Created by DESIGN on 16/04/26.
//

import UIKit
import CoreData

class CatalogoViewController: UIViewController {

    // Referencia al contexto de la base de datos
    let context = PersistenceController.shared.container.viewContext
    
    // Array para guardar los productos traídos de CoreData
    var productos: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        cargarProductos()
    }

    func cargarProductos() {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Product> = NSFetchRequest<Product>(entityName: "Product")
        
        do {
            // Traemos los productos saludables de la base de datos local
            self.productos = try context.fetch(request)
            print("Se cargaron \(productos.count) productos nutricionales")
            
            // Aquí el integrante encargado de la UI debe recargar el TableView
            // self.tableView.reloadData()
        } catch {
            print("Error al obtener productos para HealthyGo: \(error)")
        }
    }
}
