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
    var departureDateString: String! = ""
    var departureHour:       String! = ""
    var departureMinute:     String! = ""
    var suggestedPrice :     Int = 0
    var status :             Int = 0
    
    var travelType: TravelType!
    var passanger : Passanger!
    var currency :  Currency?
    
    var offers   = [TravelRequestOffer]()
    var comments = []
    
    var departureTime : String { return self.departureHour + ":" + self.departureMinute + ":00"}
    
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
        suggestedPrice      = RConverter.integer(info["Price"])
        fromLocation        = GLocation(info["LocationFrom"] as! [String : AnyObject])
        toLocation          = GLocation(info["LocationTo"] as! [String : AnyObject])
        passanger           = Passanger(travelRequester: info)
        currency            = Currency( info)
       
        if let jsonOffers = info["Offers"] as? [[String : AnyObject]] {
            for jOffer in jsonOffers {
                let offer = TravelRequestOffer(jOffer)
                self.offers.append(offer)
            }
        }
    }
    
    func reset(withInfo info : [String : AnyObject]) {
        id                  = RConverter.string(info["TravelRequestID"])
        number              = RConverter.string(info["TravelRequestNumber"])
        departureDateString = RConverter.string(info["DepartureDate"])
        departureHour       = RConverter.string(info["DepartureHour"])
        departureMinute     = RConverter.string(info["DepartureMinute"])
        fromLocation        = GLocation(info["LocationFrom"] as! [String : AnyObject])
        toLocation          = GLocation(info["LocationTo"] as! [String : AnyObject])
        
        passanger           = Passanger(travelRequester: info)
        currency            = Currency( info)
        
        //offers
        if let jsonOffers = info["Offers"] as? [[String : AnyObject]] {
            for jOffer in jsonOffers {
                let offer = TravelRequestOffer(jOffer)
                self.offers.append(offer)
            }
        }

    }
}

//API calls
extension TravelRequest {
    
    //Class func - Get travel details api call
    class func getTravelRequestDetailAPICall(id: String, block: WSBlock) {
        wsCall.getTravelRequest(id, block: block)
    }
    
    //Add travel request api call
    func addTravelRequestAPICall(block: WSBlock) {
        let params = self.parametersForAddTravelRequestAPI()
        wsCall.addTravelRequest(params, block: block)
    }
    
    func updateTravelRequestAPICall(block: WSBlock) {
        
    }
    
    
    //Add an offer (by the driver)
    func addOffer(travelRequestID: String, price: String, date: String, block: WSBlock) {
        let params = ["TravelRequestID" : travelRequestID, "Price": price, "OfferDate": date]
        wsCall.addOfferOnTravelRequest(params, block: block)
    }

    //func return json paramters for add travel request API.
    func parametersForAddTravelRequestAPI() -> [String : AnyObject] {
        var params : [String : AnyObject]
        params = ["RequesterID"     : me.Id,
                  "TravelTypeID"    : self.travelType.Id,
                  "CurrencyID"      : self.currency!.Id,
                  "Price"           : self.suggestedPrice.ToString(),
                  "DepartureDate"   : dateFormator.stringFromDate(departurDate()!, format: "dd/MM/yyyy"),
                  "DepartureHour"   : self.departureHour,
                  "DepartureMinute" : self.departureMinute,
                  "Privacy"         : 1]
        
        let locationFrom = ["Latitude"  : fromLocation.lat.ToString(),
                            "Longitude" : fromLocation.long.ToString(),
                            "Address"   : fromLocation.address]
        
        let locationTo   = ["Latitude"    : toLocation.lat.ToString(),
                            "Longitude"   : toLocation.long.ToString(),
                            "Address"     : toLocation.address]
        
        params["LocationFrom"] = locationFrom
        params["LocationTo"]   = locationTo
        
        return params
    }
    
}

extension TravelRequest {
    //Validate Add Travel Request process
    func validateAddRequestProcess() -> (isSucss: Bool, message: String) {
        guard let _ =  departurDate() else {
            return (false, "RideDateRequired".localizedString())
        }
        guard !departureHour.isEmpty else {
            return (false, "RideTimeRequired".localizedString())
        }
        guard let _ = currency else {
            return (false, "select_Currency_for_Ride".localizedString())
        }
        
        guard suggestedPrice != 0 else {
            return (false, "AddYourSuggestedPrice".localizedString())
        }
        
        guard let _ = travelType else {
            return (false, "TravelTypeRequired".localizedString())
        }
        
        return (true, "Success".localizedString())
    }
}
