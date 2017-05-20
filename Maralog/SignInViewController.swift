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

    let pages: [Page] = {
        let firstPage = Page(title: "Welcome to Maralog", message: "It's free to send your books to the people in your life. Every recipient's first book is on us.", imageName: "page1")
        
        let secondPage = Page(title: "Never forget when and where you met someone", message: "Tap the More menu next to any book. Choose \"Send this Book\"", imageName: "page2")
        
        let thirdPage = Page(title: "Bad texter? We've got you", message: "Tap the More menu in the upper corner. Choose \"Send this Book\"", imageName: "page3")
        
        
        //let fourthPage = Page(title: "Recently Added Contacts", message: "Maralog will show who you've met in the last three days", imageName: "")
        
        return [firstPage, secondPage, thirdPage]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

 

  
    
    

}
