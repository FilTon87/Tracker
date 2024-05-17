//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Anton Filipchuk on 27.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = configStartingViewController()
        window?.makeKeyAndVisible()
    }
    
    private func configStartingViewController() -> UIViewController {
        var viewController: UIViewController
        let defaults = UserDefaults.standard
        let isSecondStart = defaults.bool(forKey: "isSecondStart")
        if  isSecondStart { viewController = TabBarController()
        } else {
            viewController = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        }
        return viewController
    }
}

