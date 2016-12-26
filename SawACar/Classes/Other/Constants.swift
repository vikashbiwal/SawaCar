//
//  Constants.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 08/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit
import Foundation


//MARK: Storyboard references
let _generalStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
let _driverStoryboard  = UIStoryboard(name: "SBDriver", bundle: Bundle.main)
let _passangerStorybord = UIStoryboard(name: "SBPassanger", bundle: Bundle.main)

//MARK: -   
let _screenSize             = UIScreen.main.bounds.size
let _googleKey              = "AIzaSyDHpxmF2p1xUhNeFFqarFWJnTH0PsJL2Ww" // Pravin
let _twitterUrl             = "https://api.twitter.com/1.1/account/verify_credentials.json"
let _twitterFriendsUrl      = "https://api.twitter.com/1.1/friends/list.json"
let _fbMeUrl                = "https://graph.facebook.com/me"
let _googleUrl              = "https://maps.googleapis.com/maps/api/place"
let _fbLoginReadPermissions = ["public_profile","email"]
let _fbUserInfoRequestParam = "email, first_name,  last_name, name, id, gender, picture.type(large)"

// let _facebookAppId       = "148805282158820"  // John Smith Account
let _googleMapKey           = "AIzaSyBppzyUG-u4Rm5cyBMJFe3PMPrO-5bybUs"  //Client's account

let _defaultCenter          = NotificationCenter.default
let _userDefault            = UserDefaults.standard
let _appDelegator           = UIApplication.shared.delegate! as! AppDelegate
let _application            = UIApplication.shared
let _heighRatio             = _screenSize.height/667
let _widthRatio             = _screenSize.width/375
var _FCMToken               = "" //Update device token from APNS

//var _userAuth: UserAuth! = nil
var me: LoggedInUser! = nil

let dateFormator: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "dd/MM/yyyy"
    return df
}()

let serverDateFormator: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "dd/MM/yyyy hh:mm:ss a"
    df.timeZone = TimeZone(identifier: "UTC")
    
    return df
}()

// MARK: App Keys
let kAuthorizationInfoKey       = "kAuthorizationInfoKey"
let kLoggedInUserKey            = "LoggedInUserKey"
let UserModeKey                 = "UserModeKey"
let kProfileUpdateNotificationKey = "UserProfileUpdateNotificationKey"
let kTravelAddedNotificationKey = "kTravelAddedNotification"

//MARK: Placeholder Images
let _userPlaceholderImage = UIImage(named: "ic_user_placeholder")
let _carPlaceholderImage  = UIImage(named: "carPlaceholder")


// MARK: Important Enums
enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone
    case pad
}

var shutterActioinBlock: (Void)-> Void = {_ in}

// MARK: Global Functions
// Comment in release mode
func jprint(_ items: Any...) {
    for item in items {
        print(item)
    }
}


func convertTimeStampToLocalDate(_ timeStampString: String)-> Date? {
    if !timeStampString.isEmpty {
        let index = timeStampString.characters.index(timeStampString.startIndex, offsetBy: 10)
        let timeStamp = TimeInterval(Double(timeStampString.substring(to: index))!)
        let date = Date(timeIntervalSince1970: timeStamp)
        return date
    }
    return nil
}

//Convert timestamp string to date string
func convertTimeStampToLocalDateString(_ timeStampString: String)-> String {
    if !timeStampString.isEmpty {
        let index = timeStampString.characters.index(timeStampString.startIndex, offsetBy: 10)
        let timeStamp = TimeInterval(Double(timeStampString.substring(to: index))!)
        let date = Date(timeIntervalSince1970: timeStamp)
        return dateFormator.stringFromDate(date, format: "dd-MM-yyyy")
    }
    return ""
}
