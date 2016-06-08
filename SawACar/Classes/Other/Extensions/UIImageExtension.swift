//
//  UIImageExtension.swift
//  manup
//
//  Created by Tom Swindell on 10/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore
import ImageIO

public extension UIImage {
    
    func mask(maskImage: UIImage) -> UIImage? {
        var maskedImage: UIImage? = nil
        
        let maskRef = maskImage.CGImage as CGImageRef!
        
        let mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
            CGImageGetHeight(maskRef),
            CGImageGetBitsPerComponent(maskRef),
            CGImageGetBitsPerPixel(maskRef),
            CGImageGetBytesPerRow(maskRef),
            CGImageGetDataProvider(maskRef), nil, false) as CGImageRef!
        
        let maskedImageRef = CGImageCreateWithMask(self.CGImage, mask)
        
        maskedImage = UIImage(CGImage: maskedImageRef!)
        
        return maskedImage
    }
    
    class func createImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func resize(size:CGSize)-> UIImage {
        
        let scale  = UIScreen.mainScreen().scale
        let newSize = CGSize(width: size.width  , height: size.height  )
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetInterpolationQuality(context, CGInterpolationQuality.High)
        self.drawInRect(CGRect(origin: CGPointZero, size: newSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
}

//MARK: Compressed image
extension UIImage {
    var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}
