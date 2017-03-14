//
//  TutorialStartViewController.swift
//  Maralog
//
//  Created by Ilias Basha on 3/14/17.
//  Copyright © 2017 Sohail. All rights reserved.
//

import UIKit

class TutorialStartViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController.setViewControllers([TutorialViewController.initializeFromStoryboard()], direction: .forward, animated: true, completion: nil)

    }

    var pageViewController: UIPageViewController!
    static var pageIndex = 0
    static let pages = 4
    
    
    

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedPageViewController" {
            pageViewController = segue.destination as! UIPageViewController
            pageViewController.dataSource = self
            pageViewController.delegate = self
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcBefore = viewController as? TutorialViewController else { return nil }
        switch vcBefore.pageIndex {
        case 0:
            return nil
        case 1:
            let tutorialPage = TutorialViewController.initializeFromStoryboard()
            TutorialStartViewController.pageIndex = 0
            tutorialPage.pageIndex = TutorialStartViewController.pageIndex
            return tutorialPage
        case 2:
            let tutorialPage = TutorialViewController.initializeFromStoryboard()
            TutorialStartViewController.pageIndex = 1
            tutorialPage.pageIndex = TutorialStartViewController.pageIndex
            return tutorialPage
        case 3:
            let tutorialPage = TutorialViewController.initializeFromStoryboard()
            TutorialStartViewController.pageIndex = 2
            tutorialPage.pageIndex = TutorialStartViewController.pageIndex
            return tutorialPage
        case 4:
            let tutorialPage = TutorialViewController.initializeFromStoryboard()
            TutorialStartViewController.pageIndex = 3
            tutorialPage.pageIndex = TutorialStartViewController.pageIndex
            return tutorialPage
        default :
            break
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcAfter = viewController as? TutorialViewController else { return nil }
        switch vcAfter.pageIndex {
        case 0:
            let tutorialPage = TutorialViewController.initializeFromStoryboard()
            TutorialStartViewController.pageIndex = 1
            tutorialPage.pageIndex = TutorialStartViewController.pageIndex
            return tutorialPage
        case 1:
            let tutorialPage = TutorialViewController.initializeFromStoryboard()
            TutorialStartViewController.pageIndex = 2
            tutorialPage.pageIndex = TutorialStartViewController.pageIndex
            return tutorialPage
        case 2:
            let tutorialPage = TutorialViewController.initializeFromStoryboard()
            TutorialStartViewController.pageIndex = 3
            tutorialPage.pageIndex = TutorialStartViewController.pageIndex
            return tutorialPage
        case 3:
            let tutorialPage = TutorialViewController.initializeFromStoryboard()
            TutorialStartViewController.pageIndex = 4
            tutorialPage.pageIndex = TutorialStartViewController.pageIndex
            return tutorialPage
        case 4:
            presentingViewController?.dismiss(animated: true, completion: nil)
        default :
            break
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return TutorialStartViewController.pages
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return TutorialStartViewController.pageIndex
    }
}







