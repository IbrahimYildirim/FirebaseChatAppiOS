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

    var messageDict = [String: Message]()
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newMessageClicked))
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: MessageTableViewCell.cellId)
        tableView.rowHeight = 60
        
        fetchUserIfLoggedIn()
    }

    func clearTableView() {
        DispatchQueue.main.async {
            self.messages.removeAll()
            self.messageDict.removeAll()
            self.tableView.reloadData()
        }
    }
    
    func fetchUserIfLoggedIn() {
        if let uid = Auth.auth().currentUser?.uid {
            
            //Retrive user and set title
            Database.database().reference().child(FirebaseRef.users).child(uid).observeSingleEvent(of: .value, with: { snapshot in
                if let dictionary = snapshot.value as? [String : Any] {
                    self.navigationItem.title = dictionary[FirebaseRef.UserRef.name] as? String
                    self.clearTableView()
                    self.obserUserMessages()
                }
            }, withCancel: nil)
        } else {
            logoutClicked()
        }
    }
    
    func obserUserMessages() {
        guard let userId = Auth.auth().currentUser?.uid else {
            //User is not signed in
            return
        }
        
        let ref = Database.database().reference().child(FirebaseRef.userMessages).child(userId)
        ref.observe(.childAdded) { snapshot in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child(FirebaseRef.messages).child(messageId)
            
            messageRef.observeSingleEvent(of: .value) { snapshot in
                    if let dictionary = snapshot.value as? [String : Any] {
                        let message = Message()
                        message.setValuesForKeys(dictionary)
                        print(snapshot)
                        
                        if let toId = message.chatPartnerId() {
                            self.messageDict[toId] = message
                            self.messages = Array(self.messageDict.values)
                            self.messages.sort { $0.timestamp!.intValue > $1.timestamp!.intValue }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                }
            }
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
        loginController.messagesController = self
        if #available(iOS 13.0, *) {
            loginController.isModalInPresentation = true
        }
        messages.removeAll()
        tableView.reloadData()
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func newMessageClicked() {
        let newMessageViewController = SelectUserViewController()
        newMessageViewController.messagesController = self
        let newMessageController = UINavigationController(rootViewController: newMessageViewController)
//        newMessageController.modalPresentationStyle = .fullScreen
        present(newMessageController, animated: true, completion: nil)
    }
    
    @objc func showChatView(withUser user: User) {
        let chatViewController = ChatViewController()
        chatViewController.user = user
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Just a fast way to make a easy cell
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.cellId) as! MessageTableViewCell
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child(FirebaseRef.users).child(chatPartnerId)
        ref.observe(.value) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User()
                user.id = chatPartnerId
                user.setValuesForKeys(dict)
                
                DispatchQueue.main.async {
                    self.showChatView(withUser: user)
                }
            }
        }
    }
}
