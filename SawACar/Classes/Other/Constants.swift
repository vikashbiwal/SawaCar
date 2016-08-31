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
var _deviceToken             = "1s1f4sd2s5df1s5df4" //Update device token from APNS

//var _userAuth: UserAuth! = nil
var me: User! = nil

let dateFormator: NSDateFormatter = {let df = NSDateFormatter(); df.dateFormat = "dd/MM/yyyy"; return df;}()


// MARK: App Keys
let kLoggedInUserKey            = "LoggedInUserKey"
let UserModeKey                 = "UserModeKey"
let kProfileUpdateNotificationKey = "UserProfileUpdateNotificationKey"
let kTravelAddedNotificationKey = "kTravelAddedNotification"



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
