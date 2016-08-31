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

class IndexPathButton: JPWidthButton {
    var indexPath : NSIndexPath!
}

class IndexPathTextField: JPWidthTextField {
    var indexpath: NSIndexPath!
}


//============================= Enums ===================================
enum VAction {
    case Cancel, Done
}

