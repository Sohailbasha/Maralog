//
//  MyStyleKit.swift
//  Maralog
//
//  Created by Sohail on 5/15/17.
//  Copyright © 2017 . All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//



import UIKit

public class MyStyleKit : NSObject {

    //// Cache

    private struct Cache {
        static let gradientColor: UIColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1.000)
        static let gradientColor2: UIColor = UIColor(red: 0.922, green: 0.922, blue: 0.922, alpha: 1.000)
        static let gradientColor3: UIColor = UIColor(red: 0.880, green: 0.280, blue: 0.280, alpha: 1.000)
        static let gradientColor4: UIColor = UIColor(red: 0.720, green: 0.520, blue: 0.840, alpha: 1.000)
        static let gradient: CGGradient = CGGradient(colorsSpace: nil, colors: [MyStyleKit.gradientColor2.cgColor, MyStyleKit.gradientColor.cgColor] as CFArray, locations: [0, 1])!
        static let gradient3: CGGradient = CGGradient(colorsSpace: nil, colors: [MyStyleKit.gradientColor3.cgColor, MyStyleKit.gradientColor4.cgColor] as CFArray, locations: [0, 1])!
        static var imageOfCanvas1: UIImage?
        static var canvas1Targets: [AnyObject]?
        static var imageOfGradientBackground: UIImage?
        static var gradientBackgroundTargets: [AnyObject]?
    }

    //// Colors

    public dynamic class var gradientColor: UIColor { return Cache.gradientColor }
    public dynamic class var gradientColor2: UIColor { return Cache.gradientColor2 }
    public dynamic class var gradientColor3: UIColor { return Cache.gradientColor3 }
    public dynamic class var gradientColor4: UIColor { return Cache.gradientColor4 }

    //// Gradients

    public dynamic class var gradient: CGGradient { return Cache.gradient }
    public dynamic class var gradient3: CGGradient { return Cache.gradient3 }

    //// Drawing Methods

    public dynamic class func drawCanvas1(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 124, height: 97), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 124, height: 97), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 124, y: resizedFrame.height / 97)


        //// Logo
        //// Group 3
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        //// Clip Clip
        let clipPath = UIBezierPath()
        clipPath.move(to: CGPoint(x: 124.3, y: 0))
        clipPath.addLine(to: CGPoint(x: 124.3, y: 96.54))
        clipPath.addLine(to: CGPoint(x: 43, y: 96.54))
        clipPath.addLine(to: CGPoint(x: 124.3, y: 0))
        clipPath.close()
        clipPath.usesEvenOddFillRule = true
        clipPath.addClip()


        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 124.3, y: 0))
        bezierPath.addLine(to: CGPoint(x: 124.3, y: 96.54))
        bezierPath.addLine(to: CGPoint(x: 43, y: 96.54))
        bezierPath.addLine(to: CGPoint(x: 124.3, y: 0))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        context.saveGState()
        bezierPath.addClip()
        context.drawLinearGradient(MyStyleKit.gradient3,
            start: CGPoint(x: 83.65, y: 0),
            end: CGPoint(x: 83.65, y: 115.64),
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context.restoreGState()


        context.endTransparencyLayer()
        context.restoreGState()


        //// Group 4
        context.saveGState()
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        //// Clip Clip 2
        let clip2Path = UIBezierPath()
        clip2Path.move(to: CGPoint(x: 81.3, y: 0))
        clip2Path.addLine(to: CGPoint(x: 81.3, y: 96.54))
        clip2Path.addLine(to: CGPoint(x: 0, y: 96.54))
        clip2Path.addLine(to: CGPoint(x: 81.3, y: 0))
        clip2Path.close()
        clip2Path.usesEvenOddFillRule = true
        clip2Path.addClip()


        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 81.3, y: 0))
        bezier4Path.addLine(to: CGPoint(x: 81.3, y: 96.54))
        bezier4Path.addLine(to: CGPoint(x: 0, y: 96.54))
        bezier4Path.addLine(to: CGPoint(x: 81.3, y: 0))
        bezier4Path.close()
        bezier4Path.usesEvenOddFillRule = true
        context.saveGState()
        bezier4Path.addClip()
        context.drawLinearGradient(MyStyleKit.gradient3,
            start: CGPoint(x: 40.65, y: 0),
            end: CGPoint(x: 40.65, y: 115.64),
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context.restoreGState()


        context.endTransparencyLayer()
        context.restoreGState()
        
        context.restoreGState()

    }

    public dynamic class func drawGradientBackground(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 375, height: 667), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 375, height: 667), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 375, y: resizedFrame.height / 667)


        //// Background Drawing
        let backgroundPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 375, height: 667))
        context.saveGState()
        backgroundPath.addClip()
        context.drawLinearGradient(MyStyleKit.gradient,
            start: CGPoint(x: 187.5, y: 667),
            end: CGPoint(x: 187.5, y: 0),
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        context.restoreGState()
        
        context.restoreGState()

    }

    //// Generated Images

    public dynamic class var imageOfCanvas1: UIImage {
        if Cache.imageOfCanvas1 != nil {
            return Cache.imageOfCanvas1!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 124, height: 97), false, 0)
            MyStyleKit.drawCanvas1()

        Cache.imageOfCanvas1 = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfCanvas1!
    }

    public dynamic class var imageOfGradientBackground: UIImage {
        if Cache.imageOfGradientBackground != nil {
            return Cache.imageOfGradientBackground!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 375, height: 667), false, 0)
            MyStyleKit.drawGradientBackground()

        Cache.imageOfGradientBackground = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfGradientBackground!
    }

    //// Customization Infrastructure

    @IBOutlet dynamic var canvas1Targets: [AnyObject]! {
        get { return Cache.canvas1Targets }
        set {
            Cache.canvas1Targets = newValue
            for target: AnyObject in newValue {
                let _ = target.perform(NSSelectorFromString("setImage:"), with: MyStyleKit.imageOfCanvas1)
            }
        }
    }

    @IBOutlet dynamic var gradientBackgroundTargets: [AnyObject]! {
        get { return Cache.gradientBackgroundTargets }
        set {
            Cache.gradientBackgroundTargets = newValue
            for target: AnyObject in newValue {
                let _ = target.perform(NSSelectorFromString("setImage:"), with: MyStyleKit.imageOfGradientBackground)
            }
        }
    }




    @objc(MyStyleKitResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
