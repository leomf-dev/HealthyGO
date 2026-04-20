//
//  RegristroProductoViewController.swift
//  HealthyGO
//
//  Created on 18/04/26.
//

import UIKit
import CoreData

protocol RegistroProductoDelegate: AnyObject {
    func didRegisterProduct(_ product: Product)
}

final class RegistroProductoViewController: UIViewController {
    weak var delegate: RegistroProductoDelegate? // Propiedad del delegado

    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nombreTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Nombre del producto (ej: Ensalada César)"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let precioTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Precio (S/)"
        tf.keyboardType = .decimalPad
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let descripcionTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 0.5
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.cornerRadius = 5
        tv.font = .systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let stockSwitch: UISwitch = {
        let sw = UISwitch()
        sw.isOn = true
        sw.onTintColor = .systemTeal
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()

    private lazy var guardarButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Registrar Producto", for: .normal)
        btn.backgroundColor = .systemTeal
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(guardarProducto), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nuevo Producto"
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let stackView = UIStackView(arrangedSubviews: [
            UILabel().then { ($0 as? UILabel)?.text = "Datos del Plato"; ($0 as? UILabel)?.font = .boldSystemFont(ofSize: 20) },
            nombreTextField,
            precioTextField,
            UILabel().then { ($0 as? UILabel)?.text = "Descripción:"; ($0 as? UILabel)?.font = .systemFont(ofSize: 16, weight: .medium) },
            descripcionTextView,
            UIStackView(arrangedSubviews: [
                UILabel().then { ($0 as? UILabel)?.text = "¿Disponible hoy?" },
                stockSwitch
            ]).then { ($0 as? UIStackView)?.spacing = 10 },
            guardarButton
        ])

        // Corrección para el error 'vertical'
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        // Constraints de Scroll y Stack
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            descripcionTextView.heightAnchor.constraint(equalToConstant: 100),
            guardarButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func guardarProducto() {
        // 1. Validaciones
        guard let nombre = nombreTextField.text, !nombre.isEmpty,
              let precioStr = precioTextField.text, let precio = Double(precioStr),
              let descripcion = descripcionTextView.text else {
            mostrarAlerta(mensaje: "Completa los campos obligatorios.")
            return
        }
        
        // 2. Acceso a Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // 3. Crear el objeto con los nombres EXACTOS de tu imagen
        let productDB = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context)
        
        // ATRIBUTOS SEGÚN TU CAPTURA image_cf70c6.jpg
        productDB.setValue(UUID(), forKey: "id")
        productDB.setValue(nombre, forKey: "nombre")         // Antes era 'name'
        productDB.setValue(precio, forKey: "precio")         // Antes era 'price'
        productDB.setValue(descripcion, forKey: "descripcion") // Antes era 'description'
        productDB.setValue("General", forKey: "categoria")   // Tu atributo es 'categoria' (sin tilde)
        productDB.setValue(stockSwitch.isOn ? 1 : 0, forKey: "stock") // Tu stock es Integer 32 (1=Disponible, 0=No)
        productDB.setValue("caja.paquete", forKey: "imagenURL") // Para guardar un icono o ruta
        
        do {
            try context.save()
            print("Producto guardado exitosamente con la nueva estructura")
            
            // Notificar a la pantalla anterior para que se vea el cambio sin reiniciar
            let nuevoProducto = Product(
                name: nombre,
                description: descripcion,
                price: precio,
                category: "General",
                imageNames: ["box.truck"],
                isAvailable: stockSwitch.isOn
            )
            
            delegate?.didRegisterProduct(nuevoProducto)
            self.navigationController?.popViewController(animated: true)
            
        } catch {
            print("Error al guardar: \(error.localizedDescription)")
        }
    }

    private func mostrarAlerta(mensaje: String) {
        let alert = UIAlertController(title: "Atención", message: mensaje, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendido", style: .default))
        present(alert, animated: true)
    }
}

// Helper para configuración rápida de vistas
extension UIView {
    func then(_ block: (UIView) -> Void) -> Self {
        block(self)
        return self
    }
}
