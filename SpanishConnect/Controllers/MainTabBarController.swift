//
//  MainTabBarController.swift
//  SpanishConnect
//
//  Created by Richard Price on 12/07/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .black
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        viewControllers = [
            navController, UIViewController()
        
        ]
        
    }
    
    
}
