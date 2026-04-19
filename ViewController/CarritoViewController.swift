//
//  CarritoViewControlle.swift
//  HealthyGO
//
//  Created by DESIGN on 16/04/26.
//

import UIKit

class CarritoViewController: UIViewController {
    
    // Tabla para mostrar los productos del carrito
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGroupedBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // Contenedor inferior para el total y botón de pago
    private let footerContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        // Sombra para que se vea sobre la tabla
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        return view
    }()

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.text = "Total HealthyGo: S/ 0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var confirmarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continuar al Pago", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemTeal
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continuarAlPago), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Mi Carrito"
        setupUI()
        setupTableView()
        actualizarCarrito()
    }

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(footerContainer)
        footerContainer.addSubview(totalLabel)
        footerContainer.addSubview(confirmarButton)
        
        NSLayoutConstraint.activate([
            // Tabla ocupa el resto de la pantalla
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerContainer.topAnchor),
            
            // Footer en la parte inferior
            footerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerContainer.heightAnchor.constraint(equalToConstant: 180),
            
            totalLabel.topAnchor.constraint(equalTo: footerContainer.topAnchor, constant: 20),
            totalLabel.centerXAnchor.constraint(equalTo: footerContainer.centerXAnchor),
            
            confirmarButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 15),
            confirmarButton.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor, constant: 20),
            confirmarButton.trailingAnchor.constraint(equalTo: footerContainer.trailingAnchor, constant: -20),
            confirmarButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartItemTableViewCell.self, forCellReuseIdentifier: CartItemTableViewCell.identifier)
    }

    func actualizarCarrito() {
        tableView.reloadData()
        let total = CartManager.shared.totalAmount
        totalLabel.text = String(format: "Total HealthyGo: S/ %.2f", total)
        
        // Habilitar o deshabilitar botón si el carrito está vacío
        confirmarButton.isEnabled = CartManager.shared.isNotEmpty
        confirmarButton.backgroundColor = CartManager.shared.isNotEmpty ? .systemTeal : .systemGray4
    }
    
    @objc private func continuarAlPago() {
        // Aquí lanzaremos la pantalla de confirmación que pediste
        mostrarConfirmacionPago()
    }
}

// MARK: - Extensiones de Tabla y Delegate
extension CarritoViewController: UITableViewDataSource, UITableViewDelegate, CartItemDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartItemTableViewCell.identifier, for: indexPath) as? CartItemTableViewCell else {
            return UITableViewCell()
        }
        let item = CartManager.shared.items[indexPath.row]
        cell.configure(with: item)
        cell.delegate = self // Conectamos el botón de la celda con este controlador
        return cell
    }
    
    // Métodos del delegado que creamos anteriormente
    func didUpdateQuantity(for product: Product, newQuantity: Int) {
        CartManager.shared.updateQuantity(for: product, newQuantity: newQuantity)
        actualizarCarrito()
    }
    
    func didRemoveProduct(_ product: Product) {
        CartManager.shared.removeProduct(product)
        actualizarCarrito()
    }
}

extension CarritoViewController {
    
    func mostrarConfirmacionPago() {
        // Verificamos que el carrito no esté vacío antes de proceder [cite: 103]
        guard CartManager.shared.isNotEmpty else { return }
        
        let alert = UIAlertController(
            title: "Finalizar Pedido",
            message: "¿Cómo deseas pagar tu pedido saludable?",
            preferredStyle: .actionSheet
        )
        
        // Simulación de Yape / Plin
        let yapeAction = UIAlertAction(title: "Yape / Plin (Simulado)", style: .default) { _ in
            self.procesarPago(metodo: "Yape/Plin")
        }
        
        // Simulación de Tarjeta
        let tarjetaAction = UIAlertAction(title: "Tarjeta de Crédito/Débito", style: .default) { _ in
            self.procesarPago(metodo: "Tarjeta")
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(yapeAction)
        alert.addAction(tarjetaAction)
        alert.addAction(cancelar)
        
        present(alert, animated: true)
    }
    
    private func procesarPago(metodo: String) {
        print("Procesando pago con \(metodo)...")
        
        let confirmacion = UIAlertController(
            title: "¡Pedido Exitoso!",
            message: "Tu pedido ha sido registrado. Ahora puedes ver el seguimiento en tiempo real.",
            preferredStyle: .alert
        )
        
        confirmacion.addAction(UIAlertAction(title: "Ver Seguimiento", style: .default, handler: { _ in
            // Navegamos a la pantalla de seguimiento
            let seguimientoVC = SeguimientoViewController()
            self.navigationController?.pushViewController(seguimientoVC, animated: true)
        }))
        
        present(confirmacion, animated: true)
    }
}
