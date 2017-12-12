//
//  UserSearchCell.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 10/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    var user: User? {
        didSet {
            guard let userProfileImage = user?.profileImageUrl else {return}
            guard let username = user?.username else { return }
            profileImageView.loadImage(urlString: userProfileImage)
            usernameLabel.text = username
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .yellow
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(separatorView)
        
        //Apesar de nao ser definido padding no cimo e no fim, estes vao conter um padding de 8
        //porque se esta a definir a altura da imagem em 50 e a altura da celula em 66 por isso uma
        //vez que esta centrada tera um padding de 8 em cada
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom:  bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        separatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
