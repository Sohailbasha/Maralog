//
//  LoginCell.swift
//  Maralog
//
//  Created by Ilias Basha on 5/20/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class LoginCell: UICollectionViewCell {
    
    let logoImageView: UIImageView = {
        let image = UIImage(named: "appLogo")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let enterUsernameTextField: leftPaddedTextField = {
        let textfield = leftPaddedTextField()
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 0.5
        textfield.placeholder = " enter your name to start"
        textfield.keyboardType = .alphabet
        textfield.keyboardAppearance = .light
        return textfield
    }()
    
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        let color = Keys.sharedInstance.mainColor
        button.backgroundColor = color
        button.setTitle("start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    weak var delegate: CustomCellDelegate?
    
    
    func handleLogin() {
        if let userName = enterUsernameTextField.text, !userName.isEmpty {
            UserController.sharedInstance.saveUserName(name: userName)
            delegate?.finishSigningIn()
        }
        print("Log in")
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(logoImageView)
        addSubview(enterUsernameTextField)
        addSubview(loginButton)
        
        _ = logoImageView.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -230, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        _ = enterUsernameTextField.anchor(logoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        _ = loginButton.anchor(enterUsernameTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class leftPaddedTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 5, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
}




