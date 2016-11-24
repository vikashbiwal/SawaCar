//
//  Car.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 24/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation


//MARK: Car Class
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
        car.seatCounter.value = RConverter.integer(info["Seats"])
        car.seatCounter.max = car.seatCounter.value
        
        return car
    }
    
    
    
    // func for validate add or edit car process
    func validateAddCarProcess()-> (isValid: Bool, message: String) {
        guard let _ = company else {
            return (false, "kCarCompanyRequired".localizedString())
        }
        
        if model.isEmpty {
            return (false, "kCarModelRequired".localizedString())
        }
        
        if productionYear.isEmpty {
            return (false, "kCarProductionYearRequired".localizedString())
        }
        
        guard let _ = color else {
            return (false, "kCarColorRequired".localizedString())
        }
        
        if details.isEmpty {
            return (false, "kCarDetailRequired".localizedString())
        }
        
        if plateNumber.isEmpty {
            return (false, "kCarPlateNumberRequired".localizedString())
        }
        
        return (true, "Success".localizedString())
    }
    
}

//conform Equatable Protocal for Car object
func ==(lhs: Car, rhs: Car) -> Bool {
    return lhs.id == rhs.id
}
