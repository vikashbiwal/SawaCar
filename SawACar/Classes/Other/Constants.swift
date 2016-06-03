//
//  Constants.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 08/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit
import Foundation




let _screenSize             = UIScreen.mainScreen().bounds.size
let _googleKey              = "AIzaSyDHpxmF2p1xUhNeFFqarFWJnTH0PsJL2Ww" // Pravin
let _twitterUrl             = "https://api.twitter.com/1.1/account/verify_credentials.json"
let _twitterFriendsUrl      = "https://api.twitter.com/1.1/friends/list.json"
let _fbMeUrl                = "https://graph.facebook.com/me"
let _googleUrl              = "https://maps.googleapis.com/maps/api/place"
let _fbLoginReadPermissions = ["public_profile","email"]
let _fbUserInfoRequestParam = "email, first_name,  last_name, name, id, gender"
let _facebookAppId          = "1229887770358821"    // The App developer Account
// let _facebookAppId       = "148805282158820"  // John Smith Account

let _defaultCenter          = NSNotificationCenter.defaultCenter()
let _userDefault            = NSUserDefaults.standardUserDefaults()
let _appDelegator           = UIApplication.sharedApplication().delegate! as! AppDelegate
let _application            = UIApplication.sharedApplication()
let _heighRatio             = _screenSize.height/667
let _widthRatio             = _screenSize.width/375

//var _userAuth: UserAuth! = nil
var me: User! = nil

let _serverFormatter: NSDateFormatter = {
    let df = NSDateFormatter()
    df.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    return df
}()

let _serverFormatter2: NSDateFormatter = {
    let df = NSDateFormatter()
    // 2016-04-06T07:32:17Z
    // 2016-03-23T08:07:18.0577162Z
    //df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return df
}()

let _serverFormatter3: NSDateFormatter = {
    let df = NSDateFormatter()
    // 2016-04-06T07:32:17Z
    df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return df
}()

// MARK: Validation Message
// Sign Up validation
let kEmailValidateMsg           = "Please enter a valid email-id."
let kCountryValidateMsg         = "Please select your country."
let kNationalityValidateMsg     = "Please select your nationality."
let kBirthYearValidateMsg       = "Please enter your birth year."
let kGenderValidateMsg          = "Please select your gender."
let kPasswordConfirmMsg         = "Password does not match."
let kInvalidMobileNumber        = "Please enter a valid mobile number."
let kBirthYearRequired          = "Year of birth is required."
let kFirstnameIsRequired        = "First name is required."
let kLastnameIsRequired         = "Last name is required."
let kEmailIsRequired            = "Email is required."
let kPasswordIsRequired         = "Password is required."
let kMobileNumberIsRequired     = "Mobile number is required."
//MARK: Error Messages 
let kServerError                = "Server Error"

// MARK: Notification Key

// MARK: Important Enums
enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case Phone
    case Pad
}

// MARK: Global Functions
// Comment in release mode
func jprint(items: Any...) {
    for item in items {
        print(item)
    }
}




