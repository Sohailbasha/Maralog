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
        performSegue(withIdentifier: "toMainSegue", sender: self)
    }
    
    func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let bgTop: UIColor = UIColor(red: 101/255, green: 124/255, blue: 176/255, alpha: 100)
        let bgBottom: UIColor = UIColor(red: 45/255, green: 63/255, blue: 105/255, alpha: 100)
        gradientLayer.colors = [bgTop.cgColor, bgBottom.cgColor]
        self.view.layer.addSublayer(gradientLayer)
        
    }
}
