//
//  LoginViewController.swift
//  FirebaseChatApp
//
//  Created by Ibrahim Yildirim on 03/10/2019.
//  Copyright © 2019 Ibrahim Yildirim. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var constraintUsernameViewHeight: NSLayoutConstraint!
    @IBOutlet weak var vwUsername: UIView!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var sgmtSignInMode: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signingModeChanged(_ sender: Any) {
        
        let isSignInMode = sgmtSignInMode.selectedSegmentIndex == 0
        
        btnSignIn.setTitle(isSignInMode ? "Login" : "Register", for: .normal)
        
        //Animate UI Changes
        UIView.animate(withDuration: 0.3) {
            self.constraintUsernameViewHeight.constant = isSignInMode ? 0 : 50
            self.vwUsername.alpha = isSignInMode ? 0 : 1
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
        guard let email = txtEmail.text, let password = txtPassword.text else {
            //TODO: Show error
            return
        }
        
        if sgmtSignInMode.selectedSegmentIndex == 0 {
            //Login
            signIn(email: email, password: password)
        } else {
            //Register new user
            guard let username = txtUsername.text else {
                //Show error
                self.showSimpleAlert(message: "Please select a username!")
                return
            }
            registerUser(username: username, email: email, password: password)
        }
    }
    
    private func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error {
                print(error)
                self.showSimpleAlert(message: error.localizedDescription)
                return
            }
            
            //Succesfully Authenticated User
            print("User Authenticated")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func registerUser(username: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error)
                self.showSimpleAlert(message: error.localizedDescription)
                return
            }
            
            guard let userUid = result?.user.uid else {
                self.showSimpleAlert(message: "Could not save username to database")
                return
            }
            
            //Save username to user
            let ref = Database.database().reference(fromURL: FirebaseConstants.urlPath)
            let userRef = ref.child(FirebaseConstants.References.users).child(userUid)
            let values = [FirebaseConstants.UserValues.name : username, FirebaseConstants.UserValues.email : email]
            userRef.updateChildValues(values) { err, ref in
                if let error = err {
                    //Error saving username to db
                    //Does not check before a user is created whether the username exists.
                    print(error)
                    return
                }
                
                print("Saved User Succesfully into Firebase DB")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
