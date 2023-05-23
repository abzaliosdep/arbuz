//
//  AppDelegate.swift
//  Arbuz-app
//
//  Created by Абзал Бухарбай on 18.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = createTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func createTabBarController() -> UITabBarController {
        let mainViewController = MainViewController()
        mainViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
        
        let basketViewController = BasketViewController()
        basketViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "cart"), tag: 1)
        
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        let basketNavigationController = UINavigationController(rootViewController: basketViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mainNavigationController, basketNavigationController]
        tabBarController.tabBar.tintColor = UIColor.systemGreen
        tabBarController.tabBar.unselectedItemTintColor = UIColor.black
        
        return tabBarController
    }
}

