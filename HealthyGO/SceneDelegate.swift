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
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        
        // Aquí es donde defines que la app inicie con tu nuevo catálogo
        let rootVC = LoginViewController()
        let navigationController = UINavigationController(rootViewController: rootVC)
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
