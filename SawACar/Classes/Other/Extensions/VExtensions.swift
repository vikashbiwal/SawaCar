//
//  VExtensions.swift
//  SawACar
//
//  Created by Vikash Kumar. on 17/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

//============================= Extensions ===================================
//MARK: Int
extension Int {
    func ToString() -> String {
        return "\(self)"
    }
}

extension Double {
    func ToString() -> String {
        return "\(self)"
    }
}

//MARK: UIView
extension UIView {
    //Draw a shadow
    func drawShadow() {
        self.layer.masksToBounds = true;
        self.layer.shadowOffset = CGSizeMake(3.0, 3.0);
        self.layer.shadowRadius = 3.0;
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowColor  = UIColor.blackColor().CGColor
    }
    
    func drawShadowWithCornerRadius() {
        
    }
}

//MARK: UIImage
extension UIImage {
    //MARK: Compressed image
    var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}

extension Array where Element: Equatable {
    mutating func removeElement(element: Element) {
        if let ind = self.indexOf(element) {
            removeAtIndex(ind)
        }
    }
}

//MARK: DateFormator
extension NSDateFormatter {
    func stringFromDate(date: NSDate, format: String) -> String {
        self.dateFormat = format
        return self.stringFromDate(date)
    }
    
    func stringFromDate(date: NSDate, style:NSDateFormatterStyle) -> String {
        self.dateStyle = style
        return self.stringFromDate(date)
    }
    
    func dateFromString(strDate: String, fomat: String) -> NSDate? {
        self.dateFormat = fomat
        return self.dateFromString(strDate)
    }
    
    func dateString(strDate: String, fromFomat: String, toFromat: String) -> String {
        self.dateFormat = fromFomat
        let date = dateFromString(strDate)
        if let date = date {
         self.dateFormat = toFromat
            return stringFromDate(date)
        }
        return ""
    }
    
    func dateString(strDate: String, fromFomat: String, style: NSDateFormatterStyle) -> String {
        self.dateFormat = fromFomat
        let date = dateFromString(strDate)
        if let date = date {
            self.dateStyle = style
            return stringFromDate(date)
        }
        return ""
    }

}

//MARK: NSDate
extension NSDate {
 //
    func dateByAddingYearOffset(offset: Int) -> NSDate? {
        let calendar  =     NSCalendar(identifier: NSCalendarIdentifierGregorian)
        let offsetComponent = NSDateComponents()
        offsetComponent.year = offset
        let date = calendar?.dateByAddingComponents(offsetComponent, toDate: self, options: NSCalendarOptions.WrapComponents)
        return date
    }
}

//MARK: TableView
extension UITableView {
    func addRefreshControl(target: UIViewController, selector: Selector) -> UIRefreshControl {
        let refControl = UIRefreshControl()
        refControl.addTarget(target, action: selector, forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(refControl)
        return refControl
    }
}


//============================= SubClasses ===================================
//Swift view resize as per device ratio
class VkUISwitch: UISwitch {
    override func awakeFromNib() {
        super.awakeFromNib()
        //
        let constantValue: CGFloat = 0.9 //Default Scale value which changed as per device base.
        let scale = constantValue * _widthRatio
        self.transform = CGAffineTransformMakeScale(scale, scale)
    }
}

// This view is used for Maintain TblHeaderview's height
class TblWidthHeaderView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        var frame = self.frame
        frame.size.height = frame.size.height * _widthRatio
        self.frame = frame
    }
}

//show a blur view
class VBlurView: ConstrainedView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(blurEffectView)
        self.sendSubviewToBack(blurEffectView)
    }
}

class IndexPathButton: JPWidthButton {
    var indexPath : NSIndexPath!
}

class IndexPathTextField: JPWidthTextField {
    var indexpath: NSIndexPath!
}

class CornerRadiusView: ConstrainedView {
    @IBInspectable var cornerRadius : CGFloat = 3.0
    @IBInspectable var topLeft      : Bool = true
    @IBInspectable var topRight     : Bool = true
    @IBInspectable var bottomLeft   : Bool = true
    @IBInspectable var bottomRight  : Bool = true
    @IBInspectable var blurEffect   : Bool = false
    
    var corners : UIRectCorner!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        corners = UIRectCorner()
        if topLeft {
            corners.insert(.TopLeft)
        }
        if topRight {
            corners.insert(.TopRight)
        }
        if bottomLeft {
            corners.insert(.BottomLeft)
        }
        
        if bottomRight {
            corners.insert(.BottomRight)
        }
        

        if corners.isEmpty {
            
        } else {
            
            if (topLeft && topRight && bottomLeft && bottomRight) {
                self.layer.cornerRadius = cornerRadius * _widthRatio
                self.clipsToBounds = true
                
            } else {
                var fr = self.bounds
                fr.size.width = fr.size.width * _widthRatio
                fr.size.height = fr.size.height * _widthRatio
                
                let path = UIBezierPath(roundedRect:fr, byRoundingCorners:corners, cornerRadii: CGSizeMake(cornerRadius, cornerRadius))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.CGPath
                self.layer.mask = maskLayer
            }

        }
        
        if blurEffect {
            self.backgroundColor = UIColor.clearColor()
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            self.addSubview(blurEffectView)
            self.sendSubviewToBack(blurEffectView)

        }
    }
}


//============================= Enums ===================================
enum VAction {
    case Cancel, Done, Share
}

//============================= Functions ===================================

func getCurrencyForCountry(countryCode: String)-> String? {
    let components = [NSLocaleCountryCode : countryCode]
    let localeIdent = NSLocale.localeIdentifierFromComponents(components)
    let locale = NSLocale(localeIdentifier: localeIdent)
    let currencyCode = locale.objectForKey(NSLocaleCurrencyCode) as? String
    return currencyCode
}


