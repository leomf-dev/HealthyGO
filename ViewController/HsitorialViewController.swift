//
//  HsitorialViewController.swift
//  HealthyGO
//
//  Created on 18/04/26.
//

import UIKit
import CoreData

final class HistorialViewController: UIViewController {
    
    // 1. DECLARACIÓN DE LA VARIABLE (Esto corrige el error)
    private var pedidosGuardados: [NSManagedObject] = []
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        cargarHistorialDesdeBD()
    }

    private func setupUI() {
        title = "Mi Consumo"
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        // Asegúrate de registrar una celda, puede ser una básica por ahora
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistorialCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func cargarHistorialDesdeBD() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Usamos la entidad 'Order' que vimos en tu esquema
        let request = NSFetchRequest<NSManagedObject>(entityName: "Order")
        
        // Ordenar: Los más recientes primero
        let sortDescriptor = NSSortDescriptor(key: "fecha", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        do {
            self.pedidosGuardados = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error al obtener el historial: \(error)")
        }
    }
}

// MARK: - TableView DataSource
extension HistorialViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pedidosGuardados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistorialCell", for: indexPath)
        let pedido = pedidosGuardados[indexPath.row]
        
        // Extraer datos usando las llaves de tu esquema Core Data
        let total = pedido.value(forKey: "total") as? Double ?? 0.0
        let fecha = pedido.value(forKey: "fecha") as? Date ?? Date()
        
        // Formatear la fecha para que se vea bien
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        cell.textLabel?.text = "Pedido: S/ \(String(format: "%.2f", total))"
        cell.detailTextLabel?.text = formatter.string(from: fecha)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
