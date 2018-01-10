//
//  CommentInputAccessoryView.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 09/01/2018.
//  Copyright © 2018 Nuno Pereira. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter comment..."
        return textField
    }()
    
    
    lazy var submitButton: UIButton = {
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.addTarget(self, action: #selector(handleSubmmit), for: .touchUpInside)
        return submitButton
    }()
    
    func clearCommentTextField() {
        commentTextField.text = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .red
        
        
        
        
        
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        addSubview(commentTextField)
        commentTextField.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setupLineSeparatorView()
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparator = UIView()
        lineSeparator.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        addSubview(lineSeparator)
        lineSeparator.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right:  rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    @objc func handleSubmmit() {
        guard let comment = commentTextField.text else {return}
        delegate?.didSubmit(for: comment)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
