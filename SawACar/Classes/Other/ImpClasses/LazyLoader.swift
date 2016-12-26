//
//  LazyLoader.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 09/03/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit


class LazyLoader: NSObject {
    
    class func downloadImageFromUrl(_ url: URL, block: @escaping (UIImage?)->()) {
        
        if let img = DocumentAccess.obj.imageForName(url.lastPathComponent, isthumb: false) {
            block(img)
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { (response, data, error) -> Void in
            if let _ = error {
                block(nil)
            } else {
                if let img = UIImage(data: data!) {
                    DocumentAccess.obj.setImage(img, isthumb: false, forName: url.lastPathComponent)
                    block(img)
                } else {
                   block(nil)
                }
            }
        }
    }

}
