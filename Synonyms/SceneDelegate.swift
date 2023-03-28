//
//  SceneDelegate.swift
//  Merima Muhovic
//
//  Created by Merima Muhovic on 3. 3. 2023..
//

import Foundation
import UIKit
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .light
        window?.backgroundColor = .white
        window?.tintColor = .label
        
        let navigationRegistration =  WelcomeViewController()
        
        let navigationController = UINavigationController(rootViewController: navigationRegistration)
        navigationController.setNavigationBarHidden(false, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {

    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    
}
