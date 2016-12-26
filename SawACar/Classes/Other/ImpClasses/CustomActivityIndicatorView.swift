//
//  CustomSpinnerActivityView.swift
//  manup
//
//  Created by Tom Swindell on 08/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import UIKit
import QuartzCore

class CustomActivityIndicatorView: VBlurView {
    
    // MARK - Variables
    var isAnimating : Bool = false
    var hidesWhenStopped : Bool = true
    lazy fileprivate var animationLayer : CALayer = {
        return CALayer()
    }()
    
    // MARK - Init
    init(image : UIImage) {
        let hieght: CGFloat = 50.0
        
        let centerX = (hieght/2) - (image.size.width/2)
        let centrerY = (hieght/2) - (image.size.height/2)
        let iframe : CGRect = CGRect(x: centerX, y: centrerY, width: image.size.width, height: image.size.height)

        let frame : CGRect = CGRect(x: 0.0, y: 0.0, width: hieght, height: hieght)
        super.init(frame: frame)
        animationLayer.frame = iframe
        animationLayer.contents = image.cgImage
        animationLayer.masksToBounds = true
        self.layer.addSublayer(animationLayer)
        addRotation(forLayer: animationLayer)
        pause(layer: animationLayer)
        self.layer.cornerRadius = 5.0
        self.isHidden = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Func
    func addRotation(forLayer layer : CALayer) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        rotation.duration = 1.0
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = HUGE
        rotation.fillMode = kCAFillModeForwards
        rotation.fromValue = NSNumber(value: 0.0 as Float)
        rotation.toValue = NSNumber(value: 3.14 * 2.0 as Float)
        layer.add(rotation, forKey: "rotate")
    }
    
    fileprivate func pause(layer : CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        isAnimating = false
    }
    
    fileprivate func resume(layer : CALayer) {
        let pausedTime : CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        isAnimating = true
    }
    
    func startAnimating () {
        if isAnimating {
            return
        }
        if hidesWhenStopped {
            self.isHidden = false
        }
        resume(layer: animationLayer)
    }
    
    func stopAnimating () {
        if hidesWhenStopped {
            self.isHidden = true
        }
        pause(layer: animationLayer)
    }
}
