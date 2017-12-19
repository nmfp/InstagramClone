//
//  HomeController.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 09/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    let cellId = "cellId"
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Colocar a ViewController a escuta para quando o post for concluido esta executar o refresh do feed
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        collectionView?.backgroundColor = .white
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControll
        
        setupNavigationItems()
        fetchAllPosts()
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        //Necessario remover todos os posts de forma a que quando se unfollow um user os posts deste deixem de aparecer no feed
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else {return}
            
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostsWithUser(user: user)
                })
            })
            
        }) { (err) in
            print("Failed fetching following users uids: ", err)
        }
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
            
            //Terminar a animacao do UIRefreshControll
            self.collectionView?.refreshControl?.endRefreshing()
            
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            
            dictionaries.forEach({ (key, value) in
                //A key e o uid do user
                //value e um dicionario com todos os dados do post
                guard let dictionary = value as? [String: Any] else {return}
                
                //                    guard let imageUrl = dictionary["imageUrl"] as? String else {return}
                
                //                print("ImageUrl: ", imageUrl)
                
                var post = Post(user: user, dictionary: dictionary)
                
                //Vai-se guardar o ip do post na variavel id criada para se ter acesso a este no commentsController
                post.id = key
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    }
                    else {
                        post.hasLiked = false
                    }
                    
                    
                    self.posts.append(post)
                    self.posts.sort(by: {$0.creationDate.compare($1.creationDate) == .orderedDescending})
                    //            self.posts.sort(by: {$0.creationDate > $1.creationDate})
                    
                    self.collectionView?.reloadData()
                }, withCancel: { (err) in
                    print("Failed do fetch like info for post ", err)
                })
                
            })
            
            
            
        }) { (err) in
            print("Failed to fetch posts: ", err)
        }
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
        
        
    }
    
    @objc func handleCamera() {
        
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.item]
        
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 //altura da linha de cima da imagem, profileImage mais os paddings
        height += view.frame.width // Para a imagem ser um quadrado perfeito
        height += 50 //altura da barra por baixo da imagem com botoes
        height += 80
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func didTapComment(post: Post) {
        print("HomeController handling comments...")
        
        print(post)
        
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post 
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    func didLike(for cell: HomePostCell) {
        print("handling like inside controller")
        
        guard let indexPath = collectionView?.indexPath(for: cell) else {return}
        var post = posts[indexPath.item]
        
        guard let postId = post.id else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let values = [uid: post.hasLiked == true ? 0 : 1]
        
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Error saving likes: ", err)
                return
            }
            
            print("Sucessfully liked post")
            
            post.hasLiked = !post.hasLiked
            //Por vezes quando se retira um objecto de um array ele ganha outra referencia, ou seja, como se fosse por copia e
            //todas as alteracoes feitas nesse objecto recebido nao se refletem no mesmo no array, dai se afectar a posicao do
            //array novamente com o objecto modificado
            self.posts[indexPath.item] = post
            self.collectionView?.reloadItems(at: [indexPath])
        }
    }
}
