import UIKit

protocol Fadeable {}

extension Fadeable where Self: UIView {
    func fadeIn() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }
}
