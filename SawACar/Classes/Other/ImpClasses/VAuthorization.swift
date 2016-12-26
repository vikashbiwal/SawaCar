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
    class func checkAuthorizationStatusForPhotoLibarary(_ block: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus();
        
        if status == PHAuthorizationStatus.authorized {
            // Access has been granted.
            block(true)
        } else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            block(false)
        } else if (status == PHAuthorizationStatus.notDetermined) {
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    // Access has been granted.
                    DispatchQueue.main.async(execute: {
                        block(true)
                    })

                } else {
                    // Access has been denied.
                    DispatchQueue.main.async(execute: {
                        block(false)
                    })
                }
            })
        } else if status == .restricted {
            // Restricted access - normally won't happen.
            block(false)
        }
    }
    
    class func checkAuthorizationStatusForCamera(_ block: @escaping (Bool) -> Void) {
        let cameraMediaType = AVMediaTypeVideo
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: cameraMediaType)
        
        switch cameraAuthorizationStatus {
            
        // The client is authorized to access the hardware supporting a media type.
        case .authorized:
            block(true)
            break
            
            // The client is not authorized to access the hardware for the media type. The user cannot change
        // the client's status, possibly due to active restrictions such as parental controls being in place.
        case .restricted:
            block(false)
            break
            
        // The user explicitly denied access to the hardware supporting a media type for the client.
        case .denied:
            block(false)
            break
            
        // Indicates that the user has not yet made a choice regarding whether the client can access the hardware.
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(forMediaType: cameraMediaType) { granted in
                if granted {
                    DispatchQueue.main.async(execute: {
                        block(true)
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        block(false)
                    })
                }
            }
            break
        }
        
    }
    
    class func showCameraAccessDeniedAlert(_ inVC : UIViewController) {
        let alert = UIAlertController(title: nil, message: "SawACar does not have access to your camera. To enable access go to: device's Settings > Privacy > Camera.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let SettingAction = UIAlertAction(title: "Settings", style: .destructive, handler: { (action) in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        alert.addAction(cancelAction)
        alert.addAction(SettingAction)
        inVC.present(alert, animated: true, completion: nil)
    }
    
    class func showPhotosAccessDeniedAlert(_ inVC : UIViewController) {
        let alert = UIAlertController(title: nil, message: "SawACar does not have access to your photos or videos. To enable access go to: device's Settings > Privacy > Photos.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let SettingAction = UIAlertAction(title: "Settings", style: .destructive, handler: { (action) in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        alert.addAction(cancelAction)
        alert.addAction(SettingAction)
        inVC.present(alert, animated: true, completion: nil)
    }

}

//MARK: Authorization Status for Contacts
extension VAuthorization {
    class func checkAuthorizationStatusForConatacts(_ block: @escaping (Bool) -> Void) {
        let status = ABAddressBookGetAuthorizationStatus()
        switch status {
        case .authorized:
            block(true)
            break
        case .restricted:
            block(false)
            break
        case .denied:
            block(false)
            break
        case .notDetermined:
//            ABAddressBookRequestAccessWithCompletion(nil) { (granted:Bool, err:CFError!) in
//                DispatchQueue.main.async {
//                    if granted {
//                        // Access has been granted.
//                        block(true)
//                    } else {
//                        // Access has been denied.
//                        block(false)
//                    }
//                }
//            }
            break
        }
    }
    
    class func showContactsAccessDeniedAlert(_ inVC : UIViewController) {
        let alert = UIAlertController(title: nil, message: "SawACar does not have access to your contacts. To enable access go to: device's Settings > Privacy > Contacts.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let SettingAction = UIAlertAction(title: "Settings", style: .destructive, handler: { (action) in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        alert.addAction(cancelAction)
        alert.addAction(SettingAction)
        inVC.present(alert, animated: true, completion: nil)
    }
    

}
