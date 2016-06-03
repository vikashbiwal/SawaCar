//
//  LazyLoader.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 09/03/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit


class LazyLoader: NSObject {
    
    class func downloadImageFromUrl(url: NSURL, block: (UIImage?)->()) {
        
        if let img = DocumentAccess.obj.imageForName(url.lastPathComponent!, isthumb: false) {
            block(img)
            return
        }
        
        let request = NSMutableURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let _ = error {
                block(nil)
            } else {
                if let img = UIImage(data: data!) {
                    DocumentAccess.obj.setImage(img, isthumb: false, forName: url.lastPathComponent!)
                    block(img)
                } else {
                   block(nil)
                }
            }
        }
    }

}
