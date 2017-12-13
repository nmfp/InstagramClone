//
//  Post.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 08/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

struct Post {
    
    let user: User
    var imageUrl: String
    var caption: String
    var creationDate: Date
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
