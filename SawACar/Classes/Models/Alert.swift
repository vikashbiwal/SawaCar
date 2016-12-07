//
//  Alert.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

class Alert {
    
    var id: String!
    var userId: String!
    var locationFrom: String!
    var locationTo: String!
    
    var countryId: String!
    var countryName: String!
    var travelTypeId: String!
    var travelTypeName: String!
    
    var activated = true
    
    init(_ info: [String : AnyObject]) {
        id           = RConverter.string(info["AlertID"])
        userId       = RConverter.string(info["UserID"])
        activated    = RConverter.boolean(info["Activated"])
        
        //below keys are used for travel alert
        locationFrom = RConverter.string(info["LocationFrom"])
        locationTo   = RConverter.string(info["LocationTo"])
        
        //below keys are used for travel request alert
        travelTypeId    = RConverter.string(info["TravelTypeID"])
        travelTypeName  = RConverter.string(info[""]) // key not getting in response
        countryId       = RConverter.string(info["CountryID"])
        countryName     = RConverter.string(info[""]) // key not getting in response
    }
}
