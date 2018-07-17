//
//  UserProfileHeader.swift
//  SpanishConnect
//
//  Created by Richard Price on 17/07/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        return iv
    }()
    
    let lable: UILabel = {
        
        let lable = UILabel()
        lable.backgroundColor = .white
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        backgroundColor = .blue
        addSubview(lable)
        lable.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 50, width: 10, height: 10)
     
        
        
        profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


