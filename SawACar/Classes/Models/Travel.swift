//
//  Travel.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 22/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class Travel {
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
    var carPice:        VCounterRange = (0, 0, 0)
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
    
    init() {
    
    }
    
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
        roundDate       = RConverter.string(info["RoundMinute"])
        
        driver      = Driver(info)
        car         = Car.CreateCarFromTravel(info)
        currency    = Currency(info: info)
        
        carPice.value        = RConverter.integer(info["CarPrice"])
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
    
    //update travel info
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
        roundDate       = RConverter.string(info["RoundMinute"])
        
        driver      = Driver(info)
        car         = Car.CreateCarFromTravel(info)
        currency    = Currency(info: info)
        
        carPice.value        = RConverter.integer(info["CarPrice"])
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
