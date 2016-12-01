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
    
    func GetCurrency(code: String, block: WSBlock) {
        //https://sawacar.com/Services/Sawacar.ashx?Method=GetCurrencyByCode&Code=INR
        jprint("=======WS = GetCurrencyByCode=======")
        getRequest(urlWithMethod("GetCurrencyByCode&Code=" + code), param: nil, block: block)
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

//MARK: User Management -  Login, Registratin, UpdateProfile, UpdatePhoto, GetUserInfo, etc.
extension Webservice {
    
    func checkEmailAvailability(email: String, block: WSBlock) {
        //https://sawacar.com/Services/Sawacar.ashx?Method=IsEmailAvailableToSignUp
        //parameters : Email
        jprint("=======WS = IsEmailAvailableToSignUp=======")
        postRequest(urlWithMethod("IsEmailAvailableToSignUp"), param: ["Email" : email], block: block)
    }
    
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
    
    func forgotPassword(params: [String : AnyObject], block: WSBlock) {
        //https://sawacar.com/Services/Sawacar.ashx?Method=ForgetPassword
        //Parameters : Email
        jprint("=======WS = Forgot password api call=======")
        postRequest(urlWithMethod("ForgetPassword"), param:params, block: block)
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
    
    func updateTravel(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=UpdateTravel
        //Parameters: TravelID, LocationFrom, LocationTo, LocationStop1, LocationStop2, LocationStop3
        //DepartureDate, DepartureHour, DepartureMinute, DriverID, CarID, CurrencyID, CarPrice,
        //PassengerPrice, Luggages, Seats, LadiesOnly, Tracking, Details, RepeatType, RepeatEndDate,
        //RoundDate, RoundHour, RoundMinute, DepartureFlexibility
        jprint("=======WS = UpdateTravel=======")
        postRequest(urlWithMethod("UpdateTravel"), param:params, block: block)
    }
    
    func getTravels(userId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravels&UserID=39
        jprint("=======WS = GetUserTravels=======")
        getRequest(urlWithMethod("GetUserTravels&UserID=" + userId), param: nil, block: block)
    }
    
    func getArchivedTravels(userId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserArchivedTravels&UserID=15
        jprint("=======WS = GetUserArchivedTravels=======")
        getRequest(urlWithMethod("GetUserArchivedTravels&UserID=" + userId), param: nil, block: block)
    }

    func findTravels(fromAddress: String, toAddress: String, block: WSBlock) {
        //https://sawacar.com/Services/Sawacar.ashx?Method=FindTravel&FromAddress=Syria&ToAddress=abc
        jprint("=======WS = FindTravel=======")
        getRequest(urlWithMethod("FindTravel&FromAddress=\(fromAddress)&ToAddress=\(toAddress)"), param: nil, block: block)
    }
}

//MARK: TravelRequest - AddTravelRequest, UpdateTravelRequest, DeleteTravelRequest, GetTravelRequest, GetTravelTypes
extension Webservice {
    func addTravelRequest(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=AddTravelRequest
        //Parameters: LocationFrom, LocationTo, RequesterID, TravelTypeID, CurrencyID, Price
        //DepartureDate, DepartureHour, DepartureMinute, Privacy
        jprint("=======WS = AddTravelRequest=======")
        postRequest(urlWithMethod("AddTravelRequest"), param:params, block: block)
    }
    
    func getTravelRequest(id: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetTravelRequest&TravelRequestID=196
        jprint("=======WS = GetTravelRequest=======")
        getRequest(urlWithMethod("GetTravelRequest&TravelRequestID=\(id)"), param: nil, block: block)
    }
    
    func getUserTravelRequests(block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravelRequests&UserID=153
        jprint("=======WS = GetUserTravelRequests=======")
        getRequest(urlWithMethod("GetUserTravelRequests&UserID=\(153)"), param: nil, block: block)
    }
    
    func searchTravelRequests(searchObj: RideRequestSearchObject, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=FindTravelRequest&CountryID=193&TravelTypeID=1
        jprint("=======WS = FindTravelRequest=======")
        let methodUrl = "FindTravelRequest&CountryID=\(searchObj.countryId)&TravelTypeID=\(searchObj.travelTypeId)"
        getRequest(urlWithMethod(methodUrl), param: nil, block: block)
    }
    
    func getTravelTypes(block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetTravelTypes
        jprint("=======WS = GetTravelTypes=======")
        getRequest(urlWithMethod("GetTravelTypes"), param: nil, block: block)
        
    }
}

//MARK: Offer on TravelRequest - AddOffer, ApproveOffer, DeclineOffer, CancelOffer, GetUserOffers, GetUserTravelRequestOffers
extension Webservice {
    
    func addOfferOnTravelRequest(params: [String :  String], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=OfferTravelRequest&TravelRequestID=195&UserID=128&Price=12&OfferDate=07/04/2016
        jprint("=======WS = OfferTravelRequest=======")
        let tRequestId = params["TravelRequestID"]!; let price = params["Price"]!; let date = params["OfferDate"]!
        getRequest(urlWithMethod("OfferTravelRequest&TravelRequestID=\(tRequestId)&UserID=\(me.Id)&Price=\(price)&OfferDate=\(date)"), param: nil, block: block)
    }
    
    func cancelOffer(travelRequestID: String, userID: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=CancelOffer&TravelRequestID=195&UserID=128
        jprint("=======WS = CancelOffer=======")
        getRequest(urlWithMethod("CancelOffer&TravelRequestID=\(travelRequestID)&UserID=\(userID)"), param: nil, block: block)
    }
    
    func acceptOffer(travelRequestID: String, userID: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=ApproveOffer&TravelRequestID=195&UserID=128
        jprint("=======WS = ApproveOffer=======")
        getRequest(urlWithMethod("ApproveOffer&TravelRequestID=\(travelRequestID)&UserID=\(userID)"), param: nil, block: block)
    }
    
    func rejectOffer(travelRequestID: String, userID: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=DeclineOffer&TravelRequestID=195&UserID=128
        jprint("=======WS = DeclineOffer=======")
        getRequest(urlWithMethod("DeclineOffer&TravelRequestID=\(travelRequestID)&UserID=\(userID)"), param: nil, block: block)
    }
    
}

//MARK: Webservice Inialization and AFNetworking setup
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
                self.showAlert("No internet".localizedString(), message: "Your_internet_connection_down".localizedString())
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
            self.showAlert("No_internet".localizedString(), message: "Your_internet_connection_down".localizedString())
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
