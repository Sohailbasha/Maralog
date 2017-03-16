//
//  TutorialPageViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 3/15/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstViewController = viewControllerList.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    lazy var viewControllerList: [UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = sb.instantiateViewController(withIdentifier: "tutorial1")
        let vc2 = sb.instantiateViewController(withIdentifier: "tutorial2")
        let vc3 = sb.instantiateViewController(withIdentifier: "tutorial3")
        let vc4 = sb.instantiateViewController(withIdentifier: "tutorial4")
        
        return [vc1, vc2, vc3, vc4]
    }()
  
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0 else {return nil}
        guard viewControllerList.count > previousIndex else {return nil}
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex else { return nil }
        guard viewControllerList.count > nextIndex else { return nil }
        return viewControllerList[nextIndex]
    }
}
