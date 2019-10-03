//
//  LoginViewController.swift
//  FirebaseChatApp
//
//  Created by Ibrahim Yildirim on 03/10/2019.
//  Copyright © 2019 Ibrahim Yildirim. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func signingModeChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            //Login Mode
            btnSignIn.setTitle("Login", for: .normal)
        } else {
            //Register Mode
            btnSignIn.setTitle("Register", for: .normal)
        }
    }

}
