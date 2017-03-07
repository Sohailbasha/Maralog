//
//  MainViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/2/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpButton()
        self.transparentNavBar()
        self.setMenuConstraints()
    }
    
    
    // MARK: - Properties
    
    var menuShowing: Bool {
        return listViewBottomConstraint.constant == 0
    }
    
    
    // MARK: - Outlets

    // Buttons
    @IBOutlet weak var addButton: UIButton!
    
    // UIContainer View's
    @IBOutlet var recentlyAddedView: UIView!
    @IBOutlet var allContactsView: UIView!
    
    // Constraints
    @IBOutlet var listViewConstraint: NSLayoutConstraint!
    @IBOutlet var bottomImageViewConstraint: NSLayoutConstraint!
    @IBOutlet var listViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var listViewHeightConstraint: NSLayoutConstraint!

    
    // MARK: - Actions
    
    @IBAction func contactsButtonTapped(_ sender: Any) {
        self.showContactsMenu()
        self.view.bringSubview(toFront: allContactsView)
        recentlyAddedView.isHidden = true
        allContactsView.isHidden = false
        setUpGestures()
    }
   
    @IBAction func recentlyAddedButtonTapped(_ sender: Any) {
        self.showContactsMenu()
        self.view.bringSubview(toFront: recentlyAddedView)
        recentlyAddedView.isHidden = false
        allContactsView.isHidden = true
        setUpGestures()
    }
}


// MARK: - Helper Methods

extension MainViewController {
    
    func setUpButton() {
        self.addButton.center.x = self.view.center.x
        self.addButton.alpha = 1
        self.addButton.layer.cornerRadius = 7
        self.addButton.clipsToBounds = true
    }
    
    func transparentNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func setMenuConstraints() {
        let viewHeight = self.view.frame.height
        self.listViewHeightConstraint.constant = viewHeight
        self.bottomImageViewConstraint.constant = (viewHeight / 1.1)
        self.listViewConstraint.constant = (viewHeight / 1.15)
        self.view.layoutIfNeeded()
    }
    
    func showContactsMenu() {
        UIView.animate(withDuration: 0.5) {
            let viewHeight = self.view.frame.height
            self.listViewConstraint.constant = (viewHeight / 9.9)
            self.bottomImageViewConstraint.constant = (-viewHeight)
            self.listViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func hideContactsMenu() {
        UIView.animate(withDuration: 0.5) {
            let viewHeight = self.view.frame.height
            self.bottomImageViewConstraint.constant = (viewHeight / 1.1)
            self.listViewConstraint.constant = (viewHeight / 1.15)
            self.listViewBottomConstraint.constant = -568
            self.addButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func setUpGestures() {
        
        let swipeDown = UISwipeGestureRecognizer()
        swipeDown.direction = .down
        swipeDown.addTarget(self, action: #selector(hideContactsMenu))
        menuShowing == true ? self.view.addGestureRecognizer(swipeDown) : self.view.removeGestureRecognizer(swipeDown)
    }
    
}













