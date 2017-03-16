//
//  LastTutorialViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 3/15/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class LastTutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func tapToGetStartedButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toMainSegue", sender: self)
    }


}
