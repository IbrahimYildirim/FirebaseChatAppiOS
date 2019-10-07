//
//  Message.swift
//  FirebaseChatApp
//
//  Created by Ibrahim Yildirim on 04/10/2019.
//  Copyright © 2019 Ibrahim Yildirim. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    @objc var fromId: String?
    @objc var toId: String?
    @objc var text: String?
    @objc var timestamp: NSNumber?
    
}
