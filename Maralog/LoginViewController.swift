//
//  LoginViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 5/8/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
 
    var collectionView: UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = .red
        
        return cv
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(collectionView)
        collectionView.anchorToTop(top: view.topAnchor,
                                   left: view.leftAnchor,
                                   bottom: view.bottomAnchor,
                                   right: view.rightAnchor)
    }

   
}


extension UIView {
    
    func anchorToTop(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil) {
        
        anchorWithConstantsToTop(top: top, left: left, bottom: bottom, right: right, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    func anchorWithConstantsToTop(top: NSLayoutYAxisAnchor? = nil,
                                  left: NSLayoutXAxisAnchor? = nil,
                                  bottom: NSLayoutYAxisAnchor? = nil,
                                  right: NSLayoutXAxisAnchor? = nil,
                                  topConstant: CGFloat = 0,
                                  leftConstant: CGFloat = 0,
                                  bottomConstant: CGFloat = 0,
                                  rightConstant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: bottomConstant).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftConstant)
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: rightConstant)
        }
        
    }
    
}
