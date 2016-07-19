//
//  Travel.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 22/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class Travel {
    var Id: String!
    var locationFrom:   FullAddress?
    var locationTo:     FullAddress?
    var locationStop1:  FullAddress?
    var locationStop2:  FullAddress?
    var locationStop3:  FullAddress?
   
    var departureDate : String!
    var departureHour : String!
    var departureMinute:String!
    var repeatType    : Int!
    var repeatEndDate : String!
    var roundDate     : String!
    var roundHour     : String!
    var roundMinute   : String!
    
    var departureFelexiblity: String!
    var driverId: String!
    var carId:    String!
    var currency: Currency?
    var travelLuggage:  VCounterRange = (1, 1, 3)
    var travelSeat:     VCounterRange = (1, 1, 4)
    var carPice:        VCounterRange = (0, 0, 0)
    var passengerPrice: VCounterRange = (0, 0, 0)
    var ladiesOnly = false
    var trackingEnable = false
    var detail: String!
}


class Car {
    var id:String!
    var name: String!
    var userId: String!
    var model: String!
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
        seatCounter.value = RConverter.integer(info["Seats"])
        photo = kWSDomainURL +  RConverter.string(info["Photo"])
        productionYear = RConverter.string(info["ProductionYear"])
        insurance = RConverter.boolean(info["Insurance"])
        rating = RConverter.integer(info["Rating"])
        isActive = RConverter.boolean(info["Active"])
        details = RConverter.string(info["Details"])
        company = Company(info)
        color = Color(info)
    }
    
    func setInfo(info: [String : AnyObject]) {
        id = RConverter.string(info["CarID"])
        name = RConverter.string(info["CarName"])
        userId = RConverter.string(info["UserID"])
        model = RConverter.string(info["Model"])
        seatCounter.value = RConverter.integer(info["Seats"])
        photo = kWSDomainURL +  RConverter.string(info["Photo"])
        productionYear = RConverter.string(info["ProductionYear"])
        insurance = RConverter.boolean(info["Insurance"])
        rating = RConverter.integer(info["Rating"])
        isActive = RConverter.boolean(info["Active"])
        details = RConverter.string(info["Details"])
        company = Company(info)
        color = Color(info)
    }
}