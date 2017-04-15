//
//  CustomTabView.swift
//  Maralog
//
//  Created by Ilias Basha on 4/15/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit


protocol CustomTabBarViewDelegate: class {
    func tabBarButtonTapped(at index: Int)
}

class CustomTabView: UIView {

    // MARK: - Outlets + Properties
    @IBOutlet var utilities: UIButton!
    @IBOutlet var recent: UIButton!
    @IBOutlet var contacts: UIButton!
    @IBOutlet var add: UIButton!
    
    weak var delegate: CustomTabBarViewDelegate?
    
    func select(index: Int) {
      
        switch index {
        case 0:
            UIView.animate(withDuration: 0.25, animations: { 
                self.utilities.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { (_) in
                self.utilities.transform = CGAffineTransform.identity
            })
            
        case 1:
            UIView.animate(withDuration: 0.25, animations: {
                self.recent.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { (_) in
                self.recent.transform = CGAffineTransform.identity
            })
            
        case 2:
            UIView.animate(withDuration: 0.25, animations: {
                self.contacts.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { (_) in
                self.contacts.transform = CGAffineTransform.identity
            })
            
        default:
            UIView.animate(withDuration: 0.25, animations: {
                self.add.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: { (_) in
                self.add.transform = CGAffineTransform.identity
            })
        }
        
        
    }
    
    
    @IBAction func didTapButton(_ sender: UIButton) {
        delegate?.tabBarButtonTapped(at: sender.tag)
    }
    

}







