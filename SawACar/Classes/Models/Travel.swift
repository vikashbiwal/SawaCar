//
//  Travel.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 22/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class Travel: NSObject, NSCopying {
    var inEditMode = false  //for perform update operations
    
    var Id:             String!
    var travelNumber:   String!
    
    var locationFrom:   GLocation?
    var locationTo:     GLocation?
    var locationStop1:  GLocation?
    var locationStop2:  GLocation?
    var locationStop3:  GLocation?
   
    var departureDate = ""
    var departureHour = ""
    var departureMinute = ""
    var departureTime : String { return self.departureHour + ":" + self.departureMinute}
    var repeatType    : Int = 1 // 1 = Day, 2 = Month
    var repeatEndDate = ""
    var roundDate     = ""
    var roundHour     = ""
    var roundMinute   = ""
    var detail: String!
    var departureFelexiblity: Int = 0
    
    var travelLuggage:  VCounterRange = (1, 1, 3)
    var carPrice:        VCounterRange = (0, 0, 0)
    var passengerPrice: VCounterRange = (0, 0, 0)
    var travelSeat:     VCounterRange = (1, 1, 4)
    var seatLeft:Int = 0
    var rating: Int = 0
    
    var car: Car? {
        didSet {
            self.travelSeat.max = car!.seatCounter.value
            self.travelSeat.value = car!.seatCounter.value
        }
    }
    
    var currency: Currency?
    var driver: Driver!
    
    var ladiesOnly      = false
    var trackingEnable  = false
    var isArchived      = false
    var status          = false
    var isRegularTravel = false
    var isRoundTravel   = false
    
    var bookings    = []
    var comments    = []
    var usersRatings = []
    
    func repeateEndDate()-> NSDate? {
        return dateFormator.dateFromString(self.repeatEndDate, fomat: "dd/MM/yyyy hh:mm:ss")
    }
    
    func roundTravelDate()-> NSDate? {
        return dateFormator.dateFromString(self.roundDate, fomat: "dd/MM/yyyy hh:mm:ss")
    }
    
    func departurDate()-> NSDate? {
        return dateFormator.dateFromString(self.departureDate, fomat: "dd/MM/yyyy hh:mm:ss")
    }

    override init() {
        super.init()
    //
    }
    
    //Travel object initialize from json dictionary object getting with API response.
    init (_ info : [String : AnyObject]) {
    
        Id = RConverter.string(info["TravelID"])
        travelNumber = RConverter.string(info["TravelNumber"])
        
        locationFrom =  GLocation(info["LocationFrom"] as! [String : AnyObject])
        locationTo   =  GLocation(info["LocationTo"] as! [String : AnyObject])
        
        if let stop1Info = info["LocationStop1"] as? [String : AnyObject] {
            locationStop1 =  GLocation(stop1Info)
        }
        if let stop2Info = info["LocationStop2"] as? [String : AnyObject] {
            locationStop2 =  GLocation(stop2Info)
        }
        if let stop3Info = info["LocationStop3"] as? [String : AnyObject] {
            locationStop3 =  GLocation(stop3Info)
        }

        departureDate   = RConverter.string(info["DepartureDate"])
        departureHour   = RConverter.string(info["DepartureHour"])
        departureMinute = RConverter.string(info["DepartureMinute"])
        departureFelexiblity = RConverter.integer(info["DepartureFlexibility"])
        
        isRegularTravel = RConverter.boolean(info["IsRegularTravel"])
        repeatType      = RConverter.integer(info["RepeatType"])
        repeatEndDate   = RConverter.string(info["RepeatEndDate"])

        isRoundTravel   = RConverter.boolean(info["IsRoundTravel"])
        roundDate       = RConverter.string(info["RoundDate"])
        roundHour       = RConverter.string(info["RoundHour"])
        roundMinute     = RConverter.string(info["RoundMinute"])
        
        driver      = Driver(info)
        car         = Car.CreateCarFromTravel(info)
        currency    = Currency(info: info)
        
        carPrice.value        = RConverter.integer(info["CarPrice"])
        passengerPrice.value = RConverter.integer(info["PassengerPrice"])
        travelLuggage.value  = RConverter.integer(info["Luggages"])
        travelSeat.value     = RConverter.integer(info["Seats"])
       
        seatLeft             = RConverter.integer(info["SeatsLeft"])
        isArchived           = RConverter.boolean(info["IsArchived"])
        ladiesOnly           = RConverter.boolean(info["LadiesOnly"])
        detail               = RConverter.string(info["Details"])
        status               = RConverter.boolean(info["Status"])
        trackingEnable       = RConverter.boolean(info["Tracking"])
        
    }
    
    //Travel object update or reset info from json dictionary getting by API response.
    func updateInfo(info : [String : AnyObject]) {
        Id = RConverter.string(info["TravelID"])
        travelNumber = RConverter.string(info["TravelNumber"])
        
        locationFrom =  GLocation(info["LocationFrom"] as! [String : AnyObject])
        locationTo   =  GLocation(info["LocationTo"] as! [String : AnyObject])
        
        if let stop1Info = info["LocationStop1"] as? [String : AnyObject] {
            locationStop1 =  GLocation(stop1Info)
        }
        if let stop2Info = info["LocationStop2"] as? [String : AnyObject] {
            locationStop1 =  GLocation(stop2Info)
        }
        if let stop3Info = info["LocationStop3"] as? [String : AnyObject] {
            locationStop1 =  GLocation(stop3Info)
        }
        
        departureDate   = RConverter.string(info["DepartureDate"])
        departureHour   = RConverter.string(info["DepartureHour"])
        departureMinute = RConverter.string(info["DepartureMinute"])
        departureFelexiblity = RConverter.integer(info["DepartureFlexibility"])
        
        isRegularTravel = RConverter.boolean(info["IsRegularTravel"])
        repeatType      = RConverter.integer(info["RepeatType"])
        repeatEndDate   = RConverter.string(info["RepeatEndDate"])
        
        isRoundTravel   = RConverter.boolean(info["IsRoundTravel"])
        roundDate       = RConverter.string(info["RoundDate"])
        roundHour       = RConverter.string(info["RoundHour"])
        roundMinute     = RConverter.string(info["RoundMinute"])
        
        driver      = Driver(info)
        car         = Car.CreateCarFromTravel(info)
        currency    = Currency(info: info)
        
        carPrice.value        = RConverter.integer(info["CarPrice"])
        passengerPrice.value = RConverter.integer(info["PassengerPrice"])
        travelLuggage.value  = RConverter.integer(info["Luggages"])
        travelSeat.value     = RConverter.integer(info["Seats"])
        
        seatLeft             = RConverter.integer(info["SeatsLeft"])
        isArchived           = RConverter.boolean(info["IsArchived"])
        ladiesOnly           = RConverter.boolean(info["LadiesOnly"])
        detail               = RConverter.string(info["Details"])
        status               = RConverter.boolean(info["Status"])
        trackingEnable       = RConverter.boolean(info["Tracking"])
    }
    
    
    //Conform NSCopying protocol by Travel type
     func copyWithZone(zone: NSZone) -> AnyObject {
        let cpTravel = Travel()
        cpTravel.Id = self.Id
        cpTravel.travelNumber = self.travelNumber
        cpTravel.locationFrom = self.locationFrom
        cpTravel.locationTo = self.locationTo
        cpTravel.locationStop1 = self.locationStop1
        cpTravel.locationStop2 = self.locationStop2
        cpTravel.locationStop3 = self.locationStop3
        cpTravel.departureDate = self.departureDate
        cpTravel.departureHour = self.departureHour
        cpTravel.departureMinute = self.departureMinute
        cpTravel.departureFelexiblity = self.departureFelexiblity
        cpTravel.isRegularTravel = self.isRegularTravel
        cpTravel.isRoundTravel = self.isRoundTravel
        cpTravel.repeatType = self.repeatType
        cpTravel.repeatEndDate = self.repeatEndDate
        cpTravel.roundDate = self.roundDate
        cpTravel.roundHour = self.roundHour
        cpTravel.roundMinute = self.roundMinute
        cpTravel.driver = self.driver
        cpTravel.car = self.car
        cpTravel.currency = self.currency
        cpTravel.carPrice = self.carPrice
        cpTravel.passengerPrice = self.passengerPrice
        cpTravel.travelLuggage = self.travelLuggage
        cpTravel.travelSeat = self.travelSeat
        cpTravel.seatLeft = self.seatLeft
        cpTravel.isArchived = self.isArchived
        cpTravel.ladiesOnly = self.ladiesOnly
        cpTravel.detail = self.detail
        cpTravel.status = self.status
        cpTravel.trackingEnable = self.trackingEnable
        return cpTravel
    }
    
} //Travel End


//MARK: Travel API Related paramenters
extension Travel {
    
    //Add new travel api parameters
    func travelAPIParameters() ->[String : AnyObject] {
        var parameters = [String : AnyObject]()
        if inEditMode {
            parameters["TravelID"] = self.Id
        }
        let fromLocation = ["Latitude" : self.locationFrom!.lat.ToString(),
                            "Longitude" : self.locationFrom!.long.ToString(),
                            "Address" : self.locationFrom!.address]
        let toLocation = ["Latitude" : self.locationTo!.lat.ToString(),
                          "Longitude" : self.locationTo!.long.ToString(),
                          "Address" : self.locationTo!.address]
        
        parameters["LocationFrom"]      = fromLocation
        parameters["LocationTo"]        = toLocation
        parameters["DepartureDate"]     = self.departureDate
        parameters["DepartureHour"]     = self.departureHour
        parameters["DepartureMinute"]   = self.departureMinute
        parameters["Tracking"]          = self.trackingEnable
        parameters["LadiesOnly"]        = self.ladiesOnly
        parameters["Seats"]             = self.travelSeat.value.ToString()
        parameters["Luggages"]          = self.travelLuggage.value.ToString()
        parameters["PassengerPrice"]    = self.passengerPrice.value.ToString()
        parameters["CarPrice"]          = self.carPrice.value.ToString()
        parameters["CarID"]             = self.car!.id
        parameters["DriverID"]          = me.Id
        parameters["CurrencyID"]        = self.currency!.Id
        
        parameters["Details"]           = ""
        parameters["DepartureFlexibility"] = "15"
        
        if self.isRegularTravel {
            parameters["RepeatType"]    = self.repeatType.ToString()
            parameters["RepeatEndDate"] = self.repeatEndDate
        } else {
            parameters["RepeatType"]    = NSNull()
            parameters["RepeatEndDate"] = NSNull()
        }
        
        if self.isRoundTravel {
            parameters["RoundDate"]     = self.roundDate
            parameters["RoundHour"]     = self.roundHour
            parameters["RoundMinute"]   = self.roundMinute
        } else {
            parameters["RoundDate"]     = NSNull()
            parameters["RoundHour"]     = NSNull()
            parameters["RoundMinute"]   = NSNull()
        }
        
        if let stop1 = self.locationStop1 {
            let LocationStop1 = ["Latitude" : stop1.lat.ToString(),
                                 "Longitude": stop1.long.ToString(),
                                 "Address"  : stop1.address]
            parameters["LocationStop1"] = LocationStop1
        } else {
            parameters["LocationStop1"] = NSNull()
        }
        
        if let stop2 = self.locationStop2 {
            let LocationStop2 = ["Latitude" : stop2.lat.ToString(),
                                 "Longitude": stop2.long.ToString(),
                                 "Address"  : stop2.address]
            parameters["LocationStop2"] = LocationStop2
        }  else {
            parameters["LocationStop2"] = NSNull()
        }
        
        if let stop3 = self.locationStop3 {
            let LocationStop3 = ["Latitude" : stop3.lat.ToString(),
                                 "Longitude": stop3.long.ToString(),
                                 "Address"  : stop3.address]
            parameters["LocationStop3"] = LocationStop3
        }  else {
            parameters["LocationStop3"] = NSNull()
        }
        
        return parameters
    }
    
}


//MARK: Car Class
class Car: Equatable {
    var id:String!
    var name: String!
    var userId: String!
    var model: String!
    var plateNumber: String!
    var seatCounter: VCounterRange = (1,1,9)
    var photo: String!
    var productionYear: String!
    var details: String!
    var insurance: Bool = false
    var rating: Int = 0
    var isActive = true
    var company: Company?
    var color: Color?
    
    init() {
    //code here
        id = ""
        name = ""
        userId = ""
        model = ""
        productionYear = ""
        photo = kWSDomainURL
        details = ""
        
    }
    
    init(_ info: [String : AnyObject]) {
        id = RConverter.string(info["CarID"])
        name = RConverter.string(info["CarName"])
        userId = RConverter.string(info["UserID"])
        model = RConverter.string(info["Model"])
        photo = kWSDomainURL +  RConverter.string(info["Photo"])
        productionYear = RConverter.string(info["ProductionYear"])
        insurance = RConverter.boolean(info["Insurance"])
        rating = RConverter.integer(info["Rating"])
        isActive = RConverter.boolean(info["Active"])
        details = RConverter.string(info["Details"])
        company = Company(info)
        color = Color(info)
        seatCounter.value = RConverter.integer(info["Seats"])
        seatCounter.max = seatCounter.value

    }
    
    func setInfo(info: [String : AnyObject]) {
        id = RConverter.string(info["CarID"])
        name = RConverter.string(info["CarName"])
        userId = RConverter.string(info["UserID"])
        model = RConverter.string(info["Model"])
        photo = kWSDomainURL +  RConverter.string(info["Photo"])
        productionYear = RConverter.string(info["ProductionYear"])
        insurance = RConverter.boolean(info["Insurance"])
        rating = RConverter.integer(info["Rating"])
        isActive = RConverter.boolean(info["Active"])
        details = RConverter.string(info["Details"])
        company = Company(info)
        color = Color(info)
        seatCounter.value = RConverter.integer(info["Seats"])
        seatCounter.max = seatCounter.value
    }
    
    class func  CreateCarFromTravel(info: [String : AnyObject])-> Car {
        let car = Car()
        car.id = RConverter.string(info["CarID"])
        car.name = RConverter.string(info["CarFullName"])
        car.rating = RConverter.integer(info["CarRating"])
        return car
    }
}

//conform Equatable Protocal for Car object
func ==(lhs: Car, rhs: Car) -> Bool {
    return lhs.id == rhs.id
}
