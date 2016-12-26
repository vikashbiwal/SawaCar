//
//  StringExtension.swift
//  manup
//
//  Created by Tom Swindell on 07/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import Foundation

// MARK: - Registration Validation
extension String {
    
    func isValidUsername() -> Bool {
        let usernameRegex = "[A-Z0-9a-z_]{3,20}"
        let temp = NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: self)
        return temp
    }

    func isValidEmailAddress() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let temp = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
        return temp
    }
    
    func isValidMobileNumber() -> Bool {
        if self.characters.count > 14 || self.characters.count < 8 {
            return false
        }
        let newCharacters = CharacterSet(charactersIn: self)
        return CharacterSet.decimalDigits.isSuperset(of: newCharacters)
    }

}

// MARK: - Character check
extension String {
    
    func trimmedString() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func contains(_ find: String) -> Bool{
        return self.range(of: find, options: NSString.CompareOptions.caseInsensitive) != nil
    }
    
    func trimWhiteSpace(_ newline: Bool = false) -> String {
        if newline {
            return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        } else {
            return self.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
}

// MARK: - Conversion
extension String {
    
    var doubleValue: Double? {
        return Double(self)
    }
    var floatValue: Float? {
        return Float(self)
    }
    var integerValue: Int? {
        return Int(self)
    }
}

// MARK: - Layout
extension String {
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    
    func WidthWithNoConstrainedHeight(_ font: UIFont) -> CGFloat {
        let width = CGFloat(999)
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }
}

extension NSAttributedString {
    
    func heightWithConstrainedWidth(_ width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }
}

// MARK: - Attributed
extension NSAttributedString {
    
    // This will give combined string with respective attributes
    func attributedText(_ texts: [String], attributes: [[String : AnyObject]]) -> NSAttributedString {
        let attbStr = NSMutableAttributedString()
        for (index,element) in texts.enumerated() {
            attbStr.append(NSAttributedString(string: element, attributes: attributes[index]))
        }
        return attbStr
    }
}

