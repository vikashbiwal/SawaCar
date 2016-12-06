//
//  TravelBooking.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 05/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation


class Booking {
    
    enum  BookingStatus: Int {
        case Pending = 1, Approve, Reject, Cancel
        
        func color()-> UIColor {
            switch self {
            case .Pending:
                return UIColor.scHeaderColor()
            case .Approve:
                return UIColor.greenColor()
            case .Cancel, .Reject:
                return UIColor.redColor()
            }
        }
    }
    
    var id:         String!
    var travelId:   String!
    var seats:      String!
    var userId:     String!
    var userName:   String!
    var userPhoto:  String!
    var locationFrom: String!
    var locationTo: String!
    
    var status : BookingStatus = BookingStatus.Pending
    var allCar : Bool
    var date: NSDate!
    
    init(_ info : [String : AnyObject]) {
        id = RConverter.string(info["BookingID"])
        travelId = RConverter.string(info["TravelID"])
        seats = RConverter.string(info["Seats"])
        userId = RConverter.string(info["UserID"])
        userName = RConverter.string(info["UserName"])
        userPhoto = kWSDomainURL + RConverter.string(info["UserPhoto"])
        
        let statusCode = RConverter.integer(info["Status"])
        status = BookingStatus(rawValue: statusCode)!
        allCar = RConverter.boolean(info["AllCar"])
        let dateString = RConverter.string(info["BookingDate"])
        date = dateFormator.dateFromString(dateString, fomat: "dd/MM/yyyy HH:mm:ss")
        //locationFrom = RConverter.string(info[""])
        //locationTo = RConverter.string(info[""])
    }
    
    //reset info whenever change
    func resetInfo(info: [String : AnyObject]) {
        id = RConverter.string(info["BookingID"])
        travelId = RConverter.string(info["TravelID"])
        seats = RConverter.string(info["Seats"])
        userId = RConverter.string(info["UserID"])
        userName = RConverter.string(info["UserName"])
        userPhoto = kWSDomainURL + RConverter.string(info["UserPhoto"])
        
        let statusCode = RConverter.integer(info["Status"])
        status = BookingStatus(rawValue: statusCode)!
        allCar = RConverter.boolean(info["AllCar"])
        let dateString = RConverter.string(info["BookingDate"])
        date = dateFormator.dateFromString(dateString, fomat: "dd/MM/yyyy HH:mm:ss")
        //locationFrom = RConverter.string(info[""])
        //locationTo = RConverter.string(info[""])
    }
    
}

//MARK: Booking API Calls
extension Booking {
    
    //Cancel Api call
    func cancelAPICall(block: WSBlock) {
        wsCall.cancelBooking(self.id, block: block)
    }
    
    //Approve booking Api call
    func approveAPICall(block: WSBlock) {
        wsCall.approveBooking(self.id, block: block)
    }
    
    //Decline booking Api call
    func rejectAPICall(block: WSBlock) {
        wsCall.declineBooking(self.id, block: block)
    }
}
