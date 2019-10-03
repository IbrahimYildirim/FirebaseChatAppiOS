//
//  ViewController.swift
//  FirebaseChatApp
//
//  Created by Ibrahim Yildirim on 03/10/2019.
//  Copyright © 2019 Ibrahim Yildirim. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutClicked))
    }
    
    @objc func logoutClicked() {
        let loginController = LoginViewController()
        present(loginController, animated: true, completion: nil)
    }
    
    


}

