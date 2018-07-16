//
//  ViewController.swift
//  SpanishConnect
//
//  Created by Richard Price on 06/07/2018.
//  Copyright © 2018 twisted echo. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- setup buttons
    
    let plusButtonPhoto: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSelectedPhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputDidChange), for: .editingChanged)
        return textField
        
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputDidChange), for: .editingChanged)
        return textField
        
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputDidChange), for: .editingChanged)
        return textField
    }()
    
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(plusButtonPhoto)
        plusButtonPhoto.heightAnchor.constraint(equalToConstant: 140).isActive = true
        plusButtonPhoto.widthAnchor.constraint(equalToConstant: 140).isActive = true
        plusButtonPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusButtonPhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        
        setupInputFields()
    }
    
    //MARK:- PhotoButton
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusButtonPhoto.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let orignalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusButtonPhoto.setImage(orignalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusButtonPhoto.layer.cornerRadius = plusButtonPhoto.frame.width / 2
        plusButtonPhoto.layer.masksToBounds = true //needs to be set for corner radius visabilty
        plusButtonPhoto.layer.borderColor = UIColor.black.cgColor
        plusButtonPhoto.layer.borderWidth = 3
        
        dismiss(animated: true, completion: nil)
        
    }
    @objc fileprivate func handleSelectedPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)

    }
    //MARK:- Helper Methods
    @objc fileprivate func handleTextInputDidChange() {
        let isFormValid = !(emailTextField.text?.isEmpty)! && !(usernameTextField.text?.isEmpty)! && !(passwordTextField.text?.isEmpty)!
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc fileprivate func handleSignUp() {
        guard let email = emailTextField.text, !email.isEmpty else {return}
        guard let username = usernameTextField.text, !username.isEmpty else {return}
        guard let password = passwordTextField.text, !password.isEmpty else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                print("failed to create user", err)
                return
            }
            
            print("success...created a user in firebase")
            
            //upload photo
            guard let image = self.plusButtonPhoto.imageView?.image else {return}
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else {return}
            let filename = NSUUID().uuidString
            //firebase storage
            let storageRef = Storage.storage().reference()
            let storageRefChild = storageRef.child("profile_images").child(filename)
            
            storageRefChild.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Unable to upload image into storage due to: \(err)")
                }
                
                storageRefChild.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print("Unable to retrieve URL due to error: \(err.localizedDescription)")
                        return
                    }
                    let profilePicUrl =  url?.absoluteString
                    print("Profile Image successfully uploaded into storage with url: \(profilePicUrl ?? "" )")
                    //--firebase storage end
                    
                    guard let uid = user?.uid else {return}
                    let dictionaryValues = ["username": username, "profilePicUrl": profilePicUrl]
                    let values = [uid: dictionaryValues]
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print("failed to save user info", err)
                            return
                        }
                        print("sucessfully saved user info to db")
                    })
                })
            })
        }
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)

        stackView.anchor(top: plusButtonPhoto.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)

    }
}


