//
//  Comment.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 16/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import Foundation

struct Comment {
    let text: String
    let uid: String
    var user: User
    
    init(dictionary: [String: Any], user: User) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.user = user
    }
}
