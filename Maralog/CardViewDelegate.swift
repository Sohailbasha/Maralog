import UIKit

protocol CardViewDelegate { }
extension CardViewDelegate where Self: UIView {
    
    // Cards shadow
    func setShadow() {
        self.layer.cornerRadius = 10
        let color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.25
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
}



