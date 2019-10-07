//
//  MessageTableViewCell.swift
//  FirebaseChatApp
//
//  Created by Ibrahim Yildirim on 07/10/2019.
//  Copyright © 2019 Ibrahim Yildirim. All rights reserved.
//

import UIKit
import Firebase

class MessageTableViewCell: UITableViewCell {
    
    static let cellId = "MessageTableViewCell"

    @IBOutlet weak var txtUserName: UILabel!
    @IBOutlet weak var txtMessage: UILabel!
    @IBOutlet weak var txtTimestamp: UILabel!
    
    var message: Message? {
        didSet {
            if let toId = message?.toId {
                let ref = Database.database().reference().child(FirebaseRef.users).child(toId)
                ref.observe(.value) { snapshot in
//                    print(snapshot)
                    if let dict = snapshot.value as? [String : Any] {
                        self.txtUserName?.text = dict[FirebaseRef.UserRef.name] as? String
                    }
                }
            }
            
            if let seconds = message?.timestamp?.doubleValue  {
                let timestamp = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                self.txtTimestamp.text = dateFormatter.string(from: timestamp as Date)
            }
            self.txtMessage.text = message?.text
        }
    }
    
}
