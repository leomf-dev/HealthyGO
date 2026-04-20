//
//  ConfirmacionPagoViewController.swift
//  HealthyGO
//
//  Created on 19/04/26.
//

import UIKit
import CoreData

final class ConfirmacionPagoViewController: UIViewController {
    
    var totalAPagar: Double = 0.0
    
    // MARK: - UI Elements
    private let resumenLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let direccionTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Dirección de entrega (ej: Pabellón B - Aula 201)"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let telefonoTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Número de contacto"
        tf.keyboardType = .phonePad
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var pagarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Confirmar y Pagar", for: .normal)
        btn.backgroundColor = UIColor(red: 0.18, green: 0.70, blue: 0.29, alpha: 1.0) // Verde HealthyGo
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 15
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(procesarPagoReal), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Finalizar Pedido"
        resumenLabel.text = "Total a pagar: S/ \(String(format: "%.2f", totalAPagar))"
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(resumenLabel)
        view.addSubview(direccionTextField)
        view.addSubview(telefonoTextField)
        view.addSubview(pagarButton)
        
        NSLayoutConstraint.activate([
            resumenLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            resumenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resumenLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            direccionTextField.topAnchor.constraint(equalTo: resumenLabel.bottomAnchor, constant: 40),
            direccionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            direccionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            direccionTextField.heightAnchor.constraint(equalToConstant: 50),
            
            telefonoTextField.topAnchor.constraint(equalTo: direccionTextField.bottomAnchor, constant: 20),
            telefonoTextField.leadingAnchor.constraint(equalTo: direccionTextField.leadingAnchor),
            telefonoTextField.trailingAnchor.constraint(equalTo: direccionTextField.trailingAnchor),
            telefonoTextField.heightAnchor.constraint(equalToConstant: 50),
            
            pagarButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            pagarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pagarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pagarButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func procesarPagoReal() {
        // Validar que los campos no estén vacíos
        guard let direccion = direccionTextField.text, !direccion.isEmpty,
              let telefono = telefonoTextField.text, !telefono.isEmpty else {
            let alert = UIAlertController(title: "Atención", message: "Por favor, ingresa los datos de entrega.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // 1. Guardar en Core Data
        guardarPedidoEnHistorial(direccion: direccion, telefono: telefono)
        
        // 2. Limpiar el carrito
        CartManager.shared.clearCart()
        
        // 3. Alerta final con doble opción
        mostrarAlertaExito()
    }
    
    private func guardarPedidoEnHistorial(direccion: String, telefono: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Basado en tu entidad 'Order' (image_43858b.jpg)
        let nuevaOrden = NSEntityDescription.insertNewObject(forEntityName: "Order", into: context)
        nuevaOrden.setValue(UUID(), forKey: "id")
        nuevaOrden.setValue(Date(), forKey: "fecha")
        nuevaOrden.setValue(totalAPagar, forKey: "total")
        nuevaOrden.setValue("En Preparación", forKey: "estado")
        
        // Nota: Si no tienes campos 'direccion' y 'telefono' en la entidad Order del .xcdatamodeld,
        // puedes añadirlos o simplemente usarlos para la lógica de la sesión actual.
        
        do {
            try context.save()
            print("Pedido registrado con éxito")
        } catch {
            print("Error al guardar: \(error)")
        }
    }

    private func mostrarAlertaExito() {
        let alertaFinal = UIAlertController(
            title: "¡Pedido Confirmado!",
            message: "Estamos preparando tu orden saludable.",
            preferredStyle: .alert
        )
        
        alertaFinal.addAction(UIAlertAction(title: "Ver Seguimiento", style: .default) { _ in
            self.navigationController?.pushViewController(SeguimientoViewController(), animated: true)
        })
        
        alertaFinal.addAction(UIAlertAction(title: "Ver Historial", style: .default) { _ in
            self.navigationController?.pushViewController(HistorialViewController(), animated: true)
        })
        
        present(alertaFinal, animated: true)
    }
}
