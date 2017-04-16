//
//  CustomTabBarController.swift
//  Maralog
//
//  Created by Ilias Basha on 4/15/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, CustomTabBarViewDelegate {
    
    override var selectedIndex: Int {
        didSet {
            tabView.select(index: selectedIndex)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        let frame = CGRect(x: 0,
                           y: view.frame.height - tabView.frame.height,
                           width: view.frame.width,
                           height: tabView.frame.height)
        tabView.frame = frame
        tabView.delegate = self
        view.addSubview(tabView)
        self.tabBarButtonTapped(at: 3)
        
//        tabView.select(index: 3)
    }

    // MARK: Outlets + Properties
    @IBOutlet var tabView: CustomTabView!

    func tabBarButtonTapped(at index: Int) {
        selectedIndex = index
    }
}
