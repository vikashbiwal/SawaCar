//
//  DocumentAccess.swift
//  TheVinciCode
//
//  Created by Yudiz Solutions Pvt. Ltd. on 31/12/15.
//  Copyright © 2015 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class DocumentAccess: NSObject {
    
     static let obj = DocumentAccess()
    
    // MARK: Variable
    
    fileprivate var fileManager: FileManager {
        return FileManager.default
    }
    
    fileprivate lazy var media: NSString = {
        return self.cachePath("media")!
    }() as NSString
    
    fileprivate lazy var temporaryMedia: NSString = {
        return self.temporaryPath("temp_media")!
    }() as NSString
    
    // MARK: Paths For Directory
    fileprivate func cachePath(_ foldername: String) -> String? {
        var paths =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docDirectory = paths[0] as NSString
        let cPath = docDirectory.appendingPathComponent(foldername)
        if !fileManager.fileExists(atPath: cPath) {
            do {
                try fileManager.createDirectory(atPath: cPath, withIntermediateDirectories: true, attributes: nil)
                return cPath
            } catch  let error as NSError {
                jprint("Error in creating temporary path: \(error.localizedDescription)")
                return nil
            }
        }
        return cPath
    }
    
    fileprivate func temporaryPath(_ foldername: String) -> String? {
        let tempDirectory = NSTemporaryDirectory() as NSString
        let tPath = tempDirectory.appendingPathComponent(foldername)
        if !fileManager.fileExists(atPath: tPath) {
            do {
                try fileManager.createDirectory(atPath: tPath, withIntermediateDirectories: true, attributes: nil)
                return tPath
            } catch  let error as NSError {
                jprint("Error in creating temporary path: \(error.localizedDescription)")
                return nil
            }
        } else {
           return tPath
        }
    }
    
    fileprivate func documentPath(_ foldername: String) -> String? {
        var paths =  NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cacheDirectory = paths[0] as NSString
        let dPath = cacheDirectory.appendingPathComponent(foldername)
        if !fileManager.fileExists(atPath: dPath) {
            do {
                try fileManager.createDirectory(atPath: dPath, withIntermediateDirectories: true, attributes: nil)
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
    func setMedia(_ medData: Data, forName filename: String) -> Bool {
        let fullpath = media.appendingPathComponent(filename)
        return fileManager.createFile(atPath: fullpath, contents: medData, attributes: nil)
    }
    
    // This will check if media exist at path and return if true.
    func mediaForName(_ filename: String) -> URL? {
        let fullpath = media.appendingPathComponent(filename)
        if fileManager.fileExists(atPath: fullpath) {
            return URL(fileURLWithPath: fullpath)
        } else {
            return nil
        }
    }
    
    // This will give media url with filename given.
    func mediaUrlForName(_ filename: String) -> URL {
        let path = media.appendingPathComponent(filename)
        return URL(fileURLWithPath: path)
    }
    
    subscript(filename: String) -> URL? {
        return mediaForName(filename)
    }
    
    func removeMediaForName(_ filename: String) -> Bool {
        let fullpath = media.appendingPathComponent(filename)
        do { try fileManager.removeItem(atPath: fullpath)
             return true
        } catch let error as NSError {
            jprint("Error in removing media: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: Store Image to Cache
    /* we will append _thumb next to its name that way we can store both thumb and full image */
    func imageForName(_ filename: String, isthumb: Bool) -> UIImage? {
        let fullpath = media.appendingPathComponent(filename + (isthumb ? "_thumb" : ""))
        return UIImage(contentsOfFile: fullpath)
    }
    
    func setImage(_ img: UIImage, isthumb: Bool, forName name: String) -> Bool {
        let fullpath = media.appendingPathComponent(name + (isthumb ? "_thumb" : ""))
        return fileManager.createFile(atPath: fullpath, contents: UIImageJPEGRepresentation(img, 1), attributes: nil)
    }
    
    // MARK : Randome Names
    func randomMediaName(_ exten: String? = nil) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyyMMddhhmmssSSSS"
        var strDate = dateFormat.string(from: Date())
        if let extensn = exten {
            strDate.append(".\(extensn)")
        }
        return strDate
    }
    
}

