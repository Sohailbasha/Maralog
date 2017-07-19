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
        self.tabBarButtonTapped(at: 1)
        
        colorArray.append((color1: Keys.sharedInstance.k1, color2: Keys.sharedInstance.k2))
        colorArray.append((color1: Keys.sharedInstance.k3, color2: Keys.sharedInstance.k4))
        colorArray.append((color1: Keys.sharedInstance.k5, color2: Keys.sharedInstance.k6))
        
        animateGradient()
    }

    // MARK: Outlets + Properties
    @IBOutlet var tabView: CustomTabView!

    @IBOutlet var colorLine: ColorView!
    
    var colorArray: [(color1: UIColor, color2: UIColor)] = []
    var currentColorArrayIndex = -1
    

    
    func tabBarButtonTapped(at index: Int) {
        selectedIndex = index
    }
    
    
    
    func animateGradient() {
        currentColorArrayIndex = currentColorArrayIndex == (colorArray.count - 1) ? 0 : currentColorArrayIndex + 1
        UIView.transition(with: colorLine, duration: 0.75, options: [.transitionCrossDissolve], animations: {
            self.colorLine.firstColor = self.colorArray[self.currentColorArrayIndex].color1
            self.colorLine.secondColor = self.colorArray[self.currentColorArrayIndex].color2
            
        }) { (success) in
            self.animateGradient()
        }
    }
    
}
