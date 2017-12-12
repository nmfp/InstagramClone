//
//  UserSearchController.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 10/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        
        //Para alterar a cor da UISearchBar e necessario definir a propriedade barTintColor (a cor definida nao e
        //relevante) e depois definir a backgroundColor da UITextField que esta a ser instanciada na
        //UISearchBar e aqui assim e que a cor definida interessa e prevalece
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.placeholder = "Enter username"
        sb.delegate = self
        return sb
    }()
    
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.alwaysBounceVertical = true
        
//        navigationItem.titleView = searchBar
        
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
        
        //Esconde o teclado ao interagir com a collectionView
        collectionView?.keyboardDismissMode = .onDrag
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.isHidden = false
    }
    
    var filteredUsers = [User]()
    var users = [User]()
    
    fileprivate func fetchUsers() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Database.database().reference().child("users").observe(.value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            
            dictionaries.forEach({ (key, value) in
                if key == uid { return } // Elimina o user logado da lista de users a pesquisar
                guard let userDictionary = value as? [String: Any] else {return}
                let user = User(uid: key, dictionary: userDictionary)
                
                self.users.append(user)
            })
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Error fetching users: ", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Esconde a searchBar quando vai fazer a transicao para viewController do user
        searchBar.isHidden = true
        //Faz esconder o teclado quando seleccionado um user
        searchBar.resignFirstResponder()
        
        let user = filteredUsers[indexPath.item]
        let userProfilteController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfilteController.userId = user.uid
        navigationController?.pushViewController(userProfilteController, animated: true)
    }
    
    //searchText e o texto que esta a ser escrito no momento na searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        }
        else {
            filteredUsers = users.filter { user in user.username.lowercased().contains(searchText.lowercased())}
        }
        
        self.collectionView?.reloadData()
    }
}
