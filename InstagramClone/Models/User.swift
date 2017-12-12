//
//  USer.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 10/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import Foundation

struct User {
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
