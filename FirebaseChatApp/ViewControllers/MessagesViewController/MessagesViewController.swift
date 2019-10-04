//
//  ViewController.swift
//  FirebaseChatApp
//
//  Created by Ibrahim Yildirim on 03/10/2019.
//  Copyright © 2019 Ibrahim Yildirim. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newMessageClicked))
        
        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn() {
        if let uid = Auth.auth().currentUser?.uid {
            //Retrive user and set as title
            Database.database().reference().child(FirebaseConstants.References.users).child(uid).observeSingleEvent(of: .value, with: { snapshot in
                print(snapshot)
                if let dictionary = snapshot.value as? [String : Any] {
                    self.navigationItem.title = dictionary[FirebaseConstants.UserValues.name] as? String
                }
            }, withCancel: nil)
        } else {
            logoutClicked()
        }
    }
    
    @objc func logoutClicked() {
        
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error.localizedDescription)
        }
        self.navigationItem.title = ""

        let loginController = LoginViewController()
        if #available(iOS 13.0, *) {
            loginController.isModalInPresentation = true
        }
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func newMessageClicked() {
        let newMessageController = UINavigationController(rootViewController: NewMessageViewController())
//        newMessageController.modalPresentationStyle = .fullScreen
        present(newMessageController, animated: true, completion: nil)
    }
}
