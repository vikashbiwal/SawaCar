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
    lazy private var animationLayer : CALayer = {
        return CALayer()
    }()
    
    // MARK - Init
    init(image : UIImage) {
        let hieght: CGFloat = 50.0
        
        let centerX = (hieght/2) - (image.size.width/2)
        let centrerY = (hieght/2) - (image.size.height/2)
        let iframe : CGRect = CGRectMake(centerX, centrerY, image.size.width, image.size.height)

        let frame : CGRect = CGRectMake(0.0, 0.0, hieght, hieght)
        super.init(frame: frame)
        animationLayer.frame = iframe
        animationLayer.contents = image.CGImage
        animationLayer.masksToBounds = true
        self.layer.addSublayer(animationLayer)
        addRotation(forLayer: animationLayer)
        pause(layer: animationLayer)
        self.layer.cornerRadius = 5.0
        self.hidden = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Func
    func addRotation(forLayer layer : CALayer) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        rotation.duration = 1.0
        rotation.removedOnCompletion = false
        rotation.repeatCount = HUGE
        rotation.fillMode = kCAFillModeForwards
        rotation.fromValue = NSNumber(float: 0.0)
        rotation.toValue = NSNumber(float: 3.14 * 2.0)
        layer.addAnimation(rotation, forKey: "rotate")
    }
    
    private func pause(layer layer : CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        isAnimating = false
    }
    
    private func resume(layer layer : CALayer) {
        let pausedTime : CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        layer.beginTime = timeSincePause
        isAnimating = true
    }
    
    func startAnimating () {
        if isAnimating {
            return
        }
        if hidesWhenStopped {
            self.hidden = false
        }
        resume(layer: animationLayer)
    }
    
    func stopAnimating () {
        if hidesWhenStopped {
            self.hidden = true
        }
        pause(layer: animationLayer)
    }
}