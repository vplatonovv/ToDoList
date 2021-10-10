//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Слава Платонов on 09.10.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let toDoListVc = ToDoListViewController(style: .insetGrouped)
        window?.rootViewController = UINavigationController(rootViewController: toDoListVc)
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.shared.saveContext()
    }
}
    

    
