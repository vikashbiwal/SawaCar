//
//  WebServicesCalls.swift
//  BitonMessanger
//
//  Created by Yudiz Solutions Pvt. Ltd. on 17/09/15.
//  Copyright (c) 2015 Yudiz Solutions Pvt. Ltd. All rights reserved.
//


import UIKit


typealias WSBlock = (_ response: vResponse, _ flag: Int) -> ()
var wsCall = {  return Webservice()}()
let kWSDomainURL = "http://sawacar.es/"  //"https://sawacar.com/"
let kWSBaseUrl = kWSDomainURL + ""//"Services/Sawacar.ashx"
let kUserImageBaseUrl = kWSDomainURL + "Images/UserImages/"

let googleKey = "AIzaSyDHpxmF2p1xUhNeFFqarFWJnTH0PsJL2Ww"   //got from Ravi

let kClientID = "sawaCarAndroid"
let kClientSecret = "21#@hf:2016^%*&f4#$SFD$#^%*(1R^1F"
let kGrantTypePassword = "password"
let kGrantTypeRefreshToken = "refresh_token"

//============================================================================================
//MARK: API Names
//============================================================================================

struct APIName {
    static let GetAllCountries = "api/Countries/Get/"
    static let GetActiveCountries = "api/Countries/GetActiveCountry/"
    static let GetAccountTypes = "api/accountTypes/get/"
    static let GetLanguages = "api/General/GetLanguages/"
    static let GetAllCurrency = "api/Currencies/Get/"
    static let GetActiveCurrency = "api/Currencies/GetActive/"
    static let GetCurrencyByCode = "api/Currencies/GetByCode/"
    static let GetColors = "api/ColorMultiLinguals/GetColors/"
    
    static let CheckEmailAvailability = "api/users/IsEmailAvailableToSignUp/"
    static let Authentication = "token"
    static let RegisterFcmDeviceToken = "api/FcmDevices/RegisterFcmDeviceToken/"
    static let SignUp = "api/users/Signup/"
    static let ForgetPassword = "api/users/ForgetPassword/"
    static let PostUserPhoto = "api/upload/PostUserPhoto/"
    static let UpdateUserPhoto = "api/upload/UpdateMyPhoto/"
    static let GetMyInfo = "api/users/GetMyInfo/"
    
    static let UpdatePersonalnfo = "api/users/UpdateUserPersonalnfo/"
    static let UpdateSocialMedia = "api/users/UpdateUserSocialMedia/"
    static let UpdatePhoneNumber = "api/users/UpdateUserPhoneNumber/"
    static let UpdatePreferences = "api/users/UpdateUserPreferences/"
    static let ChangePassword    = "api/users/ChangePassword/"
   
    static let GetCarType = "api/VichelType/GetCarType/"
    static let GetCarCompanies = "api/VichelCompany/GetCarCompany/"
    static let GetUserCars = "api/Cars/GetMy/"
    static let AddCar = "api/Cars/Post/"
    static let UpdateCar = "api/Cars/UpdateCar/"
    static let UpdateCarImage = "api/cars/UpdateImageCar/"
    static let DeleteCar = "api/Cars/Delete/"

    static let AddTravel = "api/Travel/Post/"
    static let UpdateTravel = ""
    static let SearchTravels = "api/Travel/Search/"
    static let GetMyTravels = "api/Travel/GetMyTravels/"
    static let GetTravelByUser = "api/Travel/Get/"  //Append userID with url
}

//===================================================================================================================================
//MARK: General APIs
//===================================================================================================================================

extension Webservice {
    
    func callAPI(withName apiName: String, block: @escaping WSBlock) {
        jprint("=======WS = Get LIst Items API=======")
        jprint("=Requested API - \(apiName)")
        _ = GET_REQUEST(apiName, param: nil, block: block)
    }
    
    func getAllCoutries(_ block: @escaping WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetAllCountries) =======")
       _ = GET_REQUEST(APIName.GetAllCountries, param: nil, block: block)
    }
    
    func getActiveCountries(_ block: @escaping WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetActiveCountries) =======")
        _ = GET_REQUEST(APIName.GetActiveCountries, param: nil, block: block)
    }
    
    func GetAllCurrencies(_ block: @escaping WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetAllCurrency) =======")
         _ = GET_REQUEST(APIName.GetAllCurrency, param: nil, block: block)
    }
    
    func GetCurrency(_ code: String, block: @escaping WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetCurrencyByCode) =======")
        _ = GET_REQUEST(APIName.GetCurrencyByCode + code, param: nil, block: block)
    }

    func getAccountTypes(_ block: @escaping WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetAccountTypes) =======")
        _ = GET_REQUEST(APIName.GetAccountTypes, param: nil, block: block)
    }

    func getLanguages(_ block: @escaping WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetLanguages) =======")
        _ = GET_REQUEST(APIName.GetLanguages, param: nil, block: block)
    }
    
    func getColors(_ block: @escaping WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetColors) =======")
        _ = GET_REQUEST(APIName.GetColors, param: nil, block: block)
    }

}

//===================================================================================================================================
//MARK: User Management - APIs -  Login, Signup, UpdateProfile, UpdatePhoto, GetUserInfo, etc.
//===================================================================================================================================

extension Webservice {
    
    func checkEmailAvailability(_ email: String, block: @escaping WSBlock) {
        //parameters : Email
        jprint("=======WS =\(kWSDomainURL)\(APIName.CheckEmailAvailability) =======")
        POST_REQUEST(APIName.CheckEmailAvailability, param: ["Email" : email], block: block)
    }
    
    func signUp(_ params: [String : Any], block: @escaping WSBlock) {
        //parameters  -  Email, FirstName, LastName, Password, Gender, Birthday,
        //NationalityID, CountryID, MobileCountryCode, MobileNumber
        jprint("=======WS =\(kWSDomainURL)\(APIName.SignUp) =======")
        POST_REQUEST(APIName.SignUp, param: params, block: block)
    }
    
    func login(_ params: [String : String], block : @escaping WSBlock)  {
        /*parameters -
         client_id = sawaCarAndroid,
         grant_type = password, 
         client_secret = 21#@hf:2016^%*&f4#$SFD$#^%*(1R^1F  ,
         RegisterationToken = your device token,
         username, 
         password */
        jprint("=======WS =\(kWSDomainURL)\(APIName.Authentication) =======")
        POST_REQUEST(APIName.Authentication, param: params , block: block)
    }
    
    func loginWithFacebook(_ params: [String : Any], block: @escaping WSBlock) {
        //parameters - Email, FacebookID, FirstName, LastName, Gender
        jprint("=======WS = LoginWithFacebook=======")
        POST_REQUEST("", param: params , block: block)
    }
    
    func registerFCMToken(_ params: [String : Any], block: @escaping WSBlock) {
        //parameters - token, access_token with Authorization header
        jprint("=======WS =\(kWSDomainURL)\(APIName.RegisterFcmDeviceToken)=======")
        POST_REQUEST(APIName.RegisterFcmDeviceToken, param: params , block: block)
    }

    func changePassword(_ params: [String : Any], block : @escaping WSBlock)  {
        //parameters - OldPassword, NewPassword
        jprint("=======WS =\(kWSDomainURL)\(APIName.ChangePassword)=======")
        PUT_REQUEST(APIName.ChangePassword, param: params, block: block)
    }
    
    func getLoggedInUserInfo( _ block : @escaping WSBlock)  {
        //parameters - access_token with Authorization header
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetMyInfo)=======")
        _ = GET_REQUEST(APIName.GetMyInfo, param: nil, block: block)
    }

    
    func uploadProfileImage(forSignup imgData: Data,   block : @escaping WSBlock)  {
        //parameters - UserID, upload
        jprint("=======WS =\(kWSDomainURL)\(APIName.PostUserPhoto)=======")
        uploadImage(imgData, relativepath: APIName.PostUserPhoto, param: nil, block: block)
    }
    
    func uploadProfileImage(forUpdate imgData: Data, block : @escaping WSBlock)  {
        //parameters - Authorization header token, upload
        jprint("=======WS =\(kWSDomainURL)\(APIName.UpdateUserPhoto)=======")
        uploadImage(imgData, relativepath: APIName.UpdateUserPhoto, param: nil, block: block)
    }
    
    func updateUserInformation(_ params: [String : Any], block : @escaping WSBlock)  {
        //parameters - UserID, FirstName, LastName, Gender, YearOfBirth, NationalityID,
        //CountryID, MobileCountryCode, MobileNumber, Bio, AccountTypeID
        jprint("=======WS =\(kWSDomainURL)\(APIName.UpdatePersonalnfo)=======")
        PUT_REQUEST(APIName.UpdatePersonalnfo, param:params , block: block)
    }
    
    func updateSocialInfo(_ params: [String : Any], block: @escaping WSBlock) {
        //Parameters:- UserID, Whatsapp, Viber, Line, Tango, Telegram, Facebook,
        //Twitter, Snapchat, Instagram
        jprint("=======WS =\(kWSDomainURL)\(APIName.UpdateSocialMedia)=======")
        PUT_REQUEST(APIName.UpdateSocialMedia, param:params, block: block)
    }
    
    func updateUserPreference(_ params: [String : Any], block: @escaping WSBlock) {
        //Parameters:- UserID, IsMobilelShown, IsEmailShown, IsMonitoringAccepted, IsTravelRequestReceiver, IsVisibleInSearch,
        //PreferencesSmoking, PreferencesMusic, PreferencesFood, PreferencesKids, PreferencesPets, PreferencesPrayingStop, 
        //PreferencesQuran, DefaultLanguage, SpokenLanguages
        jprint("=======WS =\(kWSDomainURL)\(APIName.UpdatePreferences)=======")
        PUT_REQUEST(APIName.UpdatePreferences, param:params, block: block)
    }
    
    func forgotPassword(_ params: [String : Any], block: @escaping WSBlock) {
        //http://sawacar.es/api/users/ForgetPassword
        //Parameters : Email
        jprint("=======WS =\(kWSDomainURL)\(APIName.ForgetPassword)=======")
        POST_REQUEST(APIName.ForgetPassword, param:params, block: block)
    }
    
    //Passenger
    func findDrivers(_ params: [String : String], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=FindDrivers&AccountTypeID=1&CountryID=105
        jprint("=======WS = FindDrivers=======")
        let accoutTypeId = params["AccountTypeID"]!
        let countryID = params["CountryID"]!
        _ = GET_REQUEST(urlWithMethod("FindDrivers&AccountTypeID=\(accoutTypeId)&CountryID=\(countryID)"), param: nil, block: block)
    }
}

//===================================================================================================================================
//MARK: Car APIs: AddCar, DeleteCar, UpdateCar, GetUserCars, GetAllCarCompanies
//===================================================================================================================================

extension Webservice {
    func getCarCompanies(_ block: @escaping WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetCarCompanies)=======")
        _ = GET_REQUEST(APIName.GetCarCompanies, param: nil, block: block)
    }
    
    func getCarOfUser( block: @escaping WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.GetUserCars)=======")
        _ = GET_REQUEST(APIName.GetUserCars, param: nil, block: block)
    }

    func addCar(_ params: [String : Any], block: @escaping WSBlock)  {
        //Parameters: UserID, CompanyID, Model, ColorID, Seats, Details, Photo, ProductionYear, Insurance
        jprint("=======WS =\(kWSDomainURL)\(APIName.AddCar)=======")
        POST_REQUEST(APIName.AddCar, param:params, block: block)
    }
    
    func updateCar(_ params: [String : Any], block: @escaping WSBlock)  {
        //Parameters: CarID, UserID, CompanyID, Model, ColorID, Seats, Details, Photo, ProductionYear, Insurance
        jprint("=======WS =\(kWSDomainURL)\(APIName.UpdateCar)=======")
        PUT_REQUEST(APIName.UpdateCar, param:params, block: block)
    }

    func updateCarImage(_ imgData: Data, carId: String, block: @escaping WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.UpdateCarImage)=======")
        uploadImage(imgData, relativepath: (APIName.UpdateCarImage +  carId), param: nil, block: block)
    }
    
    func deleteCar(_ params: [String : Any], block: @escaping WSBlock) {
        jprint("=======WS =\(kWSDomainURL)\(APIName.DeleteCar)=======")
        DELETE_REQUEST(APIName.DeleteCar, param: params, block: block)
    }
    
}

//====================================================================
//MARK: Travel APIs - AddTravel, GetTravel, UpdateTravel, DeleteTravel
//====================================================================

extension Webservice {
    func addTravel(_ params: [String : Any], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=AddTravel
        //Parameters: LocationFrom, LocationTo, DepartureDate, DriverID, CarID, CurrencyID, CarPrice,
        //PassengerPrice, Luggages, Seats, LadiesOnly, Tracking, Details, RepeatType, RepeatEndDate,
        //RoundDate, RoundHour, RoundMinute, DepartureFlexibility
        jprint("=======WS =\(kWSDomainURL)\(APIName.AddTravel)=======")
        POST_REQUEST(APIName.AddTravel, param:params , block: block)
    }
    
    func updateTravel(_ params: [String : Any], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=UpdateTravel
        //Parameters: TravelID, LocationFrom, LocationTo, LocationStop1, LocationStop2, LocationStop3
        //DepartureDate, DepartureHour, DepartureMinute, DriverID, CarID, CurrencyID, CarPrice,
        //PassengerPrice, Luggages, Seats, LadiesOnly, Tracking, Details, RepeatType, RepeatEndDate,
        //RoundDate, RoundHour, RoundMinute, DepartureFlexibility
        jprint("=======WS = UpdateTravel=======")
        POST_REQUEST(urlWithMethod("UpdateTravel"), param:params, block: block)
    }
    
    func getTravels(_ userId: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravels&UserID=39
        jprint("=======WS = GetUserTravels=======")
        _ = GET_REQUEST(urlWithMethod("GetUserTravels&UserID=" + userId), param: nil, block: block)
    }
    
    func getArchivedTravels(_ userId: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserArchivedTravels&UserID=15
        jprint("=======WS = GetUserArchivedTravels=======")
        _ = GET_REQUEST(urlWithMethod("GetUserArchivedTravels&UserID=" + userId), param: nil, block: block)
    }

    func findTravels(_ fromAddress: String, toAddress: String, block: @escaping WSBlock) {
        //https://sawacar.com/Services/Sawacar.ashx?Method=FindTravel&FromAddress=Syria&ToAddress=abc
        jprint("=======WS = FindTravel=======")
         _ = GET_REQUEST(urlWithMethod("FindTravel&FromAddress=\(fromAddress)&ToAddress=\(toAddress)"), param: nil, block: block)
    }
}

//===================================================================================================================================
//MARK: Booking On Travels - APIs - BookTravel, CancelBooking, ApproveBooking, DeclineBooking, GetUserBookings, GetUserTravelBookings
//===================================================================================================================================

extension Webservice {
    
    func bookTravel(_ params: [String: String], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=BookTravel&TravelID=217&UserID=128&Seats=1&AllCar=false
        jprint("=======WS = BookTravel=======")
        let travelId = params["TravelID"]!, userid = params["UserID"]!, seats = params["Seats"]!
        _ = GET_REQUEST(urlWithMethod("BookTravel&TravelID=\(travelId)&UserID=\(userid)&Seats=\(seats)&AllCar=false"), param: nil, block: block)
    }
    
    func cancelBooking(_ bookingId: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=CancelBooking&BookID=14
        jprint("=======WS = CancelBooking=======")
        _ = GET_REQUEST(urlWithMethod("CancelBooking&BookID=" + bookingId), param: nil, block: block)
    }
    
    func approveBooking(_ bookingId: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=ApproveBooking&BookID=14
        jprint("=======WS = ApproveBooking=======")
       _ =  GET_REQUEST(urlWithMethod("ApproveBooking&BookID=" + bookingId), param: nil, block: block)
    }

    func declineBooking(_ bookingId: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=DeclineBooking&BookID=18
        jprint("=======WS = DeclineBooking=======")
        _ = GET_REQUEST(urlWithMethod("DeclineBooking&BookID=" + bookingId), param: nil, block: block)
    }

    func getBookings(forPassanger passangerID: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserBookings&UserID=39
        jprint("=======WS = GetUserBookings for passanger=======")
        _ = GET_REQUEST(urlWithMethod("GetUserBookings&UserID=" + passangerID), param: nil, block: block)

    }
    
    func getBookings(forDriver driverID: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravelBookings&UserID=39
        jprint("=======WS = GetUserTravelBookings for driver=======")
        _ = GET_REQUEST(urlWithMethod("GetUserTravelBookings&UserID=" + driverID), param: nil, block: block)
        
    }
}

//=======================================================================================================================
//MARK: TravelRequest APIs - AddTravelRequest, UpdateTravelRequest, DeleteTravelRequest, GetTravelRequest, GetTravelTypes
//=======================================================================================================================

extension Webservice {
    func addTravelRequest(_ params: [String : Any], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=AddTravelRequest
        //Parameters: LocationFrom, LocationTo, RequesterID, TravelTypeID, CurrencyID, Price
        //DepartureDate, DepartureHour, DepartureMinute, Privacy
        jprint("=======WS = AddTravelRequest=======")
        POST_REQUEST(urlWithMethod("AddTravelRequest"), param:params , block: block)
    }
    
    func updateTravelRequest(_ params: [String : Any], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=UpdateTravelRequest
        //Parameters: TravelOrderID, TravelTypeID, CurrencyID, Price
        //DepartureDate, DepartureHour, DepartureMinute, Privacy
        jprint("=======WS = UpdateTravelRequest=======")
        POST_REQUEST(urlWithMethod("UpdateTravelRequest"), param:params , block: block)
    }

    func getTravelRequest(_ id: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetTravelRequest&TravelRequestID=196
        jprint("=======WS = GetTravelRequest=======")
        _ = GET_REQUEST(urlWithMethod("GetTravelRequest&TravelRequestID=\(id)"), param: nil, block: block)
    }
    
    func getUserTravelRequests(_ block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravelRequests&UserID=153
        jprint("=======WS = GetUserTravelRequests=======")
        _ = GET_REQUEST(urlWithMethod("GetUserTravelRequests&UserID=\(me.Id)"), param: nil, block: block)
    }
    
    func searchTravelRequests(_ searchObj: RideRequestSearchObject, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=FindTravelRequest&CountryID=193&TravelTypeID=1
        jprint("=======WS = FindTravelRequest=======")
        let methodUrl = "FindTravelRequest&CountryID=\(searchObj.countryId)&TravelTypeID=\(searchObj.travelTypeId)"
       _ = GET_REQUEST(urlWithMethod(methodUrl), param: nil, block: block)
    }
    
    func getTravelTypes(_ block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetTravelTypes
        jprint("=======WS = GetTravelTypes=======")
        _ = GET_REQUEST(urlWithMethod("GetTravelTypes"), param: nil, block: block)
        
    }
}

//================================================================================================================================
//MARK: Offer on TravelRequest APIs - AddOffer, ApproveOffer, DeclineOffer, CancelOffer, GetUserOffers, GetUserTravelRequestOffers
//================================================================================================================================

extension Webservice {
    
    func addOfferOnTravelRequest(_ params: [String :  String], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=OfferTravelRequest&TravelRequestID=195&UserID=128&Price=12&OfferDate=07/04/2016
        jprint("=======WS = OfferTravelRequest=======")
//        let tRequestId = params["TravelRequestID"]!; let price = params["Price"]!; let date = params["OfferDate"]!
//        getRequest(urlWithMethod("OfferTravelRequest&TravelRequestID=\(tRequestId)&UserID=\(me.Id)&Price=\(price)&OfferDate=\(date)"), param: nil, block: block)
        _ = GET_REQUEST(urlWithMethod("OfferTravelRequest"), param: params, block: block)

    }
    
    func cancelOffer(_ travelRequestID: String, userID: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=CancelOffer&TravelRequestID=195&UserID=128
        jprint("=======WS = CancelOffer=======")
        _ = GET_REQUEST(urlWithMethod("CancelOffer&TravelRequestID=\(travelRequestID)&UserID=\(userID)"), param: nil, block: block)
    }
    
    func acceptOffer(_ travelRequestID: String, userID: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=ApproveOffer&TravelRequestID=195&UserID=128
        jprint("=======WS = ApproveOffer=======")
        _ = GET_REQUEST(urlWithMethod("ApproveOffer&TravelRequestID=\(travelRequestID)&UserID=\(userID)"), param: nil, block: block)
    }
    
    func rejectOffer(_ travelRequestID: String, userID: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=DeclineOffer&TravelRequestID=195&UserID=128
        jprint("=======WS = DeclineOffer=======")
        _ = GET_REQUEST(urlWithMethod("DeclineOffer&TravelRequestID=\(travelRequestID)&UserID=\(userID)"), param: nil, block: block)
    }
    
    
    func getOffers(forDriver driverId: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserOffers&UserID=295
        jprint("=======WS = GetUserOffers for driver=======")
        _ = GET_REQUEST(urlWithMethod("GetUserOffers&UserID=" + driverId), param: nil, block: block)
    }
    
    func getOffers(forPassenger passengerId: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravelRequestOffers&UserID=295
        jprint("=======WS = GetUserOffers for driver=======")
        _ = GET_REQUEST(urlWithMethod("GetUserTravelRequestOffers&UserID=" + passengerId), param: nil, block: block)
    }
}

//=========================================================================================================
//MARK: Alert APIs - AddTravelAlert, AddTravelRequestAlert, GetUserTravelAlerts, GetUserTravelRequestAlerts
//=========================================================================================================

extension Webservice {
    func addAlertByPassengerOnTravel(_ params : [String : Any], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=AddTravelAlert
        //Parameters : UserID, LocationFrom, LocationTo
        jprint("=======WS = AddTravelAlert=======")
        POST_REQUEST(urlWithMethod("AddTravelAlert"), param:params, block: block)
    }
    
    func addAlertByDriverOnTravelRequest(_ params: [String : Any], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=AddTravelRequestAlert
        //Parameters : UserID, TravelTypeID, CountryID
        jprint("=======WS = AddTravelRequestAlert=======")
        POST_REQUEST(urlWithMethod("AddTravelRequestAlert"), param:params, block: block)
    }
    
    func getAlerts(forPassenger passengerId: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravelAlerts&UserID=39
        jprint("=======WS = GetUserTravelAlerts for passenger=======")
        _ = GET_REQUEST(urlWithMethod("GetUserTravelAlerts&UserID=\(passengerId)"), param: nil, block: block)
    }
    
    func getAlerts(forDriver driverId: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserTravelRequestAlerts&UserID=39
        jprint("=======WS = GetUserTravelRequestAlerts for driver=======")
        _ = GET_REQUEST(urlWithMethod("GetUserTravelRequestAlerts&UserID=\(driverId)"), param: nil, block: block)
    }
}

//============================================================================================
//MARK: Message/Comment APIs -
//============================================================================================

extension Webservice {
    func getInboxMessages(_ params: [String : Any], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetInboxMessages
        jprint("=======WS = GetInboxMessages=======")
        POST_REQUEST(urlWithMethod("GetInboxMessages"), param:params, block: block)
    }
    
    func getContacts(_ params: [String : Any], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetUserContacts
        jprint("=======WS = GetUserContacts=======")
        POST_REQUEST(urlWithMethod("GetUserContacts"), param:params , block: block)
    }
    
    func getMessageWithOtherUser(_ params: [String : Any], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetMessagesFromUser
        jprint("=======WS = GetMessagesFromUser=======")
        POST_REQUEST(urlWithMethod("GetMessagesFromUser"), param:params, block: block)
    }
    
    func sendMessage(_ params: [String : Any], block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=SendNewMessage
        jprint("=======WS = SendNewMessage=======")
        POST_REQUEST(urlWithMethod("SendNewMessage"), param:params, block: block)
    }

}

//============================================================================================
//MARK: Ratings APIs -
//============================================================================================

extension Webservice {
    
    //Api for getting ratings which you have gave for other users and cars.
    func getRatings(byUser userId: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetRatesUserGive&UserID=39
        jprint("=======WS = GetUserTravelRequestAlerts for driver=======")
        _ = GET_REQUEST(urlWithMethod("GetRatesUserGive&UserID=\(userId)"), param: nil, block: block)
    }
    
    //API for getting ratings which you have got from other users.
    func getRatings(forUser userId: String, block: @escaping WSBlock) {
        //http://sawacar.com/Services/Sawacar.ashx?Method=GetRatesUserGot&UserID=39
        jprint("=======WS = GetUserTravelRequestAlerts for driver=======")
        _ = GET_REQUEST(urlWithMethod("GetRatesUserGot&UserID=\(userId)"), param: nil, block: block)
    }
    
    //rate user api
    func rateUser(_ params: [String : AnyObject], block: WSBlock) {
        //Needs api request in httpPost method.
    }
    
    //rate car api
    func rateCar(_ params: [String : AnyObject], block: WSBlock) {
        //Needs api request in httpPost method.
    }
}

//============================================================================================
//MARK: Webservice Inialization and AFNetworking setup
//============================================================================================

class Webservice: NSObject {
    var manager : AFHTTPSessionManager!
    lazy var downloadManager: AFURLSessionManager = AFURLSessionManager()
    
    var succBlock: (_ dataTask :URLSessionDataTask?, _ responseObj :Any?, _ relPath: String, _ block: WSBlock) -> Void
    var errBlock: (_ dataTask :URLSessionDataTask?, _ error :NSError, _ relPath: String, _ block: WSBlock) -> Void
    
    override init() {
        manager = AFHTTPSessionManager(baseURL: URL(string: kWSBaseUrl))
        //manager.requestSerializer = AFJSONRequestSerializer()
        manager.responseSerializer.acceptableContentTypes = Set(["text/html", "text/plain", "application/json"])
        
        
        // Success and Error response block, singletone block for all responses
        succBlock = { (dataTask, responseObj, relPath, block) in
            let response = dataTask?.response! as! HTTPURLResponse
            print("Response Code : \(response.statusCode)")
            print("Response ((\(relPath)): \(responseObj)")
            block(vResponse(success: responseObj), response.statusCode)
        }
        
        errBlock = { (dataTask, error, relPath, block) in
        
            let dat = error.userInfo["com.alamofire.serialization.response.error.data"] as? Data
            if let errData = dat {
                let erInfo =  (try! JSONSerialization.jsonObject(with: errData, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                print("Error - json(\(relPath)): \(erInfo)")
                block(vResponse(error: erInfo) , error.code)
            } else {
                print("Error(\(relPath)): \(error)")
                block(vResponse(error: error) , error.code)
            }
        }
        
        super.init()
        manager.reachabilityManager.setReachabilityStatusChange { (status: AFNetworkReachabilityStatus) -> Void in
            if status == AFNetworkReachabilityStatus.notReachable {
                self.showAlert("No internet".localizedString() as NSString, message: "Your_internet_connection_down".localizedString())
            } else if status == AFNetworkReachabilityStatus.reachableViaWiFi ||
                status == AFNetworkReachabilityStatus.reachableViaWWAN {
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
    func addAccesTokenToHeader(_ token: String){
        manager.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("Token added: \(token)")
    }

    func accessTokenForHeader() -> String? {
        return manager.requestSerializer.value(forHTTPHeaderField: "Authorization")
    }
    
    // MARK: Utility methods
    func isInternetAvailable() -> Bool {
        let bl = manager.reachabilityManager.networkReachabilityStatus != AFNetworkReachabilityStatus.notReachable
        if bl == false {
            self.showAlert("No_internet".localizedString() as NSString, message: "Your_internet_connection_down".localizedString())
        }
        return bl
    }
    
    fileprivate func showAlert(_ title:NSString, message:String) {
        let alert :UIAlertView = UIAlertView(title: title as String, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    // MARK: Private Methods
    fileprivate func POST_REQUEST(_ relativePath: String, param: [String : Any]?, block: @escaping WSBlock) {
        print("Parameters \(param)" )
        manager.post(relativePath, parameters: param, success: { (task, responseObj) -> Void in
            self.succBlock(task, responseObj, relativePath, block)
            }, failure: { (task, error) -> Void in
                //self.errBlock(task, error, relativePath, block)
                self.errBlock(task, error as NSError, relativePath, block)
        })
    }
    
    // MARK: Private Methods
    fileprivate func PUT_REQUEST(_ relativePath: String, param: [String : Any]?, block: @escaping WSBlock) {
        print("Parameters \(param)")
        manager.put(relativePath, parameters: param, success: { (task, responseObj) -> Void in
            self.succBlock(task, responseObj, relativePath, block)
            }, failure: { (task, error) -> Void in
                self.errBlock(task, error as NSError, relativePath, block)
        })
    }

    // MARK: Private Methods
    fileprivate func DELETE_REQUEST(_ relativePath: String, param: [String : Any]?, block: @escaping WSBlock) {
        print("Parameters \(param)" )
        manager.delete(relativePath, parameters: param, success: { (task, responseObj) -> Void in
            self.succBlock(task, responseObj, relativePath, block)
            }, failure: { (task, error) -> Void in
                self.errBlock(task, error as NSError, relativePath, block)
        })
    }

    
    fileprivate func GET_REQUEST(_ relativePath: String, param: [String : Any]?, block: @escaping WSBlock)-> URLSessionDataTask {
        print("Parameters \(param)" )
      return  manager.get(relativePath, parameters: param, success: { (task, responseObj) -> Void in
            self.succBlock(task, responseObj, relativePath, block)
            }, failure:  { (task, error) -> Void in
                self.errBlock(task, error as NSError, relativePath, block)
        })!
    }
    
    fileprivate func uploadImage(_ imgData: Data, relativepath: String, param: [String : Any]?, block: @escaping WSBlock) {
        print("Parameters \(param)" )
        manager.post(relativepath, parameters: param, constructingBodyWith: { (formData) -> Void in
            formData.appendPart(withFileData: imgData, name: "upload", fileName: "image.jpeg", mimeType: "image/jpeg")
            }, success: { (task, responseObj) -> Void in
                self.succBlock(task, responseObj, relativepath, block)
            }, failure:  { (task, error) -> Void in
                self.errBlock( task, error as NSError, relativepath, block)
        })
    }
    
    fileprivate func uploadContacts(_ relativepath: String, param: [String], block: @escaping WSBlock) {
        manager.post(relativepath, parameters: param, constructingBodyWith: { (formData) -> Void in
            for contc in param as [NSString] {
                formData.appendPart(withForm: contc.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!, name: "phonehash[]")
            }
            }, success: { (task, responseObj) -> Void in
                self.succBlock(task, responseObj, relativepath, block)
            }, failure:  { (task, error) -> Void in
                self.errBlock(task, error as NSError, relativepath, block)
        })
    }
}

//MARK: Create WS url with api name
func urlWithMethod(_ method: String) -> String {
    let characterSet = CharacterSet.urlPathAllowed
    let query = method.addingPercentEncoding(withAllowedCharacters: characterSet)!
    let url = kWSBaseUrl + "?Method=" + query
    jprint("Requested url -" + url)
    return url
}

//Structure will be used for manage the ws response.
struct vResponse {
    var isSuccess  = false
    let json: Any?
    var message: String
    
    init(success rJson : Any?) {
        isSuccess = true
        json = rJson
        message = ""

        if let json = rJson as? [String: Any] {
            if let msg = json["Message"] as? String {
                message = msg
            }
        }
    }
    
    init(error rJson : Any?) {
        isSuccess = false
        if let rJson = rJson as? [String : Any] {
            if  let msg = rJson["Message"] as? String {
                message = msg
            } else if let msg = rJson["error_description"] as? String {
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
