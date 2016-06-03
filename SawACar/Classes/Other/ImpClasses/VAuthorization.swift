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
                    block(true)
                } else {
                    // Access has been denied.
                    block(false)
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
                    block(true)
                } else {
                    block(false)
                }
            }
            break
        }
        
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
}