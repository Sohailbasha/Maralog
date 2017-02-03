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
        self.setCornersForAddButton()
    }

    
    @IBOutlet weak var addButton: UIButton!
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}




//UI

extension MainViewController {
    func setCornersForAddButton() {
        self.addButton.layer.cornerRadius = 20
        addButton.clipsToBounds = true
    }
}
