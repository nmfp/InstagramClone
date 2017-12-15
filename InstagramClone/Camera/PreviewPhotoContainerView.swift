//
//  PreviewPhotoContainerView.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 14/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import  Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    lazy var saveLabel: UILabel = {
        let label = UILabel()
        label.text = "Saved Successfully"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.backgroundColor = UIColor(white: 0, alpha: 0.3)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        label.center = self.center
        return label
    }()
    
    @objc func handleCancel() {
        self.removeFromSuperview()
    }
    
    @objc func handleSave() {
        
        guard let previewImage = previewImageView.image else {return}
        
        //Para guardar as fotografias no album e necessario ter uma referencia para a galeria
        let library = PHPhotoLibrary.shared()
        
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, err) in
            if let err = err {
                print("Failed to save photo to library: ", err)
            }
            
            print("Successfully saved image to library!")
            
            DispatchQueue.main.async{
                self.addSubview(self.saveLabel)
                
                //Valor inicial da label quando comeca a animacao, neste caso invisivel praticamente
                self.saveLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    //coloca ate a escala de 1,1,1 neste caso o tamanho original definido na frame
                    self.saveLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (completed) in
                    //completed
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        //coloca ate a escala de 0.1,0.1,0.1 pois se se meter a escala 0,0,0 a label desaparece simplesmente e nao de forma animada // BUG
                        self.saveLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        //Faz com que fique transparente aquando a animacao dando ao user um aspecto mais animado
                        self.saveLabel.alpha = 0
                    }, completion: { (completed) in
                        //completed
                        self.saveLabel.removeFromSuperview()
                    })
                    
                })
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .yellow
        
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 24, paddingRight: 0, width: 50, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
