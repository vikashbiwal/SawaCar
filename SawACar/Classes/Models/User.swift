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
class User :NSObject,  NSCopying {
    var Id:         String!
    var firstname:  String!
    var lastname:   String!
    var fullname:   String!
    var birthDate:  String!
    var gender:     String!
    var bio:        String!
    var photo:      String!
    var email:      String!
    var mobile:     String!
    var mobileCountryCode: String!
    var language:   String!
    var isMobileVerified:   Bool = false
    var isEmailVerified:    Bool = false
    var isFacebookVerified: Bool = false
    var lastLoginTime:      String!
    var createDate:         String!
    var isTermsAccepted:    Bool!
    var rating = 0
    var numberOfTravels: Int = 0
    var numberOfContacts     = 0
    
    var preference:  UserPreference!
    var social :     UserSocial!
    var country:     Country!
    var nationality: Country!
    var accountType: AccountType!
    
    var password    : String! = ""
    var confPass    : String! = ""
    var oldPassword : String! = ""
    var userMode    : UserMode = .Passenger //Default mode.
    
    var EmailVerifiedString : String { get {return self.isEmailVerified ? "Verified" : "Not Verified"}}
    var MobileVerifiedString: String {get {return self.isMobileVerified ? "Verified" : "Not Verified"}}
    var FacebookVeriedString: String {get {return self.isFacebookVerified ? "Verified" : "Not Verified"}}
    
    //Default initialize
     override init() {
        Id                = ""
        firstname         = ""
        lastname          = ""
        fullname          = ""
        gender            = ""
        birthDate         = ""
        bio               = ""
        email             = ""
        mobile            = ""
        mobileCountryCode = ""
        language          = ""
        lastLoginTime     = ""
        createDate        = ""
        social            = UserSocial()
        preference        = UserPreference()
        country           = Country()
        nationality       = Country()
        accountType       = AccountType()
        
    }
    
    // inialize user from json got from server
    init(info: [String : AnyObject]) {
        Id                = RConverter.string(info["UserID"])
        firstname         = RConverter.string(info["FirstName"])
        lastname          = RConverter.string(info["LastName"])
        fullname          = RConverter.string(info["FullName"])
        gender            = RConverter.boolean(info["Gender"]) ? "Male" : "Female"
        bio               = RConverter.string(info["Bio"])
        email             = RConverter.string(info["Email"])
        mobile            = RConverter.string(info["MobileNumber"])
        mobileCountryCode = RConverter.string(info["MobileCountryCode"])
        language          = RConverter.string(info["DefaultLanguage"])
        photo             =  kWSDomainURL + RConverter.string(info["Photo"])
        isMobileVerified  = RConverter.boolean(info["IsMobileVerified"])
        isEmailVerified   = RConverter.boolean(info["IsEmailVerified"])
        isTermsAccepted   = RConverter.boolean(info["IsTermsAccepted"])
        isFacebookVerified = RConverter.boolean(info["IsFacebookVerified"])
        rating            = RConverter.integer(info["Rating"])
        numberOfTravels   = RConverter.integer(info["TravelsNumber"])
        numberOfContacts  = RConverter.integer(info["ContactsNumber"])
        birthDate         = RConverter.string(info["BirthDate"])

        let crDate        = dateFormator.dateFromString(RConverter.string(info["CreateDate"]), fomat: "dd/MM/yyyy HH:mm:ss")
        createDate        = dateFormator.stringFromDate(crDate!, format: "dd/MM/yyyy HH:mm:ss")
        let llT           = dateFormator.dateFromString( RConverter.string(info["LastLoginDate"]), fomat: "dd/MM/yyyy HH:mm:ss")
        lastLoginTime     = dateFormator.stringFromDate(llT!, format: "dd/MM/yyyy HH:mm:ss")

        preference        = UserPreference(info: info)
        social            = UserSocial(info: info)
        country           = Country(info: info)
        nationality       = Country(info: ["CountryID": info["NationalityID"]!, "CountryName": info["NationalityName"]!])
        accountType       = AccountType(info: info)

    }
    
    // update user info after successfully updated from server.
    func resetUserInfo(info: [String : AnyObject]) {
        Id                = RConverter.string(info["UserID"])
        firstname         = RConverter.string(info["FirstName"])
        lastname          = RConverter.string(info["LastName"])
        fullname          = RConverter.string(info["FullName"])
        gender            = RConverter.boolean(info["Gender"]) ? "Male" : "Female"
        bio               = RConverter.string(info["Bio"])
        email             = RConverter.string(info["Email"])
        mobile            = RConverter.string(info["MobileNumber"])
        mobileCountryCode = RConverter.string(info["MobileCountryCode"])
        language          = RConverter.string(info["DefaultLanguage"])
        photo             =  kWSDomainURL + RConverter.string(info["Photo"])
        isMobileVerified  = RConverter.boolean(info["IsMobileVerified"])
        isEmailVerified   = RConverter.boolean(info["IsEmailVerified"])
        isTermsAccepted   = RConverter.boolean(info["IsTermsAccepted"])
        isFacebookVerified = RConverter.boolean(info["IsFacebookVerified"])
        rating            = RConverter.integer(info["Rating"])
        numberOfTravels   = RConverter.integer(info["TravelsNumber"])
        numberOfContacts  = RConverter.integer(info["ContactsNumber"])
        birthDate         = RConverter.string(info["BirthDate"])
        
        let crDate        = dateFormator.dateFromString(RConverter.string(info["CreateDate"]), fomat: "dd/MM/yyyy HH:mm:ss")
        createDate        = dateFormator.stringFromDate(crDate!, format: "dd/MM/yyyy HH:mm:ss")
        let llT           = dateFormator.dateFromString( RConverter.string(info["LastLoginDate"]), fomat: "dd/MM/yyyy HH:mm:ss")
        lastLoginTime     = dateFormator.stringFromDate(llT!, format: "dd/MM/yyyy HH:mm:ss")
        
        preference        = UserPreference(info: info)
        social            = UserSocial(info: info)
        country           = Country(info: info)
        nationality       = Country(info: ["CountryID": info["NationalityID"]!, "CountryName": info["NationalityName"]!])
        accountType       = AccountType(info: info)
        
    }
    
    
    //MARK: Conform NSCoying Protocol
    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = User()
        copy.Id = self.Id
        copy.firstname = self.firstname
        copy.lastname = self.lastname
        copy.fullname = self.fullname
        copy.gender = self.gender
        copy.bio = self.bio
        copy.email = self.email
        copy.mobile = self.mobile
        copy.mobileCountryCode = self.mobileCountryCode
        copy.language = self.language
        copy.photo = self.photo
        copy.isMobileVerified = self.isMobileVerified
        copy.isEmailVerified = self.isEmailVerified
        copy.isTermsAccepted = self.isTermsAccepted
        copy.isFacebookVerified = self.isFacebookVerified
        copy.rating = self.rating
        copy.numberOfTravels = self.numberOfTravels
        copy.numberOfContacts = self.numberOfContacts
        copy.birthDate = self.birthDate
        copy.createDate = self.createDate
        copy.lastLoginTime = self.lastLoginTime
        copy.preference = self.preference
        copy.social = self.social
        copy.country = self.country
        copy.nationality = self.nationality
        copy.accountType = self.accountType
        return copy
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
        let params = ["Email"           : email,
                      "FirstName"       : firstname,
                      "LastName"        : lastname,
                      "Password"        : password,
                      "Gender"          : gender == "Male" ? true : false,
                      "YearOfBirth"     : birthDate.componentsSeparatedByString("/")[2],
                      "MonthOfBirth"    : birthDate.componentsSeparatedByString("/")[1],
                      "DayOfBirth"      : birthDate.componentsSeparatedByString("/")[0],
                      "NationalityID"   : nationality.Id,
                      "CountryID"       : country.Id,
                      "MobileCountryCode": mobileCountryCode,
                      "MobileNumber"    : mobile,
                      "FCMToken"        : _FCMToken]
        return params as! [String : AnyObject]
    }
    
    //Login Params
    func loginParameters() -> [String : String!] {
        let params = ["Email"       : email,
                      "Password"    : password,
                      "FCMToken"    : _FCMToken]
        return params
    }
    
    //UpdateProfile Params
    func updateProfileInfoParams() -> [String : AnyObject] {
        let params = ["UserID"          : Id,
                      "FirstName"       : firstname,
                      "LastName"        : lastname,
                      "Gender"          : gender == "Male" ? true : false,
                      "YearOfBirth"     : birthDate.componentsSeparatedByString("/")[2],
                      "MonthOfBirth"    : birthDate.componentsSeparatedByString("/")[1],
                      "DayOfBirth"      : birthDate.componentsSeparatedByString("/")[0],
                      "NationalityID"   : nationality.Id,
                      "CountryID"       : country.Id,
                      "MobileCountryCode": mobileCountryCode,
                      "MobileNumber"    : mobile,
                      "Bio"             : bio,
                      "AccountTypeID"   : accountType.Id]
        return params as! [String : AnyObject]
    }
    
    //Update Social Links Pramas
    func updateSocialInfoParams()-> [String : AnyObject] {
         let params = ["UserID"         : Id,
                       "Whatsapp"       : social.Whatsapp,
                       "Viber"          : social.Viber,
                       "Line"           : social.Line,
                       "Tango"          : social.Tango,
                       "Telegram"       : social.Telegram,
                       "Facebook"       : social.Facebook,
                       "Twitter"        : social.Twitter,
                       "Snapchat"       : social.Snapchat,
                       "Instagram"      : social.Instagram]
        return params
    }
    
    //Update user preference params
    func updateUserPreferenceParams() -> [String : AnyObject] {
        let params = ["UserID":Id,
                      "IsMobilelShown"          : preference.showMobile,
                      "IsEmailShown"            : preference.showEmail,
                      "IsMonitoringAccepted"    : preference.acceptMonitring,
                      "IsTravelRequestReceiver" : preference.IsTravelRequestReceiver,
                      "IsVisibleInSearch"       : preference.visibleInSearch,
                      "PreferencesSmoking"      : preference.smoking,
                      "PreferencesMusic"        : preference.music,
                      "PreferencesFood"         : preference.food,
                      "PreferencesKids"         : preference.kids,
                      "PreferencesPets"         : preference.pets,
                      "PreferencesPrayingStop"  : preference.prayingStop,
                      "PreferencesQuran"        : preference.quran,
                      "DefaultLanguage"         : preference.communicationLanguage,
                      "SpokenLanguages"         : preference.speackingLanguage]
        return params as! [String : AnyObject]
    }
}

//MARK: Validation for user Registration, login, Edit user
extension User {
    //MARK: Signup validation
    //Validate Personal Info
    func validatePersonalInfo() -> (isValid :Bool, message: String) {
        if firstname.isEmpty {
            return (false, "kFirstnameIsRequired".localizedString())
        }
        if lastname.isEmpty {
            return (false, "kLastnameIsRequired".localizedString())
        }
        
        if email.isEmpty {
            return (false, "kEmailIsRequired".localizedString())
        } else {
            if !email.isValidEmailAddress() {
                return (false, "kEmailValidateMsg".localizedString())
            }
        }
        
        if password.isEmpty {
            return (false, "kPasswordIsRequired".localizedString())
        } else {
            if password.characters.count < 8 {
                return (false, "kPasswordWeekMsg".localizedString())
            }
        }
        if confPass.isEmpty {
            return (false, "kConfimPassRequired".localizedString())
        } else {
            if password != confPass {
                return (false, "kPasswordConfirmMsg".localizedString())
            }
        }
        
        return (true, "Success".localizedString())
    }
    
    //Validate Gender info
    func validateGenderInfo() -> (isValid :Bool, message: String) {
        if gender.isEmpty {
            return (false, "kGenderValidateMsg".localizedString())
        }
        return (true, "Success".localizedString())
    }
    
    //Validate Birth Info
    func validateBirthInfo() -> (isValid :Bool, message: String) {
        if birthDate.isEmpty {
            return (false, "kBirthYearRequired".localizedString())
        }
        return (true, "Success".localizedString())
    }
    
    //Validate Contact info
    func validateContactInfo() -> (isValid :Bool, message: String) {
        if mobile.isEmpty {
            return (false, "kMobileNumberIsRequired".localizedString())
        } else {
            if !mobile.isValidMobileNumber() {
            return (false, "kInvalidMobileNumber".localizedString())
            }
        }
        return (true, "Success".localizedString())
    }
    
    //Validate location info
    func validateLocationInfo() -> (isValid :Bool, message: String) {
        if nationality.Id.isEmpty {
            return (false, "kNationalityValidateMsg".localizedString())
        }
        if country.Id.isEmpty {
            return (false, "kCountryValidateMsg".localizedString())
        }
        return (true, "Success".localizedString())
        
    }
    //End signup validation
    
    //MARK: Edit Person Info validation
    //Validate Personal info for Edit profile process
    func validateEditPersonalInfo() -> (isValid :Bool, message: String) {
        if firstname.isEmpty {
            return (false, "kFirstnameIsRequired".localizedString())
        }
        if lastname.isEmpty {
            return (false, "kLastnameIsRequired".localizedString())
        }
        
        if gender.isEmpty {
            return (false, "kGenderValidateMsg".localizedString())
        }

        if birthDate.isEmpty {
            return (false, "kBirthYearRequired".localizedString())
        }

        if mobile.isEmpty {
            return (false, "kMobileNumberIsRequired".localizedString())
        } else {
            if !mobile.isValidMobileNumber() {
                return (false, "kInvalidMobileNumber".localizedString())
            }
        }

        if nationality.Id.isEmpty {
            return (false, "kNationalityValidateMsg".localizedString())
        }
        
        if country.Id.isEmpty {
            return (false, "kCountryValidateMsg".localizedString())
        }

        return (true, "Success")
    }

    //MARK: Login validation
    func validateLoginProcess() -> (isValid: Bool, msg: String) {
        if email.isEmpty {
            return (false, "kEmailIsRequired".localizedString())
        } else {
            if !email.isValidEmailAddress() {
                return (false, "kEmailValidateMsg".localizedString())
            }
        }
        
        if password.isEmpty {
            return (false, "kPasswordIsRequired".localizedString())
        }
        return (true, "Success".localizedString())
    }

    //MARK: Change Password Validation
    func validateChangePassProcess() -> (isValid: Bool, msg: String) {
        if oldPassword.isEmpty {
            return (false, "kOldPassRequired".localizedString())
        }
        if password.isEmpty {
            return (false, "kPasswordIsRequired".localizedString())
        } else {
            if password.characters.count < 8 {
                return (false, "kPasswordWeekMsg".localizedString())
            }
        }
        if confPass.isEmpty {
            return (false, "kConfimPassRequired".localizedString())
        }
        if password != confPass {
            return (false, "kPasswordConfirmMsg".localizedString())
        }
        
        if oldPassword == password {
            return (false, "kOldPassNewPassSameMsg".localizedString())
        }
        return (true, "Success".localizedString())
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
        //specialOrder    = RConverter.boolean(info[""]) //key not found in api response
        smoking     = RConverter.boolean(info["PreferencesSmoking"])
        music       = RConverter.boolean(info["PreferencesMusic"])
        food        = RConverter.boolean(info["PreferencesFood"])
        kids        = RConverter.boolean(info["PreferencesKids"])
        pets        = RConverter.boolean(info["PreferencesPets"])
        prayingStop = RConverter.boolean(info["PreferencesPrayingStop"])
        quran       = RConverter.boolean(info["PreferencesQuran"])
        
        communicationLanguage = RConverter.string(info["DefaultLanguage"])
        speackingLanguage    =  info["SpokenLanguages"] as! [String]
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
