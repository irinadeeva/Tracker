//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Irina Deeva on 06/03/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()

        let defaults = UserDefaults.standard
        let isFirstLaunch = defaults.bool(forKey: "isFirstLaunch")

        if !isFirstLaunch {
            window?.rootViewController = OnboardingPageViewController()
            defaults.set(true, forKey: "isFirstLaunch")
        } else {
            window?.rootViewController = TabBarController()
        }

        window?.makeKeyAndVisible()
    }
}
