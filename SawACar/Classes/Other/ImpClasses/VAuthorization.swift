//
//  VAuthorization.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 03/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AddressBook

class VAuthorization {
    
}

//MARK: Camera and Photo Libarary Authorization Status
extension VAuthorization {
    class func checkAuthorizationStatusForPhotoLibarary(block: (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus();
        
        if status == PHAuthorizationStatus.Authorized {
            // Access has been granted.
            block(true)
        } else if (status == PHAuthorizationStatus.Denied) {
            // Access has been denied.
            block(false)
        } else if (status == PHAuthorizationStatus.NotDetermined) {
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .Authorized {
                    // Access has been granted.
                    dispatch_async(dispatch_get_main_queue(), {
                        block(true)
                    })

                } else {
                    // Access has been denied.
                    dispatch_async(dispatch_get_main_queue(), {
                        block(false)
                    })
                }
            })
        } else if status == .Restricted {
            // Restricted access - normally won't happen.
            block(false)
        }
    }
    
    class func checkAuthorizationStatusForCamera(block: (Bool) -> Void) {
        let cameraMediaType = AVMediaTypeVideo
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatusForMediaType(cameraMediaType)
        
        switch cameraAuthorizationStatus {
            
        // The client is authorized to access the hardware supporting a media type.
        case .Authorized:
            block(true)
            break
            
            // The client is not authorized to access the hardware for the media type. The user cannot change
        // the client's status, possibly due to active restrictions such as parental controls being in place.
        case .Restricted:
            block(false)
            break
            
        // The user explicitly denied access to the hardware supporting a media type for the client.
        case .Denied:
            block(false)
            break
            
        // Indicates that the user has not yet made a choice regarding whether the client can access the hardware.
        case .NotDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccessForMediaType(cameraMediaType) { granted in
                if granted {
                    dispatch_async(dispatch_get_main_queue(), {
                        block(true)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        block(false)
                    })
                }
            }
            break
        }
        
    }
    
    class func showCameraAccessDeniedAlert(inVC : UIViewController) {
        let alert = UIAlertController(title: nil, message: "SawACar does not have access to your camera. To enable access go to: device's Settings > Privacy > Camera.", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let SettingAction = UIAlertAction(title: "Settings", style: .Destructive, handler: { (action) in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        })
        alert.addAction(cancelAction)
        alert.addAction(SettingAction)
        inVC.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func showPhotosAccessDeniedAlert(inVC : UIViewController) {
        let alert = UIAlertController(title: nil, message: "SawACar does not have access to your photos or videos. To enable access go to: device's Settings > Privacy > Photos.", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let SettingAction = UIAlertAction(title: "Settings", style: .Destructive, handler: { (action) in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        })
        alert.addAction(cancelAction)
        alert.addAction(SettingAction)
        inVC.presentViewController(alert, animated: true, completion: nil)
    }

}

//MARK: Authorization Status for Contacts
extension VAuthorization {
    class func checkAuthorizationStatusForConatacts(block: (Bool) -> Void) {
        let status = ABAddressBookGetAuthorizationStatus()
        switch status {
        case .Authorized:
            block(true)
            break
        case .Restricted:
            block(false)
            break
        case .Denied:
            block(false)
            break
        case .NotDetermined:
            ABAddressBookRequestAccessWithCompletion(nil) { (granted:Bool, err:CFError!) in
                dispatch_async(dispatch_get_main_queue()) {
                    if granted {
                        // Access has been granted.
                        block(true)
                    } else {
                        // Access has been denied.
                        block(false)
                    }
                }
            }
            break
        }
    }
    
    class func showContactsAccessDeniedAlert(inVC : UIViewController) {
        let alert = UIAlertController(title: nil, message: "SawACar does not have access to your contacts. To enable access go to: device's Settings > Privacy > Contacts.", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let SettingAction = UIAlertAction(title: "Settings", style: .Destructive, handler: { (action) in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        })
        alert.addAction(cancelAction)
        alert.addAction(SettingAction)
        inVC.presentViewController(alert, animated: true, completion: nil)
    }
    

}