//
//  User.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 12/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

//MARK: User



class User  {
    var Id: String!
    var firstname: String!
    var lastname: String!
    var fullname: String!
    var birthYear: String!
    var gender: String!
    var bio: String!
    var photo: String!
    var email: String!
    var mobile: String!
    var mobileCountryCode: String!
    var nationalityId: String!
    var countryId: String!
    var language: String!
    var isMobileVerified: Bool!
    var isEmailVerified: Bool!
    var lastLoginTime: String!
    var createDate: String!
    var accountTypeId: String!
    var isTermsAccepted: Bool!
    var isMonitoringAccepted: Bool!
    var isTravelOrderReceiver: Bool!
    var rating = 0
    var preference: UserPreference!
    var social : UserSocial!
    
    var password: String = ""
    var confPass: String! = ""
    
    // create a fresh User without initlize data
    init() {
        Id = ""
        firstname = ""
        lastname = ""
        fullname = ""
        gender = ""
        birthYear = ""
        bio = ""
        email = ""
        mobile = ""
        mobileCountryCode = ""
        nationalityId = ""
        countryId = ""
        language = ""
        accountTypeId = ""
        lastLoginTime = ""
        createDate = ""
        
    }
    
    // inialize user from json got from server
    init(json: [String : AnyObject]) {
        let info = json["Object"] as! [String : AnyObject]
        Id = RConverter.string(info["UserID"])
        firstname = RConverter.string(info["FirstName"])
        lastname = RConverter.string(info["LastName"])
        fullname = RConverter.string(info["FullName"])
        gender = RConverter.boolean(info["Gender"]) ? "Male" : "Female"
        birthYear = RConverter.string(info["YearOfBirth"])
        bio = RConverter.string(info["Bio"])
        email = RConverter.string(info["Email"])
        mobile = RConverter.string(info["MobileNumber"])
        mobileCountryCode = RConverter.string(info["MobileCountryCode"])
        nationalityId = RConverter.string(info["NationalityID"])
        countryId = RConverter.string(info["CountryID"])
        language = RConverter.string(info["DefaultLanguage"])
        accountTypeId = RConverter.string(info["AccountTypeID"])
        lastLoginTime = RConverter.string(info["LastLoginDate"])
        createDate = RConverter.string(info["CreateDate"])
        
        isMobileVerified = RConverter.boolean(info["IsMobileVerified"])
        isEmailVerified = RConverter.boolean(info["IsEmailVerified"])
        isTermsAccepted = RConverter.boolean(info["IsTermsAccepted"])
        isMonitoringAccepted = RConverter.boolean(info["IsMonitoringAccepted"])
        isTravelOrderReceiver = RConverter.boolean(info["IsTravelOrderReceiver"])
        rating = RConverter.integer(info["Rating"])
        
        preference = UserPreference(info: info)
        social = UserSocial(info: info)
    }
    
}

//MARK: User Actions like - Login, Sign up, update profile
extension User {
    //MARK: SignUP
    func singUp(block: WSBlock) {
        wsCall.signUp(singUpParameters(), block: block)
    }
    
    func singUpParameters() -> [String : AnyObject] {
        let params = ["Email": email,
                      "FirstName": firstname,
                      "LastName": lastname,
                      "Password": password,
                      "Gender": gender == "Male" ? true : false,
                      "YearOfBirth": birthYear.integerValue!,
                      "NationalityID": nationalityId.integerValue!,
                      "CountryID": countryId.integerValue!,
                      "MobileCountryCode": mobileCountryCode.integerValue!,
                      "MobileNumber": mobile]
        return params as! [String : AnyObject]
    }
    
    //MARK: Login
    func login(block: WSBlock) {
        wsCall.login(loginParameters(), block: block)
    }
    
    func loginParameters() -> [String : String!] {
        let params = ["Email": email,
                      "Password": password]
        return params
    }
    
    
}

//MARK: Validation for user Registration, login, Edit user
extension User {
    //Signup validation
    func validatePersonalInfo() -> (isValid :Bool, message: String) {
        if firstname.isEmpty {
            return (false, kFirstnameIsRequired)
        }
        if lastname.isEmpty {
            return (false, kLastnameIsRequired)
        }
        
        if email.isEmpty {
            return (false, kEmailIsRequired)
        } else {
            if !email.isValidEmailAddress() {
                return (false, kEmailValidateMsg)
            }
        }
        
        if password.isEmpty {
            return (false, kPasswordConfirmMsg)
        }
        if password != confPass {
            return (false, kPasswordConfirmMsg)
        }
        
        return (true, "Success")
    }
    
    func validateGenderInfo() -> (isValid :Bool, message: String) {
        if gender.isEmpty {
            return (false, kGenderValidateMsg)
        }
        return (true, "Success")
    }
    
    func validateBirthInfo() -> (isValid :Bool, message: String) {
        if birthYear.isEmpty {
            return (false, kBirthYearRequired)
        }
        return (true, "Success")
    }
    func validateContactInfo() -> (isValid :Bool, message: String) {
        if mobile.isEmpty {
            return (false, kMobileNumberIsRequired)
        } else {
            if !mobile.isValidMobileNumber() {
            return (false, kInvalidMobileNumber)
            }
        }
        return (true, "Success")
    }
    
    func validateLocationInfo() -> (isValid :Bool, message: String) {
        if nationalityId.isEmpty {
            return (false, kNationalityValidateMsg)
        }
        if countryId.isEmpty {
            return (false, kCountryValidateMsg)
        }
        return (true, "Success")
        
    }
    //End signup validation
    
    //Login validation
    func validateLoginProcess() -> (isValid: Bool, msg: String) {
        if email.isEmpty {
            return (false, kEmailIsRequired)
        } else {
            if !email.isValidEmailAddress() {
                return (false, kEmailValidateMsg)
            }
        }
        
        if password.isEmpty {
            return (false, kPasswordIsRequired)
        }
        return (true, "Success")
    }


}

//Preferece object for User
struct UserPreference {
    var showEmail: Bool
    var showMobile: Bool
    var smoking: Bool
    var music: Bool
    var food: Bool
    var kids: Bool
    var pets: Bool
    var prayingStop: Bool
    var quran: Bool
    
    init(info: [String : AnyObject]) {
        showEmail = RConverter.boolean(info["PreferencesShowEmail"])
        showMobile = RConverter.boolean(info["PreferencesShowMobile"])
        smoking = RConverter.boolean(info["PreferencesSmoking"])
        music = RConverter.boolean(info["PreferencesMusic"])
        food = RConverter.boolean(info["PreferencesFood"])
        kids = RConverter.boolean(info["PreferencesKids"])
        pets = RConverter.boolean(info["PreferencesPets"])
        prayingStop = RConverter.boolean(info["PreferencesPrayingStop"])
        quran = RConverter.boolean(info["PreferencesQuran"])
    }
}

//Social connect object for user
struct UserSocial {
    var Whatsapp: String
    var Viber: String
    var Line: String
    var Tango: String
    var Telegram: String
    var Facebook: String
    var Twitter: String
    
    init(info: [String : AnyObject]) {
        Whatsapp = RConverter.string(info["Whatsapp"])
        Viber = RConverter.string(info["Viber"])
        Line = RConverter.string(info["Line"])
        Tango = RConverter.string(info["Tango"])
        Telegram = RConverter.string(info["Telegram"])
        Facebook = RConverter.string(info["Facebook"])
        Twitter = RConverter.string(info["Twitter"])
    }
}