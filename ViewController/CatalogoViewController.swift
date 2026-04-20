//
//  CatalogoViewController.swift
//  HealthyGO
//
//  Created by DESIGN on 16/04/26.
//

import UIKit
import CoreData

final class CatalogoViewController: UIViewController {

    // Cambiamos de sampleData a una lista vacía que llenaremos de la BD
    private var productos: [Product] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 260
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "cart.fill"),
            style: .plain,
            target: self,
            action: #selector(abrirCarrito)
        )
    }
    
    // Se ejecuta cada vez que la pantalla aparece
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarProductosDesdeCoreData()
    }
    
    private func cargarProductosDesdeCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Consultamos la entidad 'Product' (como en tu imagen cf70c6.jpg)
        let request = NSFetchRequest<NSManagedObject>(entityName: "Product")
        
        do {
            let resultados = try context.fetch(request)
            
            // Mapeamos los NSManagedObject a tu estructura Product
            self.productos = resultados.compactMap { obj in
                return Product(
                    name: obj.value(forKey: "nombre") as? String ?? "",
                    description: obj.value(forKey: "descripcion") as? String ?? "",
                    price: obj.value(forKey: "precio") as? Double ?? 0.0,
                    category: obj.value(forKey: "categoria") as? String ?? "General",
                    imageNames: [obj.value(forKey: "imagenURL") as? String ?? "leaf.fill"],
                    isAvailable: (obj.value(forKey: "stock") as? Int ?? 0) == 1
                )
            }
            
            // Opcional: Agregar los datos de prueba al final si la BD está vacía
            if productos.isEmpty {
                productos = Product.sampleData()
            }
            
            tableView.reloadData()
        } catch {
            print("Error al cargar catálogo: \(error)")
        }
    }

    @objc private func abrirCarrito() {
        let carritoVC = CarritoViewController()
        navigationController?.pushViewController(carritoVC, animated: true)
    }

    private func setupUI() {
        title = "HealthyGo - Catálogo"
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension CatalogoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        let producto = productos[indexPath.row]
        cell.configure(with: producto)
        return cell
    }
    
    // Dentro de la extensión de UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let producto = productos[indexPath.row]
        
        // Agregamos al manager que creamos antes
        CartManager.shared.addProduct(producto)
        
        // Feedback visual simple
        let alert = UIAlertController(title: "Agregado", message: "\(producto.name) se añadió al carrito", preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            alert.dismiss(animated: true)
        }
    }
}

extension CatalogoViewController: RegistroProductoDelegate {
    func didRegisterProduct(_ product: Product) {
        // Insertamos el nuevo producto al inicio de la lista
        self.productos.insert(product, at: 0)
        // Recargamos la tabla para que aparezca
        self.tableView.reloadData()
    }
}
