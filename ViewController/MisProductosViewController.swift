//
//  MisProductosViewController.swift
//  HealthyGO
//
//  Created on 18/04/26.
//

import UIKit

final class MisProductosViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // Lista local para simular los productos del emprendedor
    private var misProductos: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        cargarProductosSimulados()
    }
    
    private func setupUI() {
        title = "Mis Productos"
        view.backgroundColor = .systemGroupedBackground
        
        // Botón para ir al formulario de registro que ya corregimos
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(agregarNuevoProducto)
        )
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProductManagementCell.self, forCellReuseIdentifier: "ManageCell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func cargarProductosSimulados() {
        misProductos = [
            Product(name: "Ensalada Proteica", description: "Pollo, quinua y palta", price: 18.50, category: "Almuerzo", imageNames: ["leaf.fill"], isAvailable: true),
            Product(name: "Jugo Detox", description: "Manzana verde y apio", price: 12.00, category: "Bebidas", imageNames: ["cup.and.saucer.fill"], isAvailable: false)
        ]
        tableView.reloadData()
    }
    
    @objc private func agregarNuevoProducto() {
        let registroVC = RegistroProductoViewController()
        navigationController?.pushViewController(registroVC, animated: true)
    }
}

// MARK: - DataSource & Delegate
extension MisProductosViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return misProductos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageCell", for: indexPath) as! ProductManagementCell
        let producto = misProductos[indexPath.row]
        cell.configure(with: producto)
        
        // Callback para manejar el cambio de stock
        cell.onStockChange = { [weak self] nuevoEstado in
            self?.misProductos[indexPath.row].isAvailable = nuevoEstado
            print("Stock actualizado para \(producto.name): \(nuevoEstado)")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
