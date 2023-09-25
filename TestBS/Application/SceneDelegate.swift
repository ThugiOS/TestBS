//
//  AppDelegate.swift
//  TestBS
//
//  Created by Никитин Артем on 25.09.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = ( scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainViewController()
        self.window = window
        self.window?.makeKeyAndVisible()
        if let mainViewController = window.rootViewController as? MainViewControllerProtocol {
            let mainController = MainViewModel(view: mainViewController)
            mainViewController.setController(mainController)
        }
    }
}
