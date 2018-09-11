import UIKit

class Keys {

    // MARK: - COLOR KEYS
    static let sharedInstance = Keys()
    
    
    
    let trimColor = #colorLiteral(red: 0, green: 0.8470588235, blue: 0.6352941176, alpha: 1)
    let mainColor = #colorLiteral(red: 0.2588235294, green: 0.5450980392, blue: 0.9725490196, alpha: 1)
    
    
    // *
    let tabBarDefault = #colorLiteral(red: 0.6641708968, green: 0.651147938, blue: 0.651147938, alpha: 1)
    let tabBarSelected = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
    
    let switchActivatedColor = #colorLiteral(red: 0, green: 0.8470588235, blue: 0.6352941176, alpha: 1)
    let confirmColor = UIColor(red: 137/255, green: 216/255, blue: 144/255, alpha: 1)
    let errorColor = UIColor(red: 255/255, green: 101/255, blue: 98/255, alpha: 1)
    
    
    let k1 = #colorLiteral(red: 0.3921568627, green: 0.7882352941, blue: 1, alpha: 1)
    let k2 = #colorLiteral(red: 0.4392156863, green: 0.6705882353, blue: 0.9960784314, alpha: 1)
    let k3 = #colorLiteral(red: 0.4862745098, green: 0.5803921569, blue: 0.9960784314, alpha: 1)
    let k4 = #colorLiteral(red: 0.5607843137, green: 0.537254902, blue: 0.9960784314, alpha: 1)
    let k5 = #colorLiteral(red: 0.7019607843, green: 0.5843137255, blue: 0.9960784314, alpha: 1)
    let k6 = #colorLiteral(red: 0.8235294118, green: 0.6352941176, blue: 0.9960784314, alpha: 1)
    
    
    func randomColor() -> UIColor {
        let gradientColors = [k1, k2, k3, k4, k5, k6]
        let randomIndex = Int(arc4random_uniform(UInt32(gradientColors.count)))
        let color = gradientColors[randomIndex]
        
        return color
    }

}
