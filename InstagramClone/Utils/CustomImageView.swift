//
//  CustomImageView.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 08/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        
        //O facto de no inicio se afectar a nil faz com que deixe de existir o efeito fliquering dando uma melhor UX
        self.image = nil
        
        lastURLUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
        }
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed do fetch photo from url: ", err)
                return
            }
            //Uma vez que o load das imagens e assincrono e nao se consegue garantir a ordem de conclusao
            //esta validacao impede que se carregue imagens repetidas
            //Cria-se uma variavel auxiliar que vai guardar o ultimo url utilizadao para carregar uma image
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let data = data else {return}
            let photoImage = UIImage(data: data)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()
    }
}
