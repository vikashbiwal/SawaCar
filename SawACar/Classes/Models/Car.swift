//
//  Car.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 24/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation


//MARK: Car Class
class Vehicle: Equatable {
    var id  = ""
    var name = ""
    var userId = ""
    var ownerName = ""
    var ownerPhoto = ""
    var model = ""
    var plateNumber = ""
    var seatCounter:  VCounterRange = (1,1,9)
    var photo = ""
    var productionYear = ""
    var details = ""
    var insurance: Bool = false
    var rating: Int = 0
    var isActive = true
    var company: Company?
    var color: Color?
    var vehicleType: VehicleType!
    
    init() {
        
    }
    
    init(_ info: [String : Any]) {
        id = RConverter.string(info["ID"])
        name = RConverter.string(info["CarName"])
        userId = RConverter.string(info["UserID"])
        model = RConverter.string(info["Model"])
        photo = kWSDomainURL +  RConverter.string(info["Photo"])
        productionYear = RConverter.string(info["ProductionYear"])
        insurance = RConverter.boolean(info["Insurance"])
        rating = RConverter.integer(info["Rating"])
        isActive = RConverter.boolean(info["Active"])
        details = RConverter.string(info["Details"])
        plateNumber = RConverter.string(info["PalleteNumber"])
        
        userId = RConverter.string(info["OwnerID"])
        ownerName = RConverter.string(info["OwnerName"])
        ownerPhoto = kUserImageBaseUrl + RConverter.string(info["OwnerPhoto"])
        
        company = Company(info)
        color = Color(info)
        vehicleType = VehicleType(info)
        
        seatCounter.value = RConverter.integer(info["SeatsNumber"])
        seatCounter.max = seatCounter.value
    }
    
    func setInfo(_ info: [String : Any]) {
        id = RConverter.string(info["ID"])
        name = RConverter.string(info["CarName"])
        userId = RConverter.string(info["UserID"])
        model = RConverter.string(info["Model"])
        photo = kWSDomainURL +  RConverter.string(info["Photo"])
        productionYear = RConverter.string(info["ProductionYear"])
        insurance = RConverter.boolean(info["Insurance"])
        rating = RConverter.integer(info["Rating"])
        isActive = RConverter.boolean(info["Active"])
        details = RConverter.string(info["Details"])
        plateNumber = RConverter.string(info["PalleteNumber"])
        
        userId = RConverter.string(info["OwnerID"])
        ownerName = RConverter.string(info["OwnerName"])
        ownerPhoto = kUserImageBaseUrl + RConverter.string(info["OwnerPhoto"])
        
        company = Company(info)
        color = Color(info)
        vehicleType = VehicleType(info)
        
        seatCounter.value = RConverter.integer(info["SeatsNumber"])
        seatCounter.max = seatCounter.value
    }
    
    class func  CreateCarFromTravel(_ info: [String : Any])-> Vehicle {
        let car = Vehicle()
        car.id = RConverter.string(info["CarID"])
        car.name = RConverter.string(info["CarFullName"])
        car.rating = RConverter.integer(info["CarRating"])
        car.seatCounter.value = RConverter.integer(info["Seats"])
        car.seatCounter.max = car.seatCounter.value
        
        return car
    }
    
    
    //conform Equatable Protocal for Car object
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.id == rhs.id
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

