//
//  RegistroUsuarioViewController.swift
//  HealthyGO
//
//  Created on 18/04/26.
//

import UIKit
import CoreData

final class RegistroUsuarioViewController: UIViewController {
    
    // 1. Añadimos el botón de registro que faltaba en tu código
        private lazy var registrarButton: UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("Finalizar Registro", for: .normal)
            btn.backgroundColor = UIColor(red: 0.18, green: 0.70, blue: 0.29, alpha: 1.0)
            btn.setTitleColor(.white, for: .normal)
            btn.layer.cornerRadius = 15
            btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
            btn.addTarget(self, action: #selector(finalizarRegistro), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
    
    // MARK: - UI Elements con tipos explícitos
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Correo"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Contraseña"
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private let infoExtraTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Universidad"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private lazy var roleSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Estudiante", "Emprendedor"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(roleChanged), for: .valueChanged)
        return sc
    }()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white // 2. FUNDAMENTAL: Evita que la pantalla salga negra
            setupUI()
        }

        private func setupUI() {
            // 3. AGREGAR SUBVISTAS (Sin esto no se ve nada)
            view.addSubview(roleSegmentedControl)
            view.addSubview(emailTextField)
            view.addSubview(passwordTextField)
            view.addSubview(infoExtraTextField)
            view.addSubview(registrarButton)
            
            roleSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
            emailTextField.translatesAutoresizingMaskIntoConstraints = false
            passwordTextField.translatesAutoresizingMaskIntoConstraints = false
            infoExtraTextField.translatesAutoresizingMaskIntoConstraints = false

            // 4. CONFIGURAR CONSTRAINTS (Posicionamiento)
            NSLayoutConstraint.activate([
                roleSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
                roleSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                roleSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

                emailTextField.topAnchor.constraint(equalTo: roleSegmentedControl.bottomAnchor, constant: 30),
                emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                emailTextField.heightAnchor.constraint(equalToConstant: 45),

                passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
                passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
                passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
                passwordTextField.heightAnchor.constraint(equalToConstant: 45),

                infoExtraTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
                infoExtraTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
                infoExtraTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
                infoExtraTextField.heightAnchor.constraint(equalToConstant: 45),

                registrarButton.topAnchor.constraint(equalTo: infoExtraTextField.bottomAnchor, constant: 40),
                registrarButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
                registrarButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
                registrarButton.heightAnchor.constraint(equalToConstant: 55)
            ])
        }

    // MARK: - Actions
    @objc private func roleChanged(_ sender: UISegmentedControl) {
        infoExtraTextField.placeholder = sender.selectedSegmentIndex == 0 ? "Universidad" : "Nombre del Negocio"
    }

    @objc private func finalizarRegistro() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else { return }

        // Acceso a Core Data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Crear el objeto User (usando tu entidad actual)
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        newUser.setValue(UUID(), forKey: "id")
        newUser.setValue(email, forKey: "correo")
        newUser.setValue(password, forKey: "password")
        newUser.setValue(infoExtraTextField.text, forKey: "infoExtra")
        
        let rolString = roleSegmentedControl.selectedSegmentIndex == 0 ? "estudiante" : "emprendedor"
        newUser.setValue(rolString, forKey: "rol")
        
        do {
            try context.save()
            mostrarAlertaExito()
        } catch {
            print("Error al guardar usuario: \(error)")
        }
    }

    private func mostrarAlertaExito() {
        let alert = UIAlertController(title: "¡Cuenta creada!", message: "Ya puedes iniciar sesión en HealthyGo.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}
