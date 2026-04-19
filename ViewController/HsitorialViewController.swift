//
//  HsitorialViewController.swift
//  HealthyGO
//
//  Created on 18/04/26.
//

import UIKit

final class HistorialViewController: UIViewController {
    
    private var pedidos: [Order] = []
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "OrderCell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        cargarDatosSegunRol()
    }
    
    private func setupUI() {
        title = SessionManager.currentUserRole == .estudiante ? "Mis Compras" : "Ventas Recibidas"
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
    }
    
    private func cargarDatosSegunRol() {
        // Simulación de datos cargados
        pedidos = [
            Order(id: "001", date: Date(), items: [], total: 30.50, status: "Entregado"),
            Order(id: "002", date: Date().addingTimeInterval(-86400), items: [], total: 15.00, status: "Entregado")
        ]
        tableView.reloadData()
    }
}

extension HistorialViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pedidos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "OrderCell")
        let pedido = pedidos[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        cell.textLabel?.text = "Pedido #\(pedido.id) - S/ \(pedido.total)"
        cell.detailTextLabel?.text = "Fecha: \(formatter.string(from: pedido.date)) | Estado: \(pedido.status)"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
