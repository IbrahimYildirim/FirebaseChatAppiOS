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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    
    var messages = [Message]()
    var user: User! {
        didSet {
            self.title = user?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtMessage.delegate = self
        
        tableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: ChatTableViewCell.cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
    
        observeMessages()
    }
    
    func observeMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        let userMessageRef = Database.database().reference().child(FirebaseRef.userMessages).child(currentUserId)
        userMessageRef.observe(.childAdded) { snapshot in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child(FirebaseRef.messages).child(messageId)
            messagesRef.observeSingleEvent(of: .value) { snapshot in
                guard let dict = snapshot.value as? [String: Any] else {
                    return
                }
                let message = Message()
                message.setValuesForKeys(dict)
                
                if message.chatPartnerId() == self.user.id {
                    self.messages.append(message)
                    self.updateTableAndScroolToBottom()
                }
            }
        }
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
                
                let recipientUserMessagesRef = Database.database().reference().child(FirebaseRef.userMessages).child(toId).child(messageId)
                recipientUserMessagesRef.setValue(1)
            }
            
            txtMessage.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessageClicked(self)
        return true
    }
    
    func updateTableAndScroolToBottom() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension ChatViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.cellId) as! ChatTableViewCell
        let message = messages[indexPath.row]
        
        if message.isFromCurrentUser {
            cell.userMessage = message.text
        } else {
            cell.partnerMessage = message.text
        }
        
        return cell
    }
}
