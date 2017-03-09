//
//  MainViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/2/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit
import Contacts

class MainViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpButton()
        self.transparentNavBar()
        self.setMenuConstraints()
        numContacts.text = ""
        numRecAdded.text = ""
        swipeDownLabel.alpha = 0
    }
    
    
    // MARK: - Properties
    
    var menuShowing: Bool {
        return listViewBottomConstraint.constant == 0
    }
    
    let image = UIImageView()

    
    // MARK: - Outlets

    // Buttons
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var contactsButton: UIButton!
    
    
    // Labels
    @IBOutlet var numContacts: UILabel!
    @IBOutlet var numRecAdded: UILabel!
    @IBOutlet var swipeDownLabel: UILabel!
    
    
    // UIContainer View's
    @IBOutlet var listView: UIView!
    @IBOutlet var recentlyAddedView: UIView!
    @IBOutlet var allContactsView: UIView!
    
    // Constraints
    @IBOutlet var listViewConstraint: NSLayoutConstraint!
    @IBOutlet var bottomImageViewConstraint: NSLayoutConstraint!
    @IBOutlet var listViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var listViewHeightConstraint: NSLayoutConstraint!

    
    // MARK: - Actions
    
    @IBAction func contactsButtonTapped(_ sender: Any) {
        showContactsMenu()
        
        self.view.bringSubview(toFront: allContactsView)
        recentlyAddedView.isHidden = true
        allContactsView.isHidden = false
        setUpGestures()
    }
   
    @IBAction func recentlyAddedButtonTapped(_ sender: Any) {
        showContactsMenu()
        
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
            
            self.swipeDownLabel.alpha = 0.5
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
            
            self.swipeDownLabel.alpha = 0
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
    
    func swipeDownIcon() {
        let frame = CGRect(x: 200, y: 60, width: 30, height: 30)
        image.frame = frame
        image.image = #imageLiteral(resourceName: "Swipe Down")
        image.contentMode = .scaleAspectFill
        image.alpha = 0.5
        self.view.addSubview(image)
    }
    
}













