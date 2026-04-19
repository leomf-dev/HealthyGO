//
//  PersistanceController.swift
//  HealthyGO
//
//  Created by DESIGN on 16/04/26.
//

import CoreData

struct PersistenceController {
    // Instancia única para toda la app
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // El nombre debe ser EXACTAMENTE igual a su archivo .xcdatamodeld [cite: 8]
        container = NSPersistentContainer(name: "HealthyGoModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // Manejo de errores básico para desarrollo
                fatalError("Error al cargar CoreData: \(error), \(error.userInfo)")
            }
        }
        
        // Ayuda a que los cambios se reflejen automáticamente entre hilos
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Función útil para el integrante encargado de crear datos de prueba (Mock Data)
//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//        
//        // Ejemplo de datos para que el equipo vea algo al diseñar la UI [cite: 10, 83]
//        let newProduct = Product(context: viewContext)
//        newProduct.id = UUID()
//        newProduct.nombre = "Ensalada Integral"
//        newProduct.precio = 15.50
//        newProduct.categoria = "Almuerzo"
//        
//        try? viewContext.save()
//        return result
//    }()
}
