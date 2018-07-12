//
//  UserProfileController.swift
//  SpanishConnect
//
//  Created by Richard Price on 12/07/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit
import Firebase


class UserProfileController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .yellow
        navigationItem.title = "User Profile"
        navigationItem.title = Auth.auth().currentUser?.uid
        
        
        fetchUser()
        
    }
    
    fileprivate func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {return}
            let username = dict["username"] as? String
            self.navigationItem.title = username

        }) { (err) in
            print("failed to fetch user", err)
        }
    }
}
