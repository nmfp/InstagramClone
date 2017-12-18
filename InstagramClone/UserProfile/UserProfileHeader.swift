//
//  UserProfileHeader.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 03/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate {
    func didChangeToListView()
    func didChangeToGridView()
}

class UserProfileHeader: UICollectionViewCell {
    
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            setupProfileImage()
            usernameLabel.text = user?.username
            
            
            setupEditFollowButton()
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        button.tintColor = .mainBlue()
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        let attributtedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        attributtedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributtedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributtedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        attributtedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributtedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        
        let attributtedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributtedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        
        label.attributedText = attributtedText
        
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()

    @objc func handleChangeToGridView() {
        print("handle change to gridview")
        gridButton.tintColor = .mainBlue()
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToGridView()
    }
    
    @objc func handleChangeToListView() {
        print("handle change to listview")
        listButton.tintColor = .mainBlue()
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didChangeToListView()
    }
    
    @objc func handleEditProfileOrFollow() {
        guard let currentUserLoggedIn = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        
        let ref = Database.database().reference().child("following").child(currentUserLoggedIn)
        
        if editProfileFollowButton.titleLabel?.text == "Unfollow" {
            //unfollow
            ref.child(userId).removeValue(completionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to unfollow user: ", err)
                    return
                }
                print("Successfully unfollowed user: ", self.user?.username ?? "")
            })
            
            setupEditFollowButton()
//            setupFollowStyle()
        }
        else {
            //follow
            let values = [userId: 1]
            ref.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed do follow user: ", err)
                    return
                }
                
                print("Successfully followed user: ", self.user?.username ?? "")
                self.setupEditFollowButton()
            }
        }
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.layer.masksToBounds = true
        
        setupBottomToolbar()
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        setupUserStatsView()
        
        addSubview(editProfileFollowButton)
        
        editProfileFollowButton.anchor(top:  postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34 )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupFollowStyle() {
        self.editProfileFollowButton.setTitle("Follow", for: .normal)
        self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        self.editProfileFollowButton.setTitleColor(.white, for: .normal)
        self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        self.editProfileFollowButton.layer.borderWidth = 0.5
    }
    
    fileprivate func setupEditFollowButton() {
        guard let currentUserLoggedIn = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        
        if currentUserLoggedIn == userId {
            //Do edit profile logic here
        }
        else {
            
            //check if following
            Database.database().reference().child("following").child(currentUserLoggedIn).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                //Como no dicionario se esta a guardar o uid:1 quando se segue um user, tem que se comparar se existe esse valor igual a 1
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
                    self.editProfileFollowButton.backgroundColor = .white
                    self.editProfileFollowButton.setTitleColor(.black, for: .normal)
                    self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
                    self.editProfileFollowButton.layer.borderWidth = 0.5
                }
                else {
                    self.editProfileFollowButton.setTitle("Follow", for: .normal)
                    self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
                    self.editProfileFollowButton.setTitleColor(.white, for: .normal)
                    self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
                    self.editProfileFollowButton.layer.borderWidth = 0.5
                    
//                    setupFollowStyle()
                }
                
            }, withCancel: { (err) in
                print("Failed to check if following: ", err)
            })
            
            
            
        }
    }
    
    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }
    
    fileprivate func setupProfileImage() {
        guard let profileImageUrl = user?.profileImageUrl else {return}
//        guard let url = URL(string: profileImageUrl) else {return}
//
//        URLSession.shared.dataTask(with: url) { (data, resp, err) in
//            if let err = err {
//                print("Error getting profile Image: ", err)
//            }
//
//            guard let data = data else {return}
//
//            let image = UIImage(data: data)
//
//            DispatchQueue.main.async {
//                self.profileImageView.image = image
//            }
//        }.resume()
        profileImageView.loadImage(urlString: profileImageUrl)
    }
    
    fileprivate func setupBottomToolbar() {
        
        let topDividerLine = UIView()
        topDividerLine.backgroundColor = .lightGray
        
        let bottomDividerLine = UIView()
        bottomDividerLine.backgroundColor = .lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        
        addSubview(stackView)
        addSubview(topDividerLine)
        addSubview(bottomDividerLine)
        
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        topDividerLine.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        bottomDividerLine.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
}
