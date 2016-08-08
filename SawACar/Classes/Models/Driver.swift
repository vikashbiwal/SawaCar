//
//  Driver.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 08/08/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class Driver  {
    var id: String!
    var name: String!
    var photoURl : String!
    var rating: Float = 0.0
    var rules  = [String]()
    
    init() {
     //
    }
    
    init(_ info: [String : AnyObject]) {
        id = RConverter.string(info["DriverID"])
        name = RConverter.string(info["DriverFullName"])
        photoURl = kWSDomainURL + RConverter.string(info["DriverPhoto"])
        rating = RConverter.float(info["DriverRating"])
        rules = info["DriverRules"] as! [String]
    }
}
