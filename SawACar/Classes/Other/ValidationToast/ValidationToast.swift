//
//  ValidationToast.swift
//  manup
//
//  Created by Tom Swindell on 07/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import UIKit

class ValidationToast: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var animatingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var animatingView: UIView!
    
    // MARK: - Initialisers
    class func instanceWithMessageFromNib(message: String, inView view: UIView, withColor color: UIColor, automaticallyAnimateIn shouldAnimate: Bool) -> ValidationToast {
        let toast = UINib(nibName: "ValidationToast", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ValidationToast
        toast.animatingViewBottomConstraint.constant = 20
        toast.layoutIfNeeded()
        toast.setToastMessage(message)
        toast.animatingView.backgroundColor = color
        view.addSubview(toast)
        var f = view.frame
        f.size.height = 20
        f.origin = CGPoint.zero
        toast.frame = f
        if shouldAnimate {
            toast.animateIn(0.2, delay: 0.0, completion: { () -> () in
                toast.animateOut(0.2, delay: 1.5, completion: { () -> () in
                    toast.removeFromSuperview()
                })
            })
        }
        return toast
    }
    
    // This will show alert message on status bar.
    class func showStatusMessage(message: String, inView view: UIView? = nil, withColor color: UIColor = UIColor.redColor()) -> ValidationToast {
        let toast = UINib(nibName: "ValidationToast", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ValidationToast
        toast.animatingViewBottomConstraint.constant = 20
        toast.layoutIfNeeded()
        toast.setToastMessage(message)
        toast.animatingView.backgroundColor = color
        var f = CGRectZero
        if let vw = view {
            vw.window!.addSubview(toast)
            f = vw.frame
        } else {
            _appDelegator.window?.addSubview(toast)
            f = UIScreen.mainScreen().bounds
        }
        f.size.height = 20
        f.origin = CGPoint.zero
        toast.frame = f
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
        toast.animateIn(0.2, delay: 0.2, completion: { () -> () in
            toast.animateOut(0.2, delay: 1.5, completion: { () -> () in
                UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
                toast.removeFromSuperview()
            })
        })
        return toast
    }
    
    class func showBarMessage(message: String, title: String, inView view: UIView?, withColor color: UIColor = UIColor.whiteColor()) -> ValidationToast {
        let toast = UINib(nibName: "ValidationToastBar", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ValidationToast
        toast.animatingViewBottomConstraint.constant = 44
        toast.layoutIfNeeded()
        toast.setToastMessage(message)
        toast.setToastTitle(title)
        toast.animatingView.backgroundColor = color
        var f = CGRectZero
        if let vw = view {
            vw.window!.addSubview(toast)
            f = vw.frame
        } else {
            _appDelegator.window?.addSubview(toast)
            f = UIScreen.mainScreen().bounds
        }
//        var f = view.frame
        f.size.height = 64
        f.origin = CGPoint.zero
        toast.frame = f
        toast.animateIn(0.2, delay: 0.2, completion: { () -> () in
            toast.animateOut(0.2, delay: 2.0, completion: { () -> () in
                toast.removeFromSuperview()
            })
        })
        return toast
    }
    
    // MARK: - Toast Functions
    private func setToastMessage(message: String) {
        let font = UIFont(name: "Avenir-Book", size: 14.0)!
        let color = UIColor.redColor()
        let mutableString = NSMutableAttributedString(string: message)
        let range = NSMakeRange(0, message.characters.count)
        mutableString.addAttribute(NSFontAttributeName, value: font, range: range)
        mutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        messageLabel.attributedText = mutableString
    }
    
    private func setToastTitle(message: String) {
        let font = UIFont(name: "Avenir-Book", size: 15.0)!
        let color = UIColor.redColor()
        let mutableString = NSMutableAttributedString(string: message)
        let range = NSMakeRange(0, message.characters.count)
        mutableString.addAttribute(NSFontAttributeName, value: font, range: range)
        mutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        titleLabel.attributedText = mutableString
    }
    
    func animateIn(duration: NSTimeInterval, delay: NSTimeInterval, completion: (() -> ())?) {
        animatingViewBottomConstraint.constant = 0
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.layoutIfNeeded()
            }) { (completed) -> Void in
                completion?()
        }
    }
    
    func animateOut(duration: NSTimeInterval, delay: NSTimeInterval, completion: (() -> ())?) {
        animatingViewBottomConstraint.constant = 44
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.layoutIfNeeded()
            }) { (completed) -> Void in
                completion?()
        }
    }
    
}

func showToastMessage(title: String, message: String) {
    ValidationToast.showBarMessage(message, title: title, inView: nil)
}

