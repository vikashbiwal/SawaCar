//
//  WebServicesCalls.swift
//  BitonMessanger
//
//  Created by Yudiz Solutions Pvt. Ltd. on 17/09/15.
//  Copyright (c) 2015 Yudiz Solutions Pvt. Ltd. All rights reserved.
//


import UIKit


typealias WSBlock = (response: vResponse, flag: Int) -> ()
var wsCall = {  return Webservice()}()
var kWSDomainURL = "https://sawacar.com/"
var kWSBaseUrl = kWSDomainURL + "Services/Sawacar.ashx"
let googleKey = "AIzaSyDHpxmF2p1xUhNeFFqarFWJnTH0PsJL2Ww"   //got from Ravi

//MARK: General WebService
extension Webservice {
    func getAllCoutries(block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetAllCountries
        jprint("=======WS = GetAllCountries=======")
        getRequest(urlWithMethod("GetAllCountries"), param: nil, block: block)
    }
    
    func getActiveCoutries(block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetActiveCountries
        jprint("=======WS = GetActiveCountries=======")
        getRequest(urlWithMethod("GetActiveCountries"), param: nil, block: block)
    }
    
    func GetAllCurrencies(block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetAllCurrencies
        jprint("=======WS = GetAllCurrencies=======")
        getRequest(urlWithMethod("GetAllCurrencies"), param: nil, block: block)
    }
    
    func getAccountTypes(block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetAccountTypes
        jprint("=======WS = GetAccountTypes=======")
        getRequest(urlWithMethod("GetAccountTypes"), param: nil, block: block)
    }

    func getLanguages(block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetLanguages
        jprint("=======WS = GetLanguages=======")
        getRequest(urlWithMethod("GetLanguages"), param: nil, block: block)
    }
    
    func getColors(block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetAllColors
        jprint("=======WS = GetAllColors=======")
        getRequest(urlWithMethod("GetAllColors"), param: nil, block: block)
    }

}

//MARK: User related WebServices
extension Webservice {
    func signUp(params: [String : AnyObject], block: WSBlock) {
        //https://sawacar.com/Services/Sawacar.ashx?Method=SignUp
        //parameters  -  Email, FirstName, LastName, Password, Gender, YearOfBirth,
        //NationalityID, CountryID, MobileCountryCode, MobileNumber
        jprint("=======WS = SignUp=======")
        postRequest(urlWithMethod("SignUp"), param: params, block: block)
    }
    
    func login(params: [String : String!], block : WSBlock)  {
        //https://sawacar.com/Services/Sawacar.ashx?Method=Login
        //parameters - Email, Password
        jprint("=======WS = Login=======")
        postRequest(urlWithMethod("Login"), param: params, block: block)
    }
    
    func loginWithFacebook(params: [String : AnyObject], block: WSBlock) {
        //https://sawacar.com/Services/Sawacar.ashx?Method=LoginWithFacebook
        //parameters - Email, FacebookID, FirstName, LastName, Gender
        jprint("=======WS = LoginWithFacebook=======")
        postRequest(urlWithMethod("LoginWithFacebook"), param: params, block: block)
    }
    
    func changePassword(params: [String : AnyObject], block : WSBlock)  {
        //https://sawacar.com/Services/Sawacar.ashx?Method=ChangePassword
        //parameters - Email, OldPassword, NewPassword
        jprint("=======WS = ChangePassword=======")
        postRequest(urlWithMethod("ChangePassword"), param: params, block: block)
    }
    
    func GetUserInformation(userId: String, block : WSBlock)  {
        //https://sawacar.com/Services/Sawacar.ashx?Method=GetUserInformation
        //parameters - UserID
        jprint("=======WS = GetUserInformation=======")
        postRequest(urlWithMethod("GetUserInformation"), param: ["UserID" : userId], block: block)
    }
    
    func updateUserProfileImage(imgData: NSData, userid: String,  block : WSBlock)  {
        //https://sawacar.com/Services/Sawacar.ashx?Method=UpdateUserImage&UserID=128
        //parameters - UserID, FileData
        jprint("=======WS = UpdateUserImage=======")
        uploadImage(imgData, relativepath: urlWithMethod("UpdateUserImage&UserID=" + userid), param: nil, block: block)
    }
    
    func updateUserInformation(params: [String : AnyObject], block : WSBlock)  {
        //https://sawacar.com/Services/Sawacar.ashx?Method=UpdateUserPersonalnfo
        //parameters - UserID, FirstName, LastName, Gender, YearOfBirth, NationalityID,
        //CountryID, MobileCountryCode, MobileNumber, Bio, AccountTypeID
        jprint("=======WS = UpdateUserPersonalnfo=======")
        postRequest(urlWithMethod("UpdateUserPersonalnfo"), param:params, block: block)
    }
    
    func updateSocialInfo(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=UpdateUserSocialMedia
        //Parameters:- UserID, Whatsapp, Viber, Line, Tango, Telegram, Facebook, 
        //Twitter, Snapchat, Instagram
        jprint("=======WS = UpdateUserSocialMedia=======")
        postRequest(urlWithMethod("UpdateUserSocialMedia"), param:params, block: block)
    }
    
    func updateUserPreference(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=UpdateUserPreferences
        //Parameters:- UserID, IsMobilelShown, IsEmailShown, IsMonitoringAccepted, IsTravelRequestReceiver, IsVisibleInSearch, 
        //PreferencesSmoking, PreferencesMusic, PreferencesFood, PreferencesKids, PreferencesPets, PreferencesPrayingStop, 
        //PreferencesQuran, DefaultLanguage, SpokenLanguages
        jprint("=======WS = UpdateUserPreferences=======")
        postRequest(urlWithMethod("UpdateUserPreferences"), param:params, block: block)
    }
}

//MARK: Car: AddCar, DeleteCar, UpdateCar, GetUserCars, GetAllCarCompanies
extension Webservice {
    func getCarCompanies(block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetAllCarCompanies
        jprint("=======WS = GetAllCarCompanies=======")
        getRequest(urlWithMethod("GetAllCarCompanies"), param: nil, block: block)
    }
    
    func getCarOfUser(userId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserCars&UserID=128
        jprint("=======WS = GetUserCars=======")
        getRequest(urlWithMethod("GetUserCars&UserID=" + userId), param: nil, block: block)
    }

    func addCar(params: [String : AnyObject], block: WSBlock)  {
        //http://sawacar.com/Services/Sawacar.ashx?Method=AddCar
        //Parameters: UserID, CompanyID, Model, ColorID, Seats, Details, Photo, ProductionYear, Insurance
        jprint("=======WS = AddCar=======")
        postRequest(urlWithMethod("AddCar"), param:params, block: block)
    }
    
    func updateCar(params: [String : AnyObject], block: WSBlock)  {
        //http://sawacar.com/Services/Sawacar.ashx?Method=UpdateCar
        //Parameters: CarID, UserID, CompanyID, Model, ColorID, Seats, Details, Photo, ProductionYear, Insurance
        jprint("=======WS = UpdateCar=======")
        postRequest(urlWithMethod("UpdateCar"), param:params, block: block)
    }

    func updateCarImage(imgData: NSData, carId: String, block: WSBlock) {
       //http://sawacar.com/Services/Sawacar.ashx?Method=UpdateCarImage&CarID=39
        jprint("=======WS = UpdateCarImage=======")
        uploadImage(imgData, relativepath: urlWithMethod("UpdateCarImage&CarID=\(carId)"), param: nil, block: block)
    }
    
    func deleteCar(carId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=DeleteCar&CarID=89
        jprint("=======WS = DeleteCar=======")
        getRequest(urlWithMethod("DeleteCar&CarID=" + carId), param: nil, block: block)
    }

    
}

//MARK: Travel - AddTravel, GetTravel, UpdateTravel, DeleteTravel
extension Webservice {
    func addTravel(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=AddTravel
        //Parameters: LocationFrom, LocationTo, LocationStop1, LocationStop2, LocationStop3
        //DepartureDate, DepartureHour, DepartureMinute, DriverID, CarID, CurrencyID, CarPrice,
        //PassengerPrice, Luggages, Seats, LadiesOnly, Tracking, Details, RepeatType, RepeatEndDate,
        //RoundDate, RoundHour, RoundMinute, DepartureFlexibility
        jprint("=======WS = AddTravel=======")
        postRequest(urlWithMethod("AddTravel"), param:params, block: block)
    }
}


//MARK: Webservice Inialization and Afnetworking setup
class Webservice: NSObject {
    var manager : AFHTTPSessionManager!
    lazy var downloadManager: AFURLSessionManager = AFURLSessionManager()
    
    var succBlock: (dataTask :NSURLSessionDataTask!, responseObj :AnyObject!, relPath: String, block: WSBlock) -> Void
    var errBlock: (dataTask :NSURLSessionDataTask!, error :NSError!, relPath: String, block: WSBlock) -> Void
    
    override init() {
        manager = AFHTTPSessionManager(baseURL: NSURL(string: kWSBaseUrl))
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer.acceptableContentTypes = Set(["text/html", "text/plain", "application/json"])
        // Success and Error response block, singletone block for all responses
        succBlock = { (dataTask, responseObj, relPath, block) in
            let response = dataTask.response! as! NSHTTPURLResponse
            print("Response Code : \(response.statusCode)")
            print("Response ((\(relPath)): \(responseObj)")
            block(response: vResponse(rJson: responseObj), flag: response.statusCode)
        }
        errBlock = { (dataTask, error, relPath, block) in
            let dat = error.userInfo["com.alamofire.serialization.response.error.data"] as? NSData
            if let errData = dat {
                let erInfo =  (try! NSJSONSerialization.JSONObjectWithData(errData, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                print("Error - json(\(relPath)): \(erInfo)")
            } else {
                print("Error(\(relPath)): \(error)")
            }
            block(response: vResponse(rJson: nil) , flag: error.code)
        }
        
        super.init()
        manager.reachabilityManager.setReachabilityStatusChangeBlock { (status: AFNetworkReachabilityStatus) -> Void in
            if status == AFNetworkReachabilityStatus.NotReachable {
                self.showAlert("No internet", message: "Your internet connection seems to be down")
            } else if status == AFNetworkReachabilityStatus.ReachableViaWiFi ||
                status == AFNetworkReachabilityStatus.ReachableViaWWAN {
                // do nothing for now
            }
        }
        manager.reachabilityManager.startMonitoring()
    }
    
    // sign manager with access token
    func addAccesTokenToHeader(token: String){
        manager.requestSerializer.setValue("\(token)", forHTTPHeaderField: "")
        print("Token added: \(token)")
    }
    
    func accessTokenForHeader() -> String? {
        return manager.requestSerializer.valueForHTTPHeaderField("")
    }
    
    // MARK: Utility methods
    func isInternetAvailable() -> Bool {
        let bl = manager.reachabilityManager.networkReachabilityStatus != AFNetworkReachabilityStatus.NotReachable
        if bl == false {
            self.showAlert("No internet", message: "Your internet connection seems to be down")
        }
        return bl
    }
    
    private func showAlert(title:NSString, message:String) {
        let alert :UIAlertView = UIAlertView(title: title as String, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    // MARK: Private Methods
    private func postRequest(relativePath: String, param: NSDictionary?, block: WSBlock) {
        print("Parameters %@", param)
        manager.POST(relativePath, parameters: param, success: { (task, responseObj) -> Void in
            self.succBlock(dataTask: task, responseObj: responseObj, relPath: relativePath, block: block)
            }, failure: { (task, error) -> Void in
                self.errBlock(dataTask: task, error: task?.error, relPath: relativePath, block: block)
        })
    }
    
    
    private func getRequest(relativePath: String, param: NSDictionary?, block: WSBlock)-> NSURLSessionDataTask {
        print("Parameters %@", param)
      return  manager.GET(relativePath, parameters: param, success: { (task, responseObj) -> Void in
            self.succBlock(dataTask: task, responseObj: responseObj, relPath: relativePath, block: block)
            }, failure:  { (task, error) -> Void in
                self.errBlock(dataTask: task, error: task?.error, relPath: relativePath, block: block)
        })!
    }
    
    private func uploadImage(imgData: NSData, relativepath: String, param: NSDictionary?, block: WSBlock) {
        print("Parameters %@", param)
        manager.POST(relativepath, parameters: param, constructingBodyWithBlock: { (formData) -> Void in
            formData.appendPartWithFileData(imgData, name: "FileData", fileName: "image.jpeg", mimeType: "image/jpeg")
            }, success: { (task, responseObj) -> Void in
                self.succBlock(dataTask: task, responseObj: responseObj, relPath: relativepath, block: block)
            }, failure:  { (task, error) -> Void in
                self.errBlock(dataTask: task, error: task?.error, relPath: relativepath, block: block)
        })
    }
    
    private func uploadContacts(relativepath: String, param: [String], block: WSBlock) {
        manager.POST(relativepath, parameters: param, constructingBodyWithBlock: { (formData) -> Void in
            for contc in param as [NSString] {
                formData.appendPartWithFormData(contc.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "phonehash[]")
            }
            }, success: { (task, responseObj) -> Void in
                self.succBlock(dataTask: task, responseObj: responseObj, relPath: relativepath, block: block)
            }, failure:  { (task, error) -> Void in
                self.errBlock(dataTask: task, error: task?.error, relPath: relativepath, block: block)
        })
    }
}

//MARK: Create WS url with api name
func urlWithMethod(method: String) -> String {
    let url = kWSBaseUrl + "?Method=" + method
    jprint("Requested url -" + url)
    return url
}

//Structure will be used for manage the ws response.
struct vResponse {
    var isSuccess  = false
    let json: AnyObject?
    var message: String?
    
    init(rJson : AnyObject?) {
        if let rJson = rJson { // for SawCar api response
            if let  _  = (rJson as! NSDictionary)["IsSuccess"] {
                isSuccess = ((rJson as! NSDictionary)["IsSuccess"] as! Int)  == 1 ? true : false
            }
            //assign message, if any get with response.
            if let messageObj = (rJson as! [String : AnyObject])["Messages"] {
                message = (messageObj as! [String]).first
            }
        } else {
          message = "Server Error"
        }
        json = rJson
    }
}
