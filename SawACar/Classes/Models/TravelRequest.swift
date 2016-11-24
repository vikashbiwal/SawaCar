//
//  RideRequest.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

//TravelRequest object used to create a travel request by passanger
class TravelRequest {
    var id:                  String!
    var number:              String!
    var fromLocation:        GLocation!
    var toLocation :         GLocation!
    var departureDateString: String!
    var departureHour:       String!
    var departureMinute:     String!
    var suggestedPrice :     Int = 0
    var status :             Int = 0
    
    var travelType: TravelType!
    var passanger : Passanger!
    var currency :  Currency?
    
    var offers   = []
    var comments = []
    
    var departureTime : String { return self.departureHour + ":" + self.departureMinute}
    
    func departurDate()-> NSDate? {
        return dateFormator.dateFromString(self.departureDateString, fomat: "dd/MM/yyyy hh:mm:ss")
    }

    init() {
        
    }
    init(_ info: [String : AnyObject]) {
        id                  = RConverter.string(info["TravelRequestID"])
        number              = RConverter.string(info["TravelRequestNumber"])
        departureDateString = RConverter.string(info["DepartureDate"])
        departureHour       = RConverter.string(info["DepartureHour"])
        departureMinute     = RConverter.string(info["DepartureMinute"])
        fromLocation        = GLocation(info["LocationFrom"] as! [String : AnyObject])
        toLocation          = GLocation(info["LocationTo"] as! [String : AnyObject])

        passanger           = Passanger(travelRequester: info)
        currency            = Currency( info)
    }
    
}

//Used to specify the type of travel request
struct TravelType {
    var Id:   String
    var type: String
    
    init(_ info : [String : AnyObject]) {
        Id   = RConverter.string(info["TravelTypeID"])
        type = RConverter.string(info[""])
    }
}
