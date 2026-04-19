//
//  LoginViewController.swift
//  HealthyGO
//
//  Created on 18/04/26.
//

import UIKit
import CoreData

final class LoginViewController: UIViewController {
    
    // Debes tener estas declaraciones aquí arriba para que 'intentarLogin' las reconozca
        private let emailTextField: UITextField = {
            let tf = UITextField()
            tf.placeholder = "Correo electronico"
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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bienvenido a HealthyGo"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Iniciar Sesión", for: .normal)
        
        // Colores corporativos (Verde saludable)
        btn.backgroundColor = UIColor(red: 0.18, green: 0.70, blue: 0.29, alpha: 1.0)
        btn.setTitleColor(.white, for: .normal)
        
        // Tipografía y Bordes
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.layer.cornerRadius = 15
        
        // Sombra para dar profundidad (Efecto Elevado)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowRadius = 6
        btn.layer.shadowOpacity = 0.15
        
        btn.addTarget(self, action: #selector(intentarLogin), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private lazy var irRegistroButton: UIButton = {
        let btn = UIButton(type: .system)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.systemGray,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedTitle = NSAttributedString(string: "¿No tienes cuenta? Regístrate aquí", attributes: attributes)
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(irARegistro), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(irRegistroButton)

        // Ajusta los constraints para que se vean los campos de texto
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 45),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 55),
            
            irRegistroButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            irRegistroButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func irARegistro() {
        let registroVC = RegistroUsuarioViewController()
        navigationController?.pushViewController(registroVC, animated: true)
    }

    private func configurarTabBarPrincipal() {
        let tabBar = UITabBarController()
        
        if SessionManager.currentUserRole == .estudiante {
            let catalogo = UINavigationController(rootViewController: CatalogoViewController())
            catalogo.tabBarItem = UITabBarItem(title: "Catálogo", image: UIImage(systemName: "house"), tag: 0)
            
            let historial = UINavigationController(rootViewController: HistorialViewController())
            historial.tabBarItem = UITabBarItem(title: "Mi Consumo", image: UIImage(systemName: "list.bullet.clipboard"), tag: 1)
            
            tabBar.viewControllers = [catalogo, historial]
        } else {
            let gestion = UINavigationController(rootViewController: MisProductosViewController())
            gestion.tabBarItem = UITabBarItem(title: "Mis Productos", image: UIImage(systemName: "folder"), tag: 0)
            
            let historialVentas = UINavigationController(rootViewController: HistorialViewController())
            historialVentas.tabBarItem = UITabBarItem(title: "Ventas", image: UIImage(systemName: "chart.bar"), tag: 1)
            
            tabBar.viewControllers = [gestion, historialVentas]
        }
        
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
}

extension LoginViewController {
    
    @objc private func intentarLogin() {
        // 1. Validamos que los campos tengan texto
        guard let email = emailTextField.text, !email.isEmpty,
              let pass = passwordTextField.text, !pass.isEmpty else {
            print("Campos vacíos")
            return
        }
        
        // 2. Accedemos al contexto (esto ya no fallará con el paso anterior)
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        // 3. Filtramos por credenciales
        request.predicate = NSPredicate(format: "correo == %@ AND password == %@", email, pass)
        
        do {
            let results = try context.fetch(request)
            if let userFound = results.first as? NSManagedObject {
                // 4. Obtenemos el rol y configuramos la sesión
                let rol = userFound.value(forKey: "rol") as? String ?? "estudiante"
                SessionManager.currentUserRole = (rol == "estudiante") ? .estudiante : .emprendedor
                
                print("Login exitoso: Bienvenido \(rol)")
                configurarTabBarPrincipal() // Este método carga el menú correspondiente
            } else {
                print("Correo o contraseña incorrectos")
            }
        } catch {
            print("Error en la consulta: \(error)")
        }
    }
}
