//
//  OnboardingViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 3/11/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet var nameTextField: UITextField!
    
    @IBAction func continueTouched(_ sender: Any) {
        UserController.sharedInstance.saveUserName(name: nameTextField.text)
        performSegue(withIdentifier: "toTutorialSegue", sender: self)
    }
    
}
