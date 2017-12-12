//
//  HomeController.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 09/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
    
        setupNavigationItems()
        
        fetchPosts()
    }
    
    //A razao para aqui se estar a usar o observerSingleEvent com .Value em vez do .ChildAdded como no UserProfileController
    //e que se algum dos contactos que o user segue adicionar algum post a UI comeca a fazer scroll automaticamente
    //fazendo com que o user perca o controlo do UI
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
//        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            
            dictionaries.forEach({ (key, value) in
                //A key e o uid do user
                //value e um dicionario com todos os dados do post
                guard let dictionary = value as? [String: Any] else {return}
                
                //                    guard let imageUrl = dictionary["imageUrl"] as? String else {return}
                
                //                print("ImageUrl: ", imageUrl)
                
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
                
            })
            self.collectionView?.reloadData()
            
            
        }) { (err) in
            print("Failed to fetch posts: ", err)
        }
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 //altura da linha de cima da imagem, profileImage mais os paddings
        height += view.frame.width // Para a imagem ser um quadrado perfeito
        height += 50 //altura da barra por baixo da imagem com botoes
        height += 80
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    
}
