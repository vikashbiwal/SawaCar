//
//  DocumentAccess.swift
//  TheVinciCode
//
//  Created by Yudiz Solutions Pvt. Ltd. on 31/12/15.
//  Copyright © 2015 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class DocumentAccess: NSObject {
    
    // MARK: Variable
    static var obj: DocumentAccess {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: DocumentAccess? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = DocumentAccess()
        }
        return Static.instance!
    }
    
    private var fileManager: NSFileManager {
        return NSFileManager.defaultManager()
    }
    
    private lazy var media: NSString = {
        return self.cachePath("media")!
    }()
    
    private lazy var temporaryMedia: NSString = {
        return self.temporaryPath("temp_media")!
    }()
    
    // MARK: Paths For Directory
    private func cachePath(foldername: String) -> String? {
        var paths =  NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docDirectory = paths[0] as NSString
        let cPath = docDirectory.stringByAppendingPathComponent(foldername)
        if !fileManager.fileExistsAtPath(cPath) {
            do {
                try fileManager.createDirectoryAtPath(cPath, withIntermediateDirectories: true, attributes: nil)
                return cPath
            } catch  let error as NSError {
                jprint("Error in creating temporary path: \(error.localizedDescription)")
                return nil
            }
        }
        return cPath
    }
    
    private func temporaryPath(foldername: String) -> String? {
        let tempDirectory = NSTemporaryDirectory() as NSString
        let tPath = tempDirectory.stringByAppendingPathComponent(foldername)
        if !fileManager.fileExistsAtPath(tPath) {
            do {
                try fileManager.createDirectoryAtPath(tPath, withIntermediateDirectories: true, attributes: nil)
                return tPath
            } catch  let error as NSError {
                jprint("Error in creating temporary path: \(error.localizedDescription)")
                return nil
            }
        } else {
           return tPath
        }
    }
    
    private func documentPath(foldername: String) -> String? {
        var paths =  NSSearchPathForDirectoriesInDomains(.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let cacheDirectory = paths[0] as NSString
        let dPath = cacheDirectory.stringByAppendingPathComponent(foldername)
        if !fileManager.fileExistsAtPath(dPath) {
            do {
                try fileManager.createDirectoryAtPath(dPath, withIntermediateDirectories: true, attributes: nil)
                return dPath
            } catch  let error as NSError {
                jprint("Error in creating document path: \(error.localizedDescription)")
                return nil
            }
        } else {
            return dPath
        }
    }
    
    // MARK: Store Media To Cache
    func setMedia(medData: NSData, forName filename: String) -> Bool {
        let fullpath = media.stringByAppendingPathComponent(filename)
        return fileManager.createFileAtPath(fullpath, contents: medData, attributes: nil)
    }
    
    // This will check if media exist at path and return if true.
    func mediaForName(filename: String) -> NSURL? {
        let fullpath = media.stringByAppendingPathComponent(filename)
        if fileManager.fileExistsAtPath(fullpath) {
            return NSURL(fileURLWithPath: fullpath)
        } else {
            return nil
        }
    }
    
    // This will give media url with filename given.
    func mediaUrlForName(filename: String) -> NSURL {
        let path = media.stringByAppendingPathComponent(filename)
        return NSURL(fileURLWithPath: path)
    }
    
    subscript(filename: String) -> NSURL? {
        return mediaForName(filename)
    }
    
    func removeMediaForName(filename: String) -> Bool {
        let fullpath = media.stringByAppendingPathComponent(filename)
        do { try fileManager.removeItemAtPath(fullpath)
             return true
        } catch let error as NSError {
            jprint("Error in removing media: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: Store Image to Cache
    /* we will append _thumb next to its name that way we can store both thumb and full image */
    func imageForName(filename: String, isthumb: Bool) -> UIImage? {
        let fullpath = media.stringByAppendingPathComponent(filename + (isthumb ? "_thumb" : ""))
        return UIImage(contentsOfFile: fullpath)
    }
    
    func setImage(img: UIImage, isthumb: Bool, forName name: String) -> Bool {
        let fullpath = media.stringByAppendingPathComponent(name + (isthumb ? "_thumb" : ""))
        return fileManager.createFileAtPath(fullpath, contents: UIImageJPEGRepresentation(img, 1), attributes: nil)
    }
    
    // MARK : Randome Names
    func randomMediaName(exten: String? = nil) -> String {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyyMMddhhmmssSSSS"
        var strDate = dateFormat.stringFromDate(NSDate())
        if let extensn = exten {
            strDate.appendContentsOf(".\(extensn)")
        }
        return strDate
    }
    
}

