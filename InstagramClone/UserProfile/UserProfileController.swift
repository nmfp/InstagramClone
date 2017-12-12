//
//  UserProfileController.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 03/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
//        navigationItem.title = Auth.auth().currentUser?.uid
        
        
        
        fetchUser()
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerId")
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        
        setupLogoutButton()
        
//        fetchPosts()
        
//        fetchOrderedPosts()
    }
    
    var userId: String?
    var user: User?
    let cellId = "cellId"
    var posts = [Post]()
    
    fileprivate func fetchOrderedPosts() {
//        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        guard let uid = user?.uid else {return}
        
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            guard let user = self.user else {return}
            
            let post = Post(user: user, dictionary: dictionary)
            //Para garantir a ordem do ultimo a ser adicionado a ser o primeiro da lista
            self.posts.insert(post, at: 0)
//            self.posts.append(post)
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch ordered posts: ", err)
        }
    }
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot.value)
            
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            
            dictionaries.forEach({ (key, value) in
//                print("Key: \(key) Value: \(value)")
                //A key e o uid do user
                //value e um dicionario com todos os dados do post
                guard let dictionary = value as? [String: Any] else {return}
                
//                guard let imageUrl = dictionary["imageUrl"] as? String else {return}
                
//                print("ImageUrl: ", imageUrl)
                
                guard let user = self.user else {return}
                
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
                
            })
            self.collectionView?.reloadData()
            
            
        }) { (err) in
            print("Failed to fetch posts: ", err)
        }
    }
    
    fileprivate func setupLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout() {
         let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                
                //Show login page after signing out successfully
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            catch let signOutError {
                print("Failed so sign out: ", signOutError)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func fetchUser() {
//        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        
//        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot ) in
//            print(snapshot.value ?? "")
//
//            guard let dictionary = snapshot.value as? [String: Any] else {return}
////            let username = dictionary["username"] as? String
////            let profileImageUrl = dictionary["profileImageUrl"] as? String
//
//            self.user = User(uid: uid, dictionary: dictionary)
//
//            self.navigationItem.title = self.user?.username
//            self.collectionView?.reloadData()
//
//        }) { (err) in
//            print("Error fetching user: ", err)
//        }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = self.user?.username
            self.fetchOrderedPosts()
            self.collectionView?.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell

        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    //Define o numro de pixeis entre as celulas na horizontal, ou seja, linhas...
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //Define o numero de pixeis entre as celulas na vertical, ou seja, colunas
    //No entanto e necessario quando se retorna o tamanho de cada celula no metodo sizeForItem e necessario
    //ter em atencao o numero de pixeis total que vai ter em margens verticais, neste caso sao 2 porque sao
    //2 margens de 1 pixel cada, se nao se subtrairem esses 2 pixeis, a definicao do espacamento entre celulas na
    //horizontal no metodo minimumInteritemSpacingForSectionAt nao vai ter efeito
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        return header
    }
    
    //E sempre necessario definir este metodo. Definindo so a view do header nao funciona
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}


