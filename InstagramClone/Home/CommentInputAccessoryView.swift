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
    
    let commentTextField: CommentInputTextView = {
        let tv = CommentInputTextView()
//        textField.placeholder = "Enter comment..."
//        tv.backgroundColor = .red
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.isScrollEnabled = false
        return tv
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
        commentTextField.showPlaceholderLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        //Propriedade que se tem que definir no caso de ser necessario alterar a altura
        autoresizingMask = .flexibleHeight
        
        
        
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
        addSubview(commentTextField)
        
        if #available(iOS 11.0, *) {
            commentTextField.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        } else {
            // Fallback on earlier versions
        }
        
        setupLineSeparatorView()
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
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
