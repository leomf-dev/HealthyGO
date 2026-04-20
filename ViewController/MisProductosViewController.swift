//
//  MisProductosViewController.swift
//  HealthyGO
//
//  Created on 18/04/26.
//

import UIKit
import CoreData

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
        cargarProductosDesdeBD()
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
    
    private func cargarProductosDesdeBD() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        do {
            let results = try context.fetch(request) as? [NSManagedObject]
            self.misProductos = results?.compactMap { obj in
                Product(
                    name: obj.value(forKey: "nombre") as? String ?? "",
                    description: obj.value(forKey: "descripcion") as? String ?? "",
                    price: obj.value(forKey: "precio") as? Double ?? 0.0,
                    category: obj.value(forKey: "categoria") as? String ?? "General",
                    imageNames: ["leaf.fill"],
                    isAvailable: (obj.value(forKey: "stock") as? Int ?? 0) == 1
                )
            } ?? []
            tableView.reloadData()
        } catch {
            print("Error al cargar: \(error)")
        }
    }
    
    @objc private func agregarNuevoProducto() {
        let registroVC = RegistroProductoViewController()
        // CRÍTICO: Esta línea conecta ambas pantallas
        registroVC.delegate = self
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

extension MisProductosViewController: RegistroProductoDelegate {
    func didRegisterProduct(_ product: Product) {
        // Insertamos el nuevo producto al inicio de la lista
        self.misProductos.insert(product, at: 0)
        // Refrescamos la tabla para que se vea el cambio
        self.tableView.reloadData()
    }
}
