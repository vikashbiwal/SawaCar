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
    var departureDate:  String!
    var departureHour:  String!
    var departureMinute:String!
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
