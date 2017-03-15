//
//  OnboardingViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 3/11/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continuebutton.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBOutlet var continuebutton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    
    var didShowTutorial: Bool = false
    
    @IBAction func continueTouched(_ sender: Any) {
//        if didShowTutorial == false {
//            UserController.sharedInstance.saveUserName(name: nameTextField.text)
//            performSegue(withIdentifier: "toTutorialSegue", sender: self)
//            didShowTutorial = true
//        }
    }
    
    func goToMain() {
        performSegue(withIdentifier: "toMainSegue", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
