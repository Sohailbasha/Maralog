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

        // Do any additional setup after loading the view.
    }

    @IBOutlet var nameTextField: UITextField!
    
    @IBAction func continueTouched(_ sender: Any) {
        
        //UserDefaults.standard.set(nameTextField.text, forKey: "name")
        UserController.sharedInstance.saveUserName(name: nameTextField.text)
        performSegue(withIdentifier: "toMainSegue", sender: self) 
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
