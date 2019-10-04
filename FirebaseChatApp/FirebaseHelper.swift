//
//  FirebaseHelper.swift
//  FirebaseChatApp
//
//  Created by Ibrahim Yildirim on 04/10/2019.
//  Copyright © 2019 Ibrahim Yildirim. All rights reserved.
//

import Foundation

struct FirebaseConstants {
    
    static let urlPath = "https://hocfirebasechat.firebaseio.com/"

    struct References {
        static let users = "users"
    }
    
    struct UserValues {
        static let email = "email"
        static let name = "name"
    }
}
