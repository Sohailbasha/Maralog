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
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let enterUsernameTextField: leftPaddedTextField = {
        let textfield = leftPaddedTextField()
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 0.5
        textfield.placeholder = " enter your name to start"
        textfield.keyboardType = .alphabet
        textfield.keyboardAppearance = .dark
        return textfield
    }()
    
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.setTitle("start", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    let animationView: UIViewX = {
        let view = UIViewX()
        view.backgroundColor = .red
        return view
    }()
    
    var currentColorArrayIndex = -1
    var colorArray: [(color1: UIColor, color2: UIColor)] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(animationView)
        addSubview(logoImageView)
        addSubview(enterUsernameTextField)
        addSubview(loginButton)
        
        _ = logoImageView.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -230, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 100)
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        _ = enterUsernameTextField.anchor(logoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 20, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        _ = loginButton.anchor(enterUsernameTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        
        _ = animationView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width, heightConstant: frame.height)
        
        
        
        colorArray.append((color1: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), color2: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), color2: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1), color2: #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), color2: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), color2: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), color2: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), color2: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
        colorArray.append((color1: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), color2: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
        
//        animateBackgroundColor()


    }
    
    func animateBackgroundColor() {
        currentColorArrayIndex = currentColorArrayIndex == (colorArray.count - 1) ? 0 : currentColorArrayIndex + 1
        
        UIView.transition(with: animationView, duration: 2, options: .transitionCrossDissolve, animations: { 
            self.animationView.firstColor = self.colorArray[self.currentColorArrayIndex].color1
            self.animationView.secondColor = self.colorArray[self.currentColorArrayIndex].color2
        }) { (success) in
            self.animateBackgroundColor()
        }
        
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
