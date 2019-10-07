//
//  ChatViewController.swift
//  FirebaseChatApp
//
//  Created by Ibrahim Yildirim on 04/10/2019.
//  Copyright © 2019 Ibrahim Yildirim. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtMessage: UITextField!
    
    var user: User! {
        didSet {
            self.title = user?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMessage.delegate = self
    }
    
    @IBAction func sendMessageClicked(_ sender: Any) {
        if let text = txtMessage.text, !text.isEmpty {
            let ref = Database.database().reference().child(FirebaseRef.messages)
            let childRef = ref.childByAutoId()
            let toId = user.id!
            let fromId = Auth.auth().currentUser!.uid
            let timestamp = Int(Date().timeIntervalSince1970)
            let values: [String : Any] = [FirebaseRef.MessageRef.text: text, FirebaseRef.MessageRef.toId: toId, FirebaseRef.MessageRef.fromId: fromId, FirebaseRef.MessageRef.timestamp: timestamp]
            
            childRef.updateChildValues(values) { error, ref in
                if let error = error {
                    print(error)
                    return
                }
                
                guard let messageId = childRef.key else {
                    return
                }
                let userMessagesRef = Database.database().reference().child(FirebaseRef.userMessages).child(fromId).child(messageId)
                userMessagesRef.setValue(1)
            }
            
            txtMessage.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessageClicked(self)
        return true
    }
}
