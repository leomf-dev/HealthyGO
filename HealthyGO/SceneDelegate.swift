//
//  SceneDelegate.swift
//  HealthyGO
//
//  Created by DESIGN on 16/04/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // 1. Verificar que la escena sea de tipo UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // 2. Crear la ventana manualmente con el tamaño de la pantalla
        let window = UIWindow(windowScene: windowScene)

        // 3. Definir el controlador raíz (Asegúrate de que el nombre coincida con tus archivos)
        // Si aún no creas el Login, usa ViewController() que ya existe en tu lista
        let rootVC = ViewController()
        let navigationController = UINavigationController(rootViewController: rootVC)

        // 4. Configurar y mostrar la ventana
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
