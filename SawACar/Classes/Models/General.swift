//
//  Models.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 11/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

//MARK: Language
class Language {
    var id = ""
    var name = ""
    var code = ""
    
    init(_ info : [String : Any]) {
        id = RConverter.string(info["ID"])
        name = RConverter.string(info["Name"])
        code = RConverter.string(info["Code"])
    }
}

//MARK: Country
class Country {
    var Id: String!
    var code: String!
    var dialCode: String!
    var name: String!
    
    init() {
        Id       = ""
        code     = ""
        dialCode = ""
        name     = ""
    }
    
    init(info: [String : Any]) {
        Id       = RConverter.string(info["CountryID"]);
        code     = RConverter.string(info["CountryCode"])
        dialCode = RConverter.string(info["CountryDialCode"])
        name     = RConverter.string(info["CountryName"])
    }
}

//MARK: Currency
class Currency {
    var Id  = ""
    var code = ""
    var name = ""
    var country = ""
    var symbol = ""
    
    init(_ info : [String : Any]) {
        Id      = RConverter.string(info["CurrencyID"])
        code    = RConverter.string(info["Code"])
        name    = RConverter.string(info["Currency"])
        country = RConverter.string(info["Country"])
        symbol  = RConverter.string(info["Symbol"])
    }
    
}


//MARK: AccountType
class AccountType {
    var Id: String
    var name: String

    init() {
        //
        Id = ""
        name = ""
    }

    init(info: [String : Any]) {
        if let _ = info["AccountTypeID"] { //field with user info
            Id = RConverter.string(info["AccountTypeID"])
        } else { //field with acount type List api
            Id = RConverter.string(info["ID"])
        }
        if let _ = info["AccountTypeName"] { //field with user info
            name = RConverter.string(info["AccountTypeName"])
        } else { //field with acount type List api
            name = RConverter.string(info["Name"])
        }
    }
}

//MARK: Company
class Company {
    var Id = ""
    var name = ""
    
    init(_ info: [String : Any]) {
        if let _ = info["CompanyID"] {
            Id = RConverter.string(info["CompanyID"])
        } else {
            Id = RConverter.string(info["ID"])
        }
        
        if let _ = info["CompanyName"] {
            name =  RConverter.string(info["CompanyName"])
        } else {
            name = RConverter.string(info["Name"])
        }
    }
}

//MARK: Color
class Color {
    var Id = ""
    var name = ""
    
    init(_ info: [String : Any]) {
        if let _ = info["ColorID"] {
            Id = RConverter.string(info["ColorID"])
        } else {
            Id = RConverter.string(info["ID"])
        }
        if let _ = info["ColorName"] {
            name =  RConverter.string(info["ColorName"])
        } else {
            name =  RConverter.string(info["Name"])
        }
    }
}

//MARK: VehicleType
class VehicleType {
    var Id: String = ""
    var name: String = ""
    
    init(_ info : [String : Any]) {
        Id = RConverter.string(info["ID"])
        name = RConverter.string(info["Name"])
    }
}

//MARK: TravelType
class TravelType {
    var Id: String!
    var name: String!
    init(_ info: [String : Any]) {
        Id = RConverter.string(info["TravelTypeID"])
        name =  RConverter.string(info["Name"])

//        if let _ = info["TravelTypeName"] {
//            name =  RConverter.string(info["TravelTypeName"])
//        } else {
//            name =  RConverter.string(info["Name"])
//        }
    }
}

//MARK: This class is used for create any menu item
class Menu {
    var Id: String!
    var title: String!
    var imgName: String!
    var selected = false
    var type: MenuType = .none
    init(title: String, imgName: String, selected: Bool  = false, type: MenuType = .none, id: String = "") {
        self.title = title
        self.imgName = imgName
        self.selected = selected
        self.type = type
        self.Id = id
    }
}
enum MenuType {
    case  profile , changePass, socialLink , details, settings, none
}
