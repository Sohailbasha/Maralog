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

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var pageIndex: Int = 0
    

}


extension TutorialViewController {
    
    func setupView() {
        switch pageIndex {
        case 0:
            headerLabel.text = "What is Astrea"
            descriptionLabel.text = "It's..."
            
        case 1:
            headerLabel.text = "Saving a location"
            descriptionLabel.text = "See the when and where you added someone"
            
        case 2:
            headerLabel.text = "Auto Reply"
            descriptionLabel.text = "Suck at replying?"
            
        case 3:
            headerLabel.text = "Sync Save to your contacts"
            descriptionLabel.text = "It's..."
        default :
            break
        }
    }
}

extension TutorialViewController: StoryboardInitializable {
    static var storyboardName: String { return String(describing: TutorialStartViewController.self) }
}












