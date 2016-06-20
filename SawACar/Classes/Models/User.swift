//
//  User.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 12/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

//MARK: Enum for Mode of user in Application
enum UserMode: Int {
    case Driver, Passenger
}

//MARK: User
class User : NSCoder {
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
    var isMobileVerified: Bool   = false
    var isEmailVerified: Bool    = false
    var isFacebookVerified: Bool = false
    var lastLoginTime: String!
    var createDate: String!
    var accountTypeId: String!
    var isTermsAccepted: Bool!
    var rating = 0
    var preference: UserPreference!
    var social : UserSocial!
    
    var password: String! = ""
    var confPass: String! = ""
    var oldPassword: String! = ""
    var userMode: UserMode = .Passenger //Default mode.
    
    var EmailVerifiedString: String { get {return self.isEmailVerified ? "Verified" : "Not Verified"}}
    var MobileVerifiedString: String {get {return self.isMobileVerified ? "Verified" : "Not Verified"}}
    var FacebookVeriedString: String {get {return self.isFacebookVerified ? "Verified" : "Not Verified"}}
    
    //Default initialize
    override init() {
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
        social = UserSocial()
        preference = UserPreference()
    }
    
    // inialize user from json got from server
    init(info: [String : AnyObject]) {
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
        createDate = convertTimeStampToLocalDateString(RConverter.string(info["CreateDate"]))
        photo      =  kWSDomainURL + RConverter.string(info["Photo"])
        isMobileVerified = RConverter.boolean(info["IsMobileVerified"])
        isEmailVerified = RConverter.boolean(info["IsEmailVerified"])
        isTermsAccepted = RConverter.boolean(info["IsTermsAccepted"])
        isFacebookVerified = RConverter.boolean(info["IsFacebookVerified"])
        rating = RConverter.integer(info["Rating"])
        
        preference = UserPreference(info: info)
        social = UserSocial(info: info)
    }
    
    
    
    //MARK: User placeholder image
    lazy var placeholderImage: UIImage = {
        if me.gender == "Male" {
            return UIImage(named: "ic_male_Placeholder")!
        } else {
            return UIImage(named: "ic_female")!
        }
    }()
}

//MARK: User WS Actions like - Login, Sign up, update profile
extension User {
    //MARK: SignUP
    func singUp(block: WSBlock) {
        wsCall.signUp(singUpParameters(), block: block)
    }
    
    //MARK: Login
    func login(block: WSBlock) {
        wsCall.login(loginParameters(), block: block)
    }
    
    //MARK: user update Profile information
    func updateProfileInfo(block: WSBlock) {
        wsCall.updateUserInformation(updateProfileInfoParams(), block: block)
    }
    
    //MARK: user update Social information
    func updateSocialInfo(block: WSBlock) {
        wsCall.updateSocialInfo(updateSocialInfoParams(), block: block)
    }
    
    //MARK: user update User Preference
    func updateUserPreference(block: WSBlock) {
        wsCall.updateUserPreference(updateUserPreferenceParams(), block: block)
    }


    //MARK: updateProfile image of user
    func updateProfileImage(imgData: NSData, block: ((String?)-> Void)?)  {
        wsCall.updateUserProfileImage(imgData, userid: self.Id) { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    let imgPath = json["Object"] as! String
                    self.photo = kWSDomainURL + imgPath
                    block?(imgPath)
                } else {
                    block?(nil)
                }
            } else {
                block?(nil)
            }
        }
    }
    
    //MARK: WS Prameters
    //SignUp Params
    func singUpParameters() -> [String : AnyObject] {
        let params = ["Email": email,
                      "FirstName": firstname,
                      "LastName": lastname,
                      "Password": password,
                      "Gender": gender == "Male" ? true : false,
                      "YearOfBirth": birthYear,
                      "NationalityID": nationalityId,
                      "CountryID": countryId,
                      "MobileCountryCode": mobileCountryCode,
                      "MobileNumber": mobile]
        return params as! [String : AnyObject]
    }
    
    //Login Params
    func loginParameters() -> [String : String!] {
        let params = ["Email": email,
                      "Password": password]
        return params
    }
    
    //UpdateProfile Params
    func updateProfileInfoParams() -> [String : AnyObject] {
        let params = ["UserID":Id,
                      "FirstName": firstname,
                      "LastName": lastname,
                      "Gender": gender == "Male" ? true : false,
                      "YearOfBirth": birthYear,
                      "NationalityID": nationalityId,
                      "CountryID": countryId,
                      "MobileCountryCode": mobileCountryCode,
                      "MobileNumber": mobile,
                      "Bio": bio,
                      "AccountTypeID": accountTypeId]
        return params as! [String : AnyObject]
    }
    
    //Update Social Links Pramas
    func updateSocialInfoParams()-> [String : AnyObject] {
         let params = ["UserID":Id,
                       "Whatsapp":social.Whatsapp,
                       "Viber": social.Viber,
                       "Line": social.Line,
                       "Tango": social.Tango,
                       "Telegram": social.Telegram,
                       "Facebook": social.Facebook,
                       "Twitter": social.Twitter,
                       "Snapchat": social.Snapchat,
                       "Instagram": social.Instagram]
        return params
    }
    
    //Update user preference params
    func updateUserPreferenceParams() -> [String : AnyObject] {
        let params = ["UserID":Id,
                      "IsMobilelShown": preference.showMobile,
                      "IsEmailShown": preference.showEmail,
                      "IsMonitoringAccepted": preference.acceptMonitring,
                      "IsTravelRequestReceiver": preference.IsTravelRequestReceiver,
                      "IsVisibleInSearch": preference.visibleInSearch,
                      "PreferencesSmoking": preference.smoking,
                      "PreferencesMusic": preference.music,
                      "PreferencesFood": preference.food,
                      "PreferencesKids": preference.kids,
                      "PreferencesPets": preference.pets,
                      "PreferencesPrayingStop": preference.prayingStop,
                      "PreferencesQuran": preference.quran,
                      "DefaultLanguage": preference.communicationLanguage,
                      "SpokenLanguages": preference.speackingLanguage]
        return params as! [String : AnyObject]
    }
}

//MARK: Validation for user Registration, login, Edit user
extension User {
    //MARK: Signup validation
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
            return (false, kPasswordIsRequired)
        } else {
            if password.characters.count < 8 {
                return (false, kPasswordWeekMsg)
            }
        }
        if confPass.isEmpty {
            return (false, kConfimPassRequired)
        } else {
            if password != confPass {
                return (false, kPasswordConfirmMsg)
            }
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
    
    //MARK: Login validation
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

    //MARK: Change Password Validation
    func validateChangePassProcess() -> (isValid: Bool, msg: String) {
        if oldPassword.isEmpty {
            return (false, kOldPassRequired)
        }
        if password.isEmpty {
            return (false, kPasswordIsRequired)
        } else {
            if password.characters.count < 8 {
                return (false, kPasswordWeekMsg)
            }
        }
        if confPass.isEmpty {
            return (false, kConfimPassRequired)
        }
        if password != confPass {
            return (false, kPasswordConfirmMsg)
        }
        return (true, "Success")
    }

}


//MARK: UserPreference :Preferece object for User
struct UserPreference {
    var showEmail       = false
    var showMobile      = false
    var visibleInSearch = false
    var specialOrder    = false
    var acceptMonitring = false
    var smoking         = false
    var music           = false
    var food            = false
    var kids            = false
    var pets            = false
    var prayingStop     = false
    var quran           = false
    var IsTravelRequestReceiver = false
    
    var communicationLanguage = ""
    var speackingLanguage     = [String]()

    init() {
     //Default initializer
    }
    
    init(info: [String : AnyObject]) {
        showEmail       = RConverter.boolean(info["IsEmailShown"])
        showMobile      = RConverter.boolean(info["IsMobilelShown"])
        visibleInSearch = RConverter.boolean(info["IsVisibleInSearch"])
        acceptMonitring = RConverter.boolean(info["IsMonitoringAccepted"])
        //        specialOrder    = RConverter.boolean(info[""]) //not found key in usr info
        smoking     = RConverter.boolean(info["PreferencesSmoking"])
        music       = RConverter.boolean(info["PreferencesMusic"])
        food        = RConverter.boolean(info["PreferencesFood"])
        kids        = RConverter.boolean(info["PreferencesKids"])
        pets        = RConverter.boolean(info["PreferencesPets"])
        prayingStop = RConverter.boolean(info["PreferencesPrayingStop"])
        quran       = RConverter.boolean(info["PreferencesQuran"])
        
        communicationLanguage = RConverter.string(info["DefaultLanguage"])
        speackingLanguage    = ["English", "Germen"]// info["SpokenLanguages"] as! [String]
    }
}

//MARK:UserSocial: Social connect object for user
struct UserSocial {
    var Whatsapp:   String!
    var Viber:      String!
    var Line:       String!
    var Tango:      String!
    var Telegram:   String!
    var Facebook:   String!
    var Twitter:    String!
    var Snapchat:   String!
    var Instagram:  String!
    
    init() {
         Whatsapp    = ""
         Viber       = ""
         Line        = ""
         Tango       = ""
         Telegram    = ""
         Facebook    = ""
         Twitter     = ""
         Snapchat    = ""
         Instagram   = ""
    }
    
    init(info: [String : AnyObject]) {
        Whatsapp    = RConverter.string(info["Whatsapp"])
        Viber       = RConverter.string(info["Viber"])
        Line        = RConverter.string(info["Line"])
        Tango       = RConverter.string(info["Tango"])
        Telegram    = RConverter.string(info["Telegram"])
        Facebook    = RConverter.string(info["Facebook"])
        Twitter     = RConverter.string(info["Twitter"])
        Snapchat    = RConverter.string(info["Snapchat"])
        Instagram   = RConverter.string(info["Instagram"])
    }
}
