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
let kWSDomainURL = "http://sawacar.es/"  //"https://sawacar.com/"
let kWSBaseUrl = kWSDomainURL + ""//"Services/Sawacar.ashx"
let kUserImageBaseUrl = kWSDomainURL + "Images/UserImages/"

let googleKey = "AIzaSyDHpxmF2p1xUhNeFFqarFWJnTH0PsJL2Ww"   //got from Ravi

let kClientID = "sawaCarAndroid"
let kClientSecret = "21#@hf:2016^%*&f4#$SFD$#^%*(1R^1F"
let kGrantTypePassword = "password"
let kGrantTypeRefreshToken = "refresh_token"


struct APIName {
    static let GetAllCountries = "api/Countries/Get"
    static let GetActiveCountries = "api/Countries/GetActiveCountry"
    static let GetAccountTypes = "api/accountTypes/get"
    static let GetLanguages = "api/General/GetLanguages"
    static let CheckEmailAvailability = "api/users/IsEmailAvailableToSignUp"
    static let Authentication = "token"
    static let RegisterFcmDeviceToken = "api/FcmDevices/RegisterFcmDeviceToken"
    static let SignUp = "api/users/Signup"
    static let ForgetPassword = "api/users/ForgetPassword"
    static let PostUserPhoto = "api/upload/PostUserPhoto"
    static let UpdateUserPhoto = "api/upload/UpdateMyPhoto"
    static let GetMyInfo = "api/users/GetMyInfo/"
    static let UpdatePersonalnfo = "api/users/UpdateUserPersonalnfo"
    static let UpdateSocialMedia = "api/users/UpdateUserSocialMedia"
    static let UpdatePhoneNumber = "api/users/UpdateUserPhoneNumber"
    static let UpdatePreferences = "api/users/UpdateUserPreferences"
    static let ChangePassword    = "api/users/ChangePassword"
}

//MARK: General APIs
extension Webservice {
    
    func callAPI(withName apiName: String, block: WSBlock) {
        jprint("=======WS = Get LIst Items API=======")
        jprint("=Requested API - \(apiName)")
        GET_REQUEST(apiName, param: nil, block: block)
    }
    
    func getAllCoutries(block: WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetAllCountries)=======")
        GET_REQUEST(APIName.GetAllCountries, param: nil, block: block)
    }
    
    func getActiveCountries(block: WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetActiveCountries)=======")
        GET_REQUEST(APIName.GetActiveCountries, param: nil, block: block)
    }
    
    func GetAllCurrencies(block: WSBlock) {
        jprint("=======WS = GetAllCurrencies=======")
        GET_REQUEST(urlWithMethod("GetAllCurrencies"), param: nil, block: block)
    }
    
    func GetCurrency(code: String, block: WSBlock) {
        jprint("=======WS = GetCurrencyByCode=======")
        GET_REQUEST(urlWithMethod("GetCurrencyByCode&Code=" + code), param: nil, block: block)
    }

    func getAccountTypes(block: WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetAccountTypes)=======")
        GET_REQUEST(APIName.GetAccountTypes, param: nil, block: block)
    }

    func getLanguages(block: WSBlock) {
        jprint("=======WS = GetLanguages=======")
        GET_REQUEST(urlWithMethod("GetLanguages"), param: nil, block: block)
    }
    
    func getColors(block: WSBlock) {
        jprint("=======WS = GetAllColors=======")
        GET_REQUEST(urlWithMethod("GetAllColors"), param: nil, block: block)
    }

}

//MARK: User Management - APIs -  Login, Signup, UpdateProfile, UpdatePhoto, GetUserInfo, etc.
extension Webservice {
    
    func checkEmailAvailability(email: String, block: WSBlock) {
        //parameters : Email
        jprint("=======WS =\(kWSDomainURL)\(APIName.CheckEmailAvailability)=======")
        POST_REQUEST(APIName.CheckEmailAvailability, param: ["Email" : email], block: block)
    }
    
    func signUp(params: [String : AnyObject], block: WSBlock) {
        //parameters  -  Email, FirstName, LastName, Password, Gender, Birthday,
        //NationalityID, CountryID, MobileCountryCode, MobileNumber
        jprint("=======WS =\(kWSDomainURL)\(APIName.SignUp)=======")
        POST_REQUEST(APIName.SignUp, param: params, block: block)
    }
    
    func login(params: [String : String], block : WSBlock)  {
        /*parameters -
         client_id = sawaCarAndroid,
         grant_type = password, 
         client_secret = 21#@hf:2016^%*&f4#$SFD$#^%*(1R^1F  ,
         RegisterationToken = your device token,
         username, 
         password */
        jprint("=======WS =\(kWSDomainURL)\(APIName.Authentication)=======")
        POST_REQUEST(APIName.Authentication, param: params, block: block)
    }
    
    func loginWithFacebook(params: [String : AnyObject], block: WSBlock) {
        //parameters - Email, FacebookID, FirstName, LastName, Gender
        jprint("=======WS = LoginWithFacebook=======")
        POST_REQUEST(urlWithMethod("LoginWithFacebook"), param: params, block: block)
    }
    
    func registerFCMToken(params: [String : AnyObject], block: WSBlock) {
        //parameters - token, access_token with Authorization header
        jprint("=======WS =\(kWSDomainURL)\(APIName.RegisterFcmDeviceToken)=======")
        POST_REQUEST(APIName.RegisterFcmDeviceToken, param: params, block: block)
    }

    func changePassword(params: [String : AnyObject], block : WSBlock)  {
        //parameters - OldPassword, NewPassword
        jprint("=======WS =\(kWSDomainURL)\(APIName.ChangePassword)=======")
        PUT_REQUEST(APIName.ChangePassword, param: params, block: block)
    }
    
    func getLoggedInUserInfo( block : WSBlock)  {
        //parameters - access_token with Authorization header
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetMyInfo)=======")
        GET_REQUEST(APIName.GetMyInfo, param: nil, block: block)
    }

    func GetUserInformation(userId: String, block : WSBlock)  {
        //parameters - UserID
        jprint("=======WS = GetUserInformation=======")
        POST_REQUEST(urlWithMethod("GetUserInformation"), param: ["UserID" : userId], block: block)
    }
    
    func uploadProfileImage(forSignup imgData: NSData,   block : WSBlock)  {
        //parameters - UserID, upload
        jprint("=======WS =\(kWSDomainURL)\(APIName.PostUserPhoto)=======")
        uploadImage(imgData, relativepath: APIName.PostUserPhoto, param: nil, block: block)
    }
    
    func uploadProfileImage(forUpdate imgData: NSData, block : WSBlock)  {
        //parameters - Authorization header token, upload
        jprint("=======WS =\(kWSDomainURL)\(APIName.UpdateUserPhoto)=======")
        uploadImage(imgData, relativepath: APIName.UpdateUserPhoto, param: nil, block: block)
    }
    
    func updateUserInformation(params: [String : AnyObject], block : WSBlock)  {
        //parameters - UserID, FirstName, LastName, Gender, YearOfBirth, NationalityID,
        //CountryID, MobileCountryCode, MobileNumber, Bio, AccountTypeID
        jprint("=======WS =\(kWSDomainURL)\(APIName.UpdatePersonalnfo)=======")
        PUT_REQUEST(APIName.UpdatePersonalnfo, param:params, block: block)
    }
    
    func updateSocialInfo(params: [String : AnyObject], block: WSBlock) {
        //Parameters:- UserID, Whatsapp, Viber, Line, Tango, Telegram, Facebook,
        //Twitter, Snapchat, Instagram
        jprint("=======WS =\(kWSDomainURL)\(APIName.UpdateSocialMedia)=======")
        PUT_REQUEST(APIName.UpdateSocialMedia, param:params, block: block)
    }
    
    func updateUserPreference(params: [String : AnyObject], block: WSBlock) {
        //Parameters:- UserID, IsMobilelShown, IsEmailShown, IsMonitoringAccepted, IsTravelRequestReceiver, IsVisibleInSearch,
        //PreferencesSmoking, PreferencesMusic, PreferencesFood, PreferencesKids, PreferencesPets, PreferencesPrayingStop, 
        //PreferencesQuran, DefaultLanguage, SpokenLanguages
        jprint("=======WS =\(kWSDomainURL)\(APIName.UpdatePreferences)=======")
        PUT_REQUEST(APIName.UpdatePreferences, param:params, block: block)
    }
    
    func forgotPassword(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.es/api/users/ForgetPassword
        //Parameters : Email
        jprint("=======WS =\(kWSDomainURL)\(APIName.ForgetPassword)=======")
        POST_REQUEST(APIName.ForgetPassword, param:params, block: block)
    }
    
    //Passenger
    func findDrivers(params: [String : String], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=FindDrivers&AccountTypeID=1&CountryID=105
        jprint("=======WS = FindDrivers=======")
        let accoutTypeId = params["AccountTypeID"]!
        let countryID = params["CountryID"]!
        GET_REQUEST(urlWithMethod("FindDrivers&AccountTypeID=\(accoutTypeId)&CountryID=\(countryID)"), param: nil, block: block)
    }
}

//MARK: Car APIs: AddCar, DeleteCar, UpdateCar, GetUserCars, GetAllCarCompanies
extension Webservice {
    func getCarCompanies(block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetAllCarCompanies
        jprint("=======WS = GetAllCarCompanies=======")
        GET_REQUEST(urlWithMethod("GetAllCarCompanies"), param: nil, block: block)
    }
    
    func getCarOfUser(userId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserCars&UserID=128
        jprint("=======WS = GetUserCars=======")
        GET_REQUEST(urlWithMethod("GetUserCars&UserID=" + userId), param: nil, block: block)
    }

    func addCar(params: [String : AnyObject], block: WSBlock)  {
        //http://sawacar.com/Services/Sawacar.ashx?Method=AddCar
        //Parameters: UserID, CompanyID, Model, ColorID, Seats, Details, Photo, ProductionYear, Insurance
        jprint("=======WS = AddCar=======")
        POST_REQUEST(urlWithMethod("AddCar"), param:params, block: block)
    }
    
    func updateCar(params: [String : AnyObject], block: WSBlock)  {
        //http://sawacar.com/Services/Sawacar.ashx?Method=UpdateCar
        //Parameters: CarID, UserID, CompanyID, Model, ColorID, Seats, Details, Photo, ProductionYear, Insurance
        jprint("=======WS = UpdateCar=======")
        POST_REQUEST(urlWithMethod("UpdateCar"), param:params, block: block)
    }

    func updateCarImage(imgData: NSData, carId: String, block: WSBlock) {
       //http://sawacar.com/Services/Sawacar.ashx?Method=UpdateCarImage&CarID=39
        jprint("=======WS = UpdateCarImage=======")
        uploadImage(imgData, relativepath: urlWithMethod("UpdateCarImage&CarID=\(carId)"), param: nil, block: block)
    }
    
    func deleteCar(carId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=DeleteCar&CarID=89
        jprint("=======WS = DeleteCar=======")
        GET_REQUEST(urlWithMethod("DeleteCar&CarID=" + carId), param: nil, block: block)
    }
    
}

//MARK: Travel APIs - AddTravel, GetTravel, UpdateTravel, DeleteTravel
extension Webservice {
    func addTravel(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=AddTravel
        //Parameters: LocationFrom, LocationTo, LocationStop1, LocationStop2, LocationStop3
        //DepartureDate, DepartureHour, DepartureMinute, DriverID, CarID, CurrencyID, CarPrice,
        //PassengerPrice, Luggages, Seats, LadiesOnly, Tracking, Details, RepeatType, RepeatEndDate,
        //RoundDate, RoundHour, RoundMinute, DepartureFlexibility
        jprint("=======WS = AddTravel=======")
        POST_REQUEST(urlWithMethod("AddTravel"), param:params, block: block)
    }
    
    func updateTravel(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=UpdateTravel
        //Parameters: TravelID, LocationFrom, LocationTo, LocationStop1, LocationStop2, LocationStop3
        //DepartureDate, DepartureHour, DepartureMinute, DriverID, CarID, CurrencyID, CarPrice,
        //PassengerPrice, Luggages, Seats, LadiesOnly, Tracking, Details, RepeatType, RepeatEndDate,
        //RoundDate, RoundHour, RoundMinute, DepartureFlexibility
        jprint("=======WS = UpdateTravel=======")
        POST_REQUEST(urlWithMethod("UpdateTravel"), param:params, block: block)
    }
    
    func getTravels(userId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravels&UserID=39
        jprint("=======WS = GetUserTravels=======")
        GET_REQUEST(urlWithMethod("GetUserTravels&UserID=" + userId), param: nil, block: block)
    }
    
    func getArchivedTravels(userId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserArchivedTravels&UserID=15
        jprint("=======WS = GetUserArchivedTravels=======")
        GET_REQUEST(urlWithMethod("GetUserArchivedTravels&UserID=" + userId), param: nil, block: block)
    }

    func findTravels(fromAddress: String, toAddress: String, block: WSBlock) {
        //https://sawacar.com/Services/Sawacar.ashx?Method=FindTravel&FromAddress=Syria&ToAddress=abc
        jprint("=======WS = FindTravel=======")
        GET_REQUEST(urlWithMethod("FindTravel&FromAddress=\(fromAddress)&ToAddress=\(toAddress)"), param: nil, block: block)
    }
}

//MARK: Booking On Travels - APIs - BookTravel, CancelBooking, ApproveBooking, DeclineBooking, GetUserBookings, GetUserTravelBookings
extension Webservice {
    
    func bookTravel(params: [String: String], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=BookTravel&TravelID=217&UserID=128&Seats=1&AllCar=false
        jprint("=======WS = BookTravel=======")
        let travelId = params["TravelID"]!, userid = params["UserID"]!, seats = params["Seats"]!
        GET_REQUEST(urlWithMethod("BookTravel&TravelID=\(travelId)&UserID=\(userid)&Seats=\(seats)&AllCar=false"), param: nil, block: block)
    }
    
    func cancelBooking(bookingId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=CancelBooking&BookID=14
        jprint("=======WS = CancelBooking=======")
        GET_REQUEST(urlWithMethod("CancelBooking&BookID=" + bookingId), param: nil, block: block)
    }
    
    func approveBooking(bookingId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=ApproveBooking&BookID=14
        jprint("=======WS = ApproveBooking=======")
        GET_REQUEST(urlWithMethod("ApproveBooking&BookID=" + bookingId), param: nil, block: block)
    }

    func declineBooking(bookingId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=DeclineBooking&BookID=18
        jprint("=======WS = DeclineBooking=======")
        GET_REQUEST(urlWithMethod("DeclineBooking&BookID=" + bookingId), param: nil, block: block)
    }

    func getBookings(forPassanger passangerID: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserBookings&UserID=39
        jprint("=======WS = GetUserBookings for passanger=======")
        GET_REQUEST(urlWithMethod("GetUserBookings&UserID=" + passangerID), param: nil, block: block)

    }
    
    func getBookings(forDriver driverID: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravelBookings&UserID=39
        jprint("=======WS = GetUserTravelBookings for driver=======")
        GET_REQUEST(urlWithMethod("GetUserTravelBookings&UserID=" + driverID), param: nil, block: block)
        
    }
}

//MARK: TravelRequest APIs - AddTravelRequest, UpdateTravelRequest, DeleteTravelRequest, GetTravelRequest, GetTravelTypes
extension Webservice {
    func addTravelRequest(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=AddTravelRequest
        //Parameters: LocationFrom, LocationTo, RequesterID, TravelTypeID, CurrencyID, Price
        //DepartureDate, DepartureHour, DepartureMinute, Privacy
        jprint("=======WS = AddTravelRequest=======")
        POST_REQUEST(urlWithMethod("AddTravelRequest"), param:params, block: block)
    }
    
    func updateTravelRequest(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=UpdateTravelRequest
        //Parameters: TravelOrderID, TravelTypeID, CurrencyID, Price
        //DepartureDate, DepartureHour, DepartureMinute, Privacy
        jprint("=======WS = UpdateTravelRequest=======")
        POST_REQUEST(urlWithMethod("UpdateTravelRequest"), param:params, block: block)
    }

    func getTravelRequest(id: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetTravelRequest&TravelRequestID=196
        jprint("=======WS = GetTravelRequest=======")
        GET_REQUEST(urlWithMethod("GetTravelRequest&TravelRequestID=\(id)"), param: nil, block: block)
    }
    
    func getUserTravelRequests(block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravelRequests&UserID=153
        jprint("=======WS = GetUserTravelRequests=======")
        GET_REQUEST(urlWithMethod("GetUserTravelRequests&UserID=\(me.Id)"), param: nil, block: block)
    }
    
    func searchTravelRequests(searchObj: RideRequestSearchObject, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=FindTravelRequest&CountryID=193&TravelTypeID=1
        jprint("=======WS = FindTravelRequest=======")
        let methodUrl = "FindTravelRequest&CountryID=\(searchObj.countryId)&TravelTypeID=\(searchObj.travelTypeId)"
        GET_REQUEST(urlWithMethod(methodUrl), param: nil, block: block)
    }
    
    func getTravelTypes(block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetTravelTypes
        jprint("=======WS = GetTravelTypes=======")
        GET_REQUEST(urlWithMethod("GetTravelTypes"), param: nil, block: block)
        
    }
}

//MARK: Offer on TravelRequest APIs - AddOffer, ApproveOffer, DeclineOffer, CancelOffer, GetUserOffers, GetUserTravelRequestOffers
extension Webservice {
    
    func addOfferOnTravelRequest(params: [String :  String], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=OfferTravelRequest&TravelRequestID=195&UserID=128&Price=12&OfferDate=07/04/2016
        jprint("=======WS = OfferTravelRequest=======")
//        let tRequestId = params["TravelRequestID"]!; let price = params["Price"]!; let date = params["OfferDate"]!
//        getRequest(urlWithMethod("OfferTravelRequest&TravelRequestID=\(tRequestId)&UserID=\(me.Id)&Price=\(price)&OfferDate=\(date)"), param: nil, block: block)
        GET_REQUEST(urlWithMethod("OfferTravelRequest"), param: params, block: block)

    }
    
    func cancelOffer(travelRequestID: String, userID: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=CancelOffer&TravelRequestID=195&UserID=128
        jprint("=======WS = CancelOffer=======")
        GET_REQUEST(urlWithMethod("CancelOffer&TravelRequestID=\(travelRequestID)&UserID=\(userID)"), param: nil, block: block)
    }
    
    func acceptOffer(travelRequestID: String, userID: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=ApproveOffer&TravelRequestID=195&UserID=128
        jprint("=======WS = ApproveOffer=======")
        GET_REQUEST(urlWithMethod("ApproveOffer&TravelRequestID=\(travelRequestID)&UserID=\(userID)"), param: nil, block: block)
    }
    
    func rejectOffer(travelRequestID: String, userID: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=DeclineOffer&TravelRequestID=195&UserID=128
        jprint("=======WS = DeclineOffer=======")
        GET_REQUEST(urlWithMethod("DeclineOffer&TravelRequestID=\(travelRequestID)&UserID=\(userID)"), param: nil, block: block)
    }
    
    
    func getOffers(forDriver driverId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserOffers&UserID=295
        jprint("=======WS = GetUserOffers for driver=======")
        GET_REQUEST(urlWithMethod("GetUserOffers&UserID=" + driverId), param: nil, block: block)
    }
    
    func getOffers(forPassenger passengerId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravelRequestOffers&UserID=295
        jprint("=======WS = GetUserOffers for driver=======")
        GET_REQUEST(urlWithMethod("GetUserTravelRequestOffers&UserID=" + passengerId), param: nil, block: block)
    }
}

//MARK: Alert APIs - AddTravelAlert, AddTravelRequestAlert, GetUserTravelAlerts, GetUserTravelRequestAlerts
extension Webservice {
    func addAlertByPassengerOnTravel(params : [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=AddTravelAlert
        //Parameters : UserID, LocationFrom, LocationTo
        jprint("=======WS = AddTravelAlert=======")
        POST_REQUEST(urlWithMethod("AddTravelAlert"), param:params, block: block)
    }
    
    func addAlertByDriverOnTravelRequest(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=AddTravelRequestAlert
        //Parameters : UserID, TravelTypeID, CountryID
        jprint("=======WS = AddTravelRequestAlert=======")
        POST_REQUEST(urlWithMethod("AddTravelRequestAlert"), param:params, block: block)
    }
    
    func getAlerts(forPassenger passengerId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravelAlerts&UserID=39
        jprint("=======WS = GetUserTravelAlerts for passenger=======")
        GET_REQUEST(urlWithMethod("GetUserTravelAlerts&UserID=\(passengerId)"), param: nil, block: block)
    }
    
    func getAlerts(forDriver driverId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravelRequestAlerts&UserID=39
        jprint("=======WS = GetUserTravelRequestAlerts for driver=======")
        GET_REQUEST(urlWithMethod("GetUserTravelRequestAlerts&UserID=\(driverId)"), param: nil, block: block)
    }
}

//MARK: Message/Comment APIs -
extension Webservice {
    func getInboxMessages(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetInboxMessages
        jprint("=======WS = GetInboxMessages=======")
        POST_REQUEST(urlWithMethod("GetInboxMessages"), param:params, block: block)
    }
    
    func getContacts(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserContacts
        jprint("=======WS = GetUserContacts=======")
        POST_REQUEST(urlWithMethod("GetUserContacts"), param:params, block: block)
    }
    
    func getMessageWithOtherUser(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetMessagesFromUser
        jprint("=======WS = GetMessagesFromUser=======")
        POST_REQUEST(urlWithMethod("GetMessagesFromUser"), param:params, block: block)
    }
    
    func sendMessage(params: [String : AnyObject], block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=SendNewMessage
        jprint("=======WS = SendNewMessage=======")
        POST_REQUEST(urlWithMethod("SendNewMessage"), param:params, block: block)
    }

}


//MARK: Ratings APIs -
extension Webservice {
    
    //Api for getting ratings which you have gave for other users and cars.
    func getRatings(byUser userId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetRatesUserGive&UserID=39
        jprint("=======WS = GetUserTravelRequestAlerts for driver=======")
        GET_REQUEST(urlWithMethod("GetRatesUserGive&UserID=\(userId)"), param: nil, block: block)
    }
    
    //API for getting ratings which you have got from other users.
    func getRatings(forUser userId: String, block: WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetRatesUserGot&UserID=39
        jprint("=======WS = GetUserTravelRequestAlerts for driver=======")
        GET_REQUEST(urlWithMethod("GetRatesUserGot&UserID=\(userId)"), param: nil, block: block)
    }
    
    //rate user api
    func rateUser(params: [String : AnyObject], block: WSBlock) {
        //Needs api request in httpPost method.
    }
    
    //rate car api
    func rateCar(params: [String : AnyObject], block: WSBlock) {
        //Needs api request in httpPost method.
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
        //manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer.acceptableContentTypes = Set(["text/html", "text/plain", "application/json"])
        
        
        // Success and Error response block, singletone block for all responses
        succBlock = { (dataTask, responseObj, relPath, block) in
            let response = dataTask.response! as! NSHTTPURLResponse
            print("Response Code : \(response.statusCode)")
            print("Response ((\(relPath)): \(responseObj)")
            block(response: vResponse(success: responseObj), flag: response.statusCode)
        }
        
        errBlock = { (dataTask, error, relPath, block) in
            let dat = error.userInfo["com.alamofire.serialization.response.error.data"] as? NSData
            if let errData = dat {
                let erInfo =  (try! NSJSONSerialization.JSONObjectWithData(errData, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                print("Error - json(\(relPath)): \(erInfo)")
                block(response: vResponse(error: erInfo) , flag: error.code)
            } else {
                print("Error(\(relPath)): \(error)")
                block(response: vResponse(error: error) , flag: error.code)
            }
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
        self.setRequiredHeader()
    }
    
    
    //Set other header
    func setRequiredHeader() {
        manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        manager.requestSerializer.setValue("en", forHTTPHeaderField: "Accept-Language")
    }
    
    // sign manager with access token
    func addAccesTokenToHeader(token: String){
        manager.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("Token added: \(token)")
    }

    func accessTokenForHeader() -> String? {
        return manager.requestSerializer.valueForHTTPHeaderField("Authorization")
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
    private func POST_REQUEST(relativePath: String, param: NSDictionary?, block: WSBlock) {
        print("Parameters %@", param)
        manager.POST(relativePath, parameters: param, success: { (task, responseObj) -> Void in
            self.succBlock(dataTask: task, responseObj: responseObj, relPath: relativePath, block: block)
            }, failure: { (task, error) -> Void in
                self.errBlock(dataTask: task, error: error, relPath: relativePath, block: block)
        })
    }
    
    // MARK: Private Methods
    private func PUT_REQUEST(relativePath: String, param: NSDictionary?, block: WSBlock) {
        print("Parameters %@", param)
        manager.PUT(relativePath, parameters: param, success: { (task, responseObj) -> Void in
            self.succBlock(dataTask: task, responseObj: responseObj, relPath: relativePath, block: block)
            }, failure: { (task, error) -> Void in
                self.errBlock(dataTask: task, error: error, relPath: relativePath, block: block)
        })
    }

    // MARK: Private Methods
    private func DELETE_REQUEST(relativePath: String, param: NSDictionary?, block: WSBlock) {
        print("Parameters %@", param)
        manager.DELETE(relativePath, parameters: param, success: { (task, responseObj) -> Void in
            self.succBlock(dataTask: task, responseObj: responseObj, relPath: relativePath, block: block)
            }, failure: { (task, error) -> Void in
                self.errBlock(dataTask: task, error: error, relPath: relativePath, block: block)
        })
    }

    
    private func GET_REQUEST(relativePath: String, param: NSDictionary?, block: WSBlock)-> NSURLSessionDataTask {
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
            formData.appendPartWithFileData(imgData, name: "upload", fileName: "image.jpeg", mimeType: "image/jpeg")
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
    let characterSet = NSCharacterSet.URLPathAllowedCharacterSet()
    let query = method.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!
    let url = kWSBaseUrl + "?Method=" + query
    jprint("Requested url -" + url)
    return url
}

//Structure will be used for manage the ws response.
struct vResponse {
    var isSuccess  = false
    let json: AnyObject?
    var message: String
    
    init(success rJson : AnyObject?) {
        isSuccess = true
        json = rJson
        message = ""

        if let json = rJson as? [String: AnyObject] {
            if let msg = json["Message"] as? String {
                message = msg
            }
        }
    }
    
    init(error rJson : AnyObject?) {
        isSuccess = false
        if rJson is [String : AnyObject] {
            if  let msg = rJson!["Message"] as? String {
                message = msg
            } else if let msg = rJson!["error_description"] as? String {
                message = msg
            } else {
                message = "AnErrorAccured".localizedString()
            }
        } else {
            message = "AnErrorAccured".localizedString()
        }
        json = rJson
    }

}
