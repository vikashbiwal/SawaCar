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
let _generalStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
let _driverStoryboard  = UIStoryboard(name: "SBDriver", bundle: NSBundle.mainBundle())
let _passangerStorybord = UIStoryboard(name: "SBPassanger", bundle: NSBundle.mainBundle())

//MARK: -   
let _screenSize             = UIScreen.mainScreen().bounds.size
let _googleKey              = "AIzaSyDHpxmF2p1xUhNeFFqarFWJnTH0PsJL2Ww" // Pravin
let _twitterUrl             = "https://api.twitter.com/1.1/account/verify_credentials.json"
let _twitterFriendsUrl      = "https://api.twitter.com/1.1/friends/list.json"
let _fbMeUrl                = "https://graph.facebook.com/me"
let _googleUrl              = "https://maps.googleapis.com/maps/api/place"
let _fbLoginReadPermissions = ["public_profile","email"]
let _fbUserInfoRequestParam = "email, first_name,  last_name, name, id, gender, picture.type(large)"
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

let dateFormator: NSDateFormatter = {let df = NSDateFormatter(); df.dateFormat = "dd/MM/yyyy"; return df;}()



// MARK: App Messages
// Sign Up validation
let kEmailIsRequired            = "Email is required."
let kEmailValidateMsg           = "Please enter a valid email address."
let kCountryValidateMsg         = "Please select your country."
let kNationalityValidateMsg     = "Please select your nationality."
let kBirthYearValidateMsg       = "Please enter your birth year."
let kGenderValidateMsg          = "Please select your gender."
let kPasswordConfirmMsg         = "Password does not match."
let kPasswordIsRequired         = "Password is required."
let kConfimPassRequired         = "Please Re-Enter your password."
let kOldPassRequired            = "Please enter your old password."
let kPasswordWeekMsg            = "Passwords must be at least 8 characters long."
let kBirthYearRequired          = "Year of birth is required."
let kFirstnameIsRequired        = "First name is required."
let kLastnameIsRequired         = "Last name is required."
let kMobileNumberIsRequired     = "Mobile number is required."
let kInvalidMobileNumber        = "Please enter a valid mobile number."

let kLogoutConfirmMsg           = "Are you sure you want to logout?"
let kChagneModeConfirmMsg       = "Are you sure you want to change your user mode?"
let kServerError                = "Server Error"
let kOldPassIsInvalid           = "Old password is invalid."
let kProfileUpdateSuccess       = "Your profile updated successfully."
let kSocialUpdatedSuccess       = "Your social link updated successfully."
let kPreferenceSettingSucess    = "Your user preference settings updated successfully."
// MARK: App Keys
let kLoggedInUserKey            = "LoggedInUserKey"
let UserModeKey                 = "UserModeKey"
let kProfileUpdateNotificationKey = "UserProfileUpdateNotificationKey"




// MARK: Important Enums
enum UIUserInterfaceIdiom : Int {
    case Unspecified
    case Phone
    case Pad
}

var shutterActioinBlock: (Void)-> Void = {_ in}

// MARK: Global Functions
// Comment in release mode
func jprint(items: Any...) {
    for item in items {
        print(item)
    }
}

//Store Any custom object to UserDefault with a key
func archiveObject(obj: AnyObject, key: String) {
    let archive = NSKeyedArchiver.archivedDataWithRootObject(obj)
    _userDefault.setObject(archive, forKey: key)
}

//Get a object from userDefault with key
func unArchiveObjectForKey(key: String) -> AnyObject? {
    if let data = _userDefault.objectForKey(key) as? NSData {
        let unarchiveObj = NSKeyedUnarchiver.unarchiveObjectWithData(data)
       return unarchiveObj
    }
    return nil
}

func convertTimeStampToLocalDate(timeStampString: String)-> NSDate? {
    if !timeStampString.isEmpty {
        let index = timeStampString.startIndex.advancedBy(10)
        let timeStamp = NSTimeInterval(Double(timeStampString.substringToIndex(index))!)
        let date = NSDate(timeIntervalSince1970: timeStamp)
        return date
    }
    return nil
}

//Convert timestamp string to date string
func convertTimeStampToLocalDateString(timeStampString: String)-> String {
    if !timeStampString.isEmpty {
        let index = timeStampString.startIndex.advancedBy(10)
        let timeStamp = NSTimeInterval(Double(timeStampString.substringToIndex(index))!)
        let date = NSDate(timeIntervalSince1970: timeStamp)
        return dateFormator.stringFromDate(date, format: "dd-MM-yyyy")
    }
    return ""
}
