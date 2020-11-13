//
//  AppDelegate.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 31/07/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        updateTheme(.theme)
        
        let client = Client()
        
        guard let tabBarController = window?.rootViewController as? UITabBarController,
        let viewControllers = tabBarController.viewControllers else {
            return true
        }
        
        for viewController in viewControllers {
            
            var child = viewController
            
            if let nav = child as? UINavigationController, let root = nav.viewControllers.first {
                child = root
            }
            
            if let staffView = child as? StaffDirectoryViewController {
                
                
                let presenter = StaffDirectoryPresenter(view: staffView, model: [])
                presenter.client = client
                
                staffView.presenter = presenter
            }
            
            if let roomView = child as? RoomViewController {
                
                let presenter = RoomPresenter(view: roomView, model: [])
                presenter.client = client
                
                roomView.presenter = presenter
            }
            
        }
        
        return true
    }
    
    private func updateTheme(_ color: UIColor) {
    
        //UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = color
//        UIBarButtonItem.appearance().tintColor = color
//        UISegmentedControl.appearance().tintColor = color
//        UINavigationBar.appearance().tintColor = color
//        UISearchBar.appearance().barTintColor = color
//        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UITabBar.self]).tintColor = color
        window?.tintColor = color
    }

}
