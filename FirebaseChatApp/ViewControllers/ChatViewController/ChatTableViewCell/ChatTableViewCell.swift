//
//  ChatTableViewCell.swift
//  FirebaseChatApp
//
//  Created by Ibrahim Yildirim on 07/10/2019.
//  Copyright © 2019 Ibrahim Yildirim. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    static let cellId = "ChatTableViewCell"
    
    @IBOutlet weak var vwUserMessage: UIView!
    @IBOutlet weak var vwPartnerMessage: UIView!
    @IBOutlet weak var lblUserMessage: UILabel!
    @IBOutlet weak var lblPartnerMessage: UILabel!
    
    var userMessage: String? {
        didSet {
            self.vwPartnerMessage.isHidden = true
            self.lblPartnerMessage.text = ""
            
            self.vwUserMessage.isHidden = false
            self.lblUserMessage.text = userMessage
        }
    }
    
    var partnerMessage: String? {
        didSet {
            self.vwPartnerMessage.isHidden = false
            self.lblPartnerMessage.text = partnerMessage
            
            self.vwUserMessage.isHidden = true
            self.lblUserMessage.text = ""
        }
    }
}
