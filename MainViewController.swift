//
//  MainViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/2/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit
import Contacts

class MainViewController: UIViewController, RecentlyAddedDelegate, AllContactsCountDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpButton()
        self.transparentNavBar()
        self.setMenuConstraints()
        setUpGestures()
        if let numOfRecentContacts = numOfRecentContacts {
            numberOfNewContacts.text = "\(numOfRecentContacts)"
        }
        swipeDownLabel.alpha = 0
        selectionLine.layer.cornerRadius = 0.5 * selectionLine.bounds.width
        selectionLine.isHidden = true
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in }
    }
    
    
    // MARK: - Properties
    
    var menuShowing: Bool {
        return listViewBottomConstraint.constant == 0
    }
    var numOfRecentContacts: Int?
    let image = UIImageView()
    
    
    // MARK: - Outlets
    
    // Buttons
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var contactsButton: UIButton!
    // Labels
    @IBOutlet var numberOfContacts: UILabel!
    @IBOutlet var numberOfNewContacts: UILabel!
    @IBOutlet var swipeDownLabel: UILabel!
    // Stack Views
    @IBOutlet var recentlyAddedStack: UIStackView!
    @IBOutlet var contactsStack: UIStackView!
    // UIViews View's
    @IBOutlet var listView: UIView!
    @IBOutlet var selectionLine: UIView!
    // Containers
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
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 8,
                       initialSpringVelocity: 8,
                       options: [],
                       animations: {
                        self.selectionLine.center.x = self.contactsStack.center.x
                        
        }, completion: nil)
        setUpGestures()
    }
    
    @IBAction func recentlyAddedButtonTapped(_ sender: Any) {
        showContactsMenu()
        
        self.view.bringSubview(toFront: recentlyAddedView)
        recentlyAddedView.isHidden = false
        allContactsView.isHidden = true
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 8,
                       initialSpringVelocity: 8,
                       options: [],
                       animations: {
                        self.selectionLine.center.x = self.recentlyAddedStack.center.x
        }, completion: nil)
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
            self.selectionLine.isHidden = false
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
            self.selectionLine.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    func setUpGestures() {
        let swipeDown = UISwipeGestureRecognizer()
        swipeDown.direction = .down
        let swipeUp = UISwipeGestureRecognizer()
        swipeUp.direction = .up
        swipeDown.addTarget(self, action: #selector(hideContactsMenu))
        menuShowing == true ? self.view.addGestureRecognizer(swipeDown) : self.view.removeGestureRecognizer(swipeDown)
        swipeUp.addTarget(self, action: #selector(showContactsMenu))
        menuShowing == false ? self.view.addGestureRecognizer(swipeUp) : self.view.removeGestureRecognizer(swipeUp)
    }
    
    func swipeDownIcon() {
        let frame = CGRect(x: 200, y: 60, width: 30, height: 30)
        image.frame = frame
        image.image = #imageLiteral(resourceName: "Swipe Down")
        image.contentMode = .scaleAspectFill
        image.alpha = 0.5
        self.view.addSubview(image)
    }
    
    func recentlyAddedContacts(count: Int) {
        numberOfNewContacts.text = "\(count)"
    }
    
    func allContacts(count: Int) {
        numberOfContacts.text = "\(count)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recentlyAdded" {
            guard let recentVC = segue.destination as? RecentlyAddedViewController else { return }
            recentVC.delegate = self
        }
        if segue.identifier == "allContacts" {
            guard let allContactsVC = segue.destination as? ContactsListViewController else { return }
            allContactsVC.delegate = self
        }
    }
}













