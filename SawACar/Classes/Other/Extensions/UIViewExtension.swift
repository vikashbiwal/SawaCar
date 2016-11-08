//
//  UIViewExtension.swift
//  manup
//
//  Created by Tom Swindell on 09/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore


//MARK: - Graphics
extension UIView {
    
    func makeRound() {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    
    func makeRoundByHeight() {
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
    
    func makeRoundByWidth() {
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
    }
    
    func fadeAlpha(toAlpha: CGFloat, duration time: NSTimeInterval) {
        UIView.animateWithDuration(time) { () -> Void in
            self.alpha = toAlpha
        }
    }
    
    // Will add mask to given image
    func mask(maskImage: UIImage) {
        let mask: CALayer = CALayer()
        mask.frame = CGRectMake( 0, 0, maskImage.size.width, maskImage.size.height)
        mask.contents = maskImage.CGImage
        layer.mask = mask
        layer.masksToBounds = true
    }
    
    func addMask(maskImage: UIImage) {
        let mask = CALayer()
        mask.frame = CGRectMake( 0, 0, maskImage.size.width, maskImage.size.height)
        mask.contents = maskImage.CGImage
        layer.addSublayer(mask)
    }
    
}

extension UIView {
    
    // Will take screen shot of whole screen and return image. It's working on main thread and may lag UI.
    func takeScreenShot() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale)
        let rec = self.bounds
        self.drawViewHierarchyInRect(rec, afterScreenUpdates: true)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    // It is same API as takescreen shot. But it will not lag the main thread.
    func captureView() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    // To give parellex effect on any view.
    func ch_addMotionEffect() {
        let axis_x_motion: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
        axis_x_motion.minimumRelativeValue = NSNumber(int: -10)
        axis_x_motion.maximumRelativeValue = NSNumber(int: 10)
        
        let axis_y_motion: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        axis_y_motion.minimumRelativeValue = NSNumber(int: -10)
        axis_y_motion.maximumRelativeValue = NSNumber(int: 10)
        
        let motionGroup : UIMotionEffectGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [axis_x_motion, axis_y_motion]
        self.addMotionEffect(motionGroup)
    }
}
