//
//  TutorialViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 3/14/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Outlets
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var startButton: UIButton!
    var pageIndex: Int = 0
    
 
    @IBAction func startButtonTapped(_ sender: Any) {

    }


    
}


extension TutorialViewController {
    
    func setupView() {
        switch pageIndex {
        case 0:
            startButton.isHidden = true
            headerLabel.text = "What is Astrea"
            descriptionLabel.text = "It's..."
            
        case 1:
            startButton.isHidden = true
            headerLabel.text = "Saving a location"
            descriptionLabel.text = "See the when and where you added someone"
            
        case 2:
            startButton.isHidden = true
            headerLabel.text = "Auto Reply"
            descriptionLabel.text = "Suck at replying?"
            
        case 3:
            startButton.isHidden = true
            headerLabel.text = "Sync Save to your contacts"
            descriptionLabel.text = "It's..."
        case 4:
            startButton.isHidden = true
            headerLabel.text = "You're all ready to use it"
            descriptionLabel.text = ""
            
        default :
            break
        }
    }
}

extension TutorialViewController: StoryboardInitializable {
    static var storyboardName: String { return "Tutorial" }
}












