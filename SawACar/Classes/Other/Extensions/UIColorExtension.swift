//
//  UIColor+Man Up.swift
//
//  Generated by Zeplin on 12/3/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func colorWithGray(gray: Int) -> UIColor {
        return UIColor(red: CGFloat(gray) / 255.0, green: CGFloat(gray) / 255.0, blue: CGFloat(gray) / 255.0, alpha: 1.0)
    }
    
    class func colorWithRGB(r r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    
    // MARK: Saw a car app's Screen header Color
    class func scHeaderColor() -> UIColor {
        return UIColor(red: 24.0 / 255.0, green: 120.0 / 255.0, blue: 166.0 / 255.0, alpha: 1.0)
    }
    
    class func scSliderSelectedMenuColor()-> UIColor {
        return UIColor(red: 55.0 / 255.0, green: 55.0 / 255.0, blue: 55.0 / 255.0, alpha: 1.0)
    }
    
    class func scSliderMenuColor()-> UIColor {
        return UIColor(red: 73.0 / 255.0, green: 73.0 / 255.0, blue: 73.0 / 255.0, alpha: 1.0)
    }
    class func scTravelCardColor()-> UIColor {
        return UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
    }

}
