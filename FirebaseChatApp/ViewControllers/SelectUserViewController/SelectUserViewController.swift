//
//  SelectUserViewController.swift
//  FirebaseChatApp
//
//  Created by Ibrahim Yildirim on 04/10/2019.
//  Copyright © 2019 Ibrahim Yildirim. All rights reserved.
//

import UIKit
import Firebase

class SelectUserViewController: UITableViewController {
        
    var users = [User]()
    var messagesController: MessagesViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New Message"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        fetchUsers()
    }
    
    func fetchUsers() {
        guard let userUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child(FirebaseRef.users).observe(.childAdded) { snapshot in
            
            if let dictionary = snapshot.value as? [String : Any] {
                if userUid != snapshot.key {
                    let user = User()
                    user.setValuesForKeys(dictionary)
                    user.id = snapshot.key
                    self.users.append(user)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
//                print(user.name, user.email)
            }
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //This is not memory efficient, but we proceed like this for simplicity
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        let user = users[indexPath.row]
        
        cell?.textLabel?.text = user.name
        cell?.detailTextLabel?.text = user.email
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatView(withUser: user)
        }
    }
}

