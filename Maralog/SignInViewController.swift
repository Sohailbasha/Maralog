//
//  SignInViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 5/20/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
    }()
    
    let cellId = "cellId"
    let loginCellId = "loginCellId"

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

 

  
    
    

}
