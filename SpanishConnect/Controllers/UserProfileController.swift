//
//  UserProfileController.swift
//  SpanishConnect
//
//  Created by Richard Price on 12/07/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit
import Firebase


class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        navigationItem.title = "User Profile"
        navigationItem.title = Auth.auth().currentUser?.uid
        
         collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        
        
        fetchUser()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        //header.backgroundColor = .red
        
        //not correct
        //header.addSubview(UIImageView())
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
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
