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
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
