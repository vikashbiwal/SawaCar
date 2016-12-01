//
//  TravelRequestOffer.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 30/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

class TravelRequestOffer {
    
    enum TravelRequestOfferStatus: Int {
        case Pending = 1, Accepted, Declined, Cancel, None = 0
    }
    
    var id:             String
    var dateString:     String
    var price:          String
    var travelOrderID:  String
    var userID:         String
    var userName:       String
    var userPhoto:      String
    var status:         TravelRequestOfferStatus
 
    var date: NSDate? {return dateFormator.dateFromString(dateString, fomat: "dd/MM/yyyy HH:mm:ss")}
    
    init(_ info : [String : AnyObject]) {
        id          = RConverter.string(info["OfferID"])
        dateString  = RConverter.string(info["OfferDate"])
        price       = RConverter.string(info["Price"])
        travelOrderID = RConverter.string(info["TravelOrderID"])
       
        userID      = RConverter.string(info["UserID"])
        userName    = RConverter.string(info["UserName"])
        userPhoto   = kWSDomainURL + RConverter.string(info["UserPhoto"])
        
        let statusValue = RConverter.integer(info["Status"])
        status = TravelRequestOfferStatus(rawValue: statusValue)!
    }
    
}

//MARK: API Calls
extension TravelRequestOffer {
    
    //Cancel offer by the driver which added on the travel request
    func cancelOffer(travelRequestID: String, block: WSBlock) {
        wsCall.cancelOffer(travelRequestID, userID: me.Id, block: block)
    }
    
    //Accept offer by the passanger on the travel request
    func acceptOffer(travelRequestId: String, block: WSBlock) {
        wsCall.acceptOffer(travelRequestId, userID: me.Id, block: block)
    }
    
    //Reject offer. Api should be call by the passanger
    func rejectOffer(travelRequestId: String, block: WSBlock) {
        wsCall.rejectOffer(travelRequestId, userID: self.userID, block: block)
    }
}
