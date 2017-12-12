//
//  FirebaseUtils.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 10/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import  Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            
            print(user.username)
            completion(user)
            
        }) { (err) in
            print("Failed to fetch user: ", err)
        }
    }
}
