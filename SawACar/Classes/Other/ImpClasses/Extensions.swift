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
    
    func addClearIconWithImage(_ img: UIImage) {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn.setImage(img, for: UIControlState())
        btn.addTarget(self, action: #selector(UITextField.muClearTextField(_:)), for: .touchUpInside)
        self.rightViewMode = .whileEditing
        self.rightView = btn
    }
    
    func muClearTextField(_ sender: UITextField) {
        self.text = ""
    }
}

// To Attributed text
extension UITextField {
    
    func setAttributedPlaceholder(_ text: String, font: UIFont, color: UIColor) {
        let mutatingAttributedString = NSMutableAttributedString(string: text)
        mutatingAttributedString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, text.characters.count))
        mutatingAttributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, text.characters.count))
        attributedPlaceholder = mutatingAttributedString
    }
    
    // This will give combined string with respective attributes
    func setAttributedPlaceholder(_ texts: [String], attributes: [[String : AnyObject]]) {
        let attbStr = NSMutableAttributedString()
        for (index,element) in texts.enumerated() {
            attbStr.append(NSAttributedString(string: element, attributes: attributes[index]))
        }
        attributedPlaceholder = attbStr
    }
}

extension UILabel {
    
    func animateLabelAlpha( _ fromValue: NSNumber, toValue: NSNumber, duration: CFTimeInterval) {
        let titleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        titleAnimation.duration = duration
        titleAnimation.fromValue = fromValue
        titleAnimation.toValue = toValue
        titleAnimation.isRemovedOnCompletion = true
        layer.add(titleAnimation, forKey: "opacity")
    }
    
    func setAttributedText(_ text: String, font: UIFont, color: UIColor) {
        let mutatingAttributedString = NSMutableAttributedString(string: text)
        mutatingAttributedString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, text.characters.count))
        mutatingAttributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, text.characters.count))
        attributedText = mutatingAttributedString
    }
    
    // This will give combined string with respective attributes
    func setAttributedText(_ texts: [String], attributes: [[String : AnyObject]]) {
        let attbStr = NSMutableAttributedString()
        for (index,element) in texts.enumerated() {
            attbStr.append(NSAttributedString(string: element, attributes: attributes[index]))
        }
        attributedText = attbStr
    }
    
}

// To calculate text rect
extension UIFont {
    // Will return size to fit rect for given string.
    func sizeOfString(_ string: String, constrainedToWidth width: Double) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: width, height: DBL_MAX),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: [NSFontAttributeName: self],
            context: nil).size
    }
}

// MARK: - Alerts
// Inline Alert message pop up with controller
extension UIAlertController {
    class func actionWithMessage(_ message: String?, title: String?, type: UIAlertControllerStyle, buttons: [String], controller: UIViewController ,block:@escaping (_ tapped: String)->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: type)
        for btn in buttons {
            alert.addAction(UIAlertAction(title: btn, style: UIAlertActionStyle.default, handler: { (action) -> Void in
                block(btn)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
}

// Inline alert message popup
extension UIAlertView {
    
    class func show(_ title: String, message: String? = nil) {
        let alert: UIAlertView = UIAlertView()
        alert.title = title
        if let msg = message {
            alert.message = msg
        }
        alert.addButton(withTitle: "Dismiss")
        alert.show()
    }
}

// MARK: - Devices
// To identify devices and its Family
extension UIDevice {
    
    class func isiPhone4() -> Bool {
        return _screenSize.height == 480.0 && UIDevice.current.userInterfaceIdiom == .phone
    }
    class func isiPhone5() -> Bool {
        return _screenSize.height == 568.0 && UIDevice.current.userInterfaceIdiom == .phone
    }
    class func isiPhone6() -> Bool {
        return _screenSize.height == 667.0 && UIDevice.current.userInterfaceIdiom == .phone
    }
    class func isiPhone6plus() -> Bool {
        return _screenSize.height == 736.0 && UIDevice.current.userInterfaceIdiom == .phone
    }
    class func isiPad() -> Bool {
        return _screenSize.height == 1024 && UIDevice.current.userInterfaceIdiom == .pad
    }
    class func isiPadPro() -> Bool {
        return _screenSize.width == 1024 && UIDevice.current.userInterfaceIdiom == .pad
    }
    class func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    class func isPhone() -> Bool {
      return UIDevice.current.userInterfaceIdiom == .phone
    }
    class func isAtLeastiOSVersion(_ ver: String) -> Bool {
        return self.current.systemVersion.compare(ver, options: NSString.CompareOptions.numeric, range: nil, locale: nil) != ComparisonResult.orderedAscending
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
