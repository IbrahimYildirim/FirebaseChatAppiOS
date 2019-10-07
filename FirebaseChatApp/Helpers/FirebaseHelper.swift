//
//  FirebaseHelper.swift
//  FirebaseChatApp
//
//  Created by Ibrahim Yildirim on 04/10/2019.
//  Copyright © 2019 Ibrahim Yildirim. All rights reserved.
//

import Foundation

struct FirebaseRef {
    
    static let users = "users"
    static let messages = "messages"
    static let userMessages = "user-messages"
    
    struct UserRef {
        static let email = "email"
        static let name = "name"
    }
    
    struct MessageRef {
        static let text = "text"
        static let toId = "toId"
        static let fromId = "fromId"
        static let timestamp = "timestamp"
    }
    
}

