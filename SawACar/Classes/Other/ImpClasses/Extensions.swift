//
//  Extensions.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 29/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit

// MARK: - Text Display
// Will add custome clear icon to text field
extension UITextField {
    
    func addClearIconWithImage(img: UIImage) {
        let btn = UIButton(type: .Custom)
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn.setImage(img, forState: .Normal)
        btn.addTarget(self, action: #selector(UITextField.muClearTextField(_:)), forControlEvents: .TouchUpInside)
        self.rightViewMode = .WhileEditing
        self.rightView = btn
    }
    
    func muClearTextField(sender: UITextField) {
        self.text = ""
    }
}

// To Attributed text
extension UITextField {
    
    func setAttributedPlaceholder(text: String, font: UIFont, color: UIColor) {
        let mutatingAttributedString = NSMutableAttributedString(string: text)
        mutatingAttributedString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, text.characters.count))
        mutatingAttributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, text.characters.count))
        attributedPlaceholder = mutatingAttributedString
    }
    
    // This will give combined string with respective attributes
    func setAttributedPlaceholder(texts: [String], attributes: [[String : AnyObject]]) {
        let attbStr = NSMutableAttributedString()
        for (index,element) in texts.enumerate() {
            attbStr.appendAttributedString(NSAttributedString(string: element, attributes: attributes[index]))
        }
        attributedPlaceholder = attbStr
    }
}

extension UILabel {
    
    func animateLabelAlpha( fromValue: NSNumber, toValue: NSNumber, duration: CFTimeInterval) {
        let titleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        titleAnimation.duration = duration
        titleAnimation.fromValue = fromValue
        titleAnimation.toValue = toValue
        titleAnimation.removedOnCompletion = true
        layer.addAnimation(titleAnimation, forKey: "opacity")
    }
    
    func setAttributedText(text: String, font: UIFont, color: UIColor) {
        let mutatingAttributedString = NSMutableAttributedString(string: text)
        mutatingAttributedString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, text.characters.count))
        mutatingAttributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, text.characters.count))
        attributedText = mutatingAttributedString
    }
    
    // This will give combined string with respective attributes
    func setAttributedText(texts: [String], attributes: [[String : AnyObject]]) {
        let attbStr = NSMutableAttributedString()
        for (index,element) in texts.enumerate() {
            attbStr.appendAttributedString(NSAttributedString(string: element, attributes: attributes[index]))
        }
        attributedText = attbStr
    }
    
}

// To calculate text rect
extension UIFont {
    // Will return size to fit rect for given string.
    func sizeOfString(string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRectWithSize(CGSize(width: width, height: DBL_MAX),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: self],
            context: nil).size
    }
}

// MARK: - Alerts
// Inline Alert message pop up with controller
extension UIAlertController {
    class func actionWithMessage(message: String?, title: String?, type: UIAlertControllerStyle, buttons: [String], controller: UIViewController ,block:(tapped: String)->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: type)
        for btn in buttons {
            alert.addAction(UIAlertAction(title: btn, style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                block(tapped: btn)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        controller.presentViewController(alert, animated: true, completion: nil)
    }
}

// Inline alert message popup
extension UIAlertView {
    
    class func show(title: String, message: String? = nil) {
        let alert: UIAlertView = UIAlertView()
        alert.title = title
        if let msg = message {
            alert.message = msg
        }
        alert.addButtonWithTitle("Dismiss")
        alert.show()
    }
}

// MARK: - Devices
// To identify devices and its Family
extension UIDevice {
    
    class func isiPhone4() -> Bool {
        return _screenSize.height == 480.0 && UIDevice.currentDevice().userInterfaceIdiom == .Phone
    }
    class func isiPhone5() -> Bool {
        return _screenSize.height == 568.0 && UIDevice.currentDevice().userInterfaceIdiom == .Phone
    }
    class func isiPhone6() -> Bool {
        return _screenSize.height == 667.0 && UIDevice.currentDevice().userInterfaceIdiom == .Phone
    }
    class func isiPhone6plus() -> Bool {
        return _screenSize.height == 736.0 && UIDevice.currentDevice().userInterfaceIdiom == .Phone
    }
    class func isiPad() -> Bool {
        return _screenSize.height == 1024 && UIDevice.currentDevice().userInterfaceIdiom == .Pad
    }
    class func isiPadPro() -> Bool {
        return _screenSize.width == 1024 && UIDevice.currentDevice().userInterfaceIdiom == .Pad
    }
    class func isPad() -> Bool {
        return UIDevice.currentDevice().userInterfaceIdiom == .Pad
    }
    class func isPhone() -> Bool {
      return UIDevice.currentDevice().userInterfaceIdiom == .Phone
    }
    class func isAtLeastiOSVersion(ver: String) -> Bool {
        return self.currentDevice().systemVersion.compare(ver, options: NSStringCompareOptions.NumericSearch, range: nil, locale: nil) != NSComparisonResult.OrderedAscending
    }
    
    // This method will let user to configure and pass block of code for every size devices. 
    class func configureFor(i6p b1:()->(), i6 b2:()->(), i5 b3:()->(), i4 b4:()->()) {
        if self.isiPhone6plus() {
            b1()
        } else if self.isiPhone6() {
            b2()
        } else if self.isiPhone5() {
            b3()
        } else if self.isiPhone4() {
            b4()
        }
    }
    
    
    
}
