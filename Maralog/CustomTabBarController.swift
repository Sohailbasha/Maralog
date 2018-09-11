import UIKit

class CustomTabBarController: UITabBarController, CustomTabBarViewDelegate {
    
    override var selectedIndex: Int {
        didSet {
            tabView.select(index: selectedIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        let frame = CGRect(x: 0,
                           y: view.frame.height - tabView.frame.height,
                           width: view.frame.width,
                           height: tabView.frame.height)
        
        tabView.frame = frame
        tabView.delegate = self
        view.addSubview(tabView)
        self.tabBarButtonTapped(at: 1)
    }

    // MARK: Outlets + Properties
    @IBOutlet var tabView: CustomTabView!

   
    func tabBarButtonTapped(at index: Int) {
        selectedIndex = index
    }

}
