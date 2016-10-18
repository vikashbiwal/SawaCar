//
//  Travel.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 22/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class Travel: NSObject, NSCopying {
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
        let aa = Travel()
        aa.Id = self.Id
        aa.travelNumber = self.travelNumber
        aa.locationFrom = self.locationFrom
        aa.locationTo = self.locationTo
        aa.locationStop1 = self.locationStop1
        aa.locationStop2 = self.locationStop2
        aa.locationStop3 = self.locationStop3
        aa.departureDate = self.departureDate
        aa.departureHour = self.departureHour
        aa.departureMinute = self.departureMinute
        aa.departureFelexiblity = self.departureFelexiblity
        aa.isRegularTravel = self.isRegularTravel
        aa.isRoundTravel = self.isRoundTravel
        aa.repeatType = self.repeatType
        aa.repeatEndDate = self.repeatEndDate
        aa.roundDate = self.roundDate
        aa.roundHour = self.roundHour
        aa.roundMinute = self.roundMinute
        aa.driver = self.driver
        aa.car = self.car
        aa.currency = self.currency
        aa.carPrice = self.carPrice
        aa.passengerPrice = self.passengerPrice
        aa.travelLuggage = self.travelLuggage
        aa.travelSeat = self.travelSeat
        aa.seatLeft = self.seatLeft
        aa.isArchived = self.isArchived
        aa.ladiesOnly = self.ladiesOnly
        aa.detail = self.detail
        aa.status = self.status
        aa.trackingEnable = self.trackingEnable
        return aa
    }
}


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
