//
//  MainViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/2/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    
    
    // buttons
    @IBOutlet weak var addButton: UIButton!
    
    // UIContainer View's
    @IBOutlet var recentlyAddedView: UIView!
    @IBOutlet var allContactsView: UIView!
    

    // Constraints
    @IBOutlet var listViewConstraint: NSLayoutConstraint!
    @IBOutlet var bottomImageViewConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpButton()
        self.transparentNavBar()
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func contactsButtonTapped(_ sender: Any) {
        self.menuShowing()
        self.view.bringSubview(toFront: allContactsView)
        recentlyAddedView.isHidden = true
        allContactsView.isHidden = false
    }
   
    
    @IBAction func recentlyAddedButtonTapped(_ sender: Any) {
        self.menuShowing()
        self.view.bringSubview(toFront: recentlyAddedView)
        recentlyAddedView.isHidden = false
        allContactsView.isHidden = true
    }
    
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.listViewConstraint.constant = 504
            self.bottomImageViewConstraint.constant = 478
            self.addButton.alpha = 1
            self.view.layoutIfNeeded()
            
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


// MARK: - Asthetics & Animation

extension MainViewController {
    
    
    func setUpButton() {
        self.addButton.center.x = self.view.center.x
        self.addButton.alpha = 1
        self.addButton.layer.cornerRadius = 3
        self.addButton.clipsToBounds = true
    }
    
    
    func transparentNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    
    func menuShowing() {
        UIView.animate(withDuration: 0.5) {
            self.listViewConstraint.constant = -8
            self.bottomImageViewConstraint.constant = -400
            self.view.layoutIfNeeded()
        }
    }
    
}
