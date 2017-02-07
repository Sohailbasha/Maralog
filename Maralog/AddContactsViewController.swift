//
//  AddContactsViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 2/6/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class AddContactsViewController: UIViewController, UITextFieldDelegate {
    
    
    // MARK: - Outlets
    
    
    // text fields
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    // labels for textfields
    @IBOutlet var labelOfPhoneNumber: UILabel!
    @IBOutlet var labelOfFirstName: UILabel!
    @IBOutlet var labelOfLastName: UILabel!
 
    
    
    // MARK: - Action
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let phoneNumber = phoneNumberTextField.text else { return }
        
        let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        ContactController.sharedInstance.addContact(contact: contact)
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "update"), object: nil)
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.transparentNavBar()
        self.detailLabelsAreInvisible()
        
    }
    
    
    
}




//MARK: - Asthetics & Animation

extension AddContactsViewController {
    
    
    func transparentNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    
    func detailLabelsAreInvisible() {
        self.labelOfPhoneNumber.alpha = 0
        self.labelOfFirstName.alpha = 0
        self.labelOfLastName.alpha = 0
    }
    
    
}
