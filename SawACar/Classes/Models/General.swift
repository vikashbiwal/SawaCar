//
//  Models.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 11/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

//MARK: Country
class Country {
    var Id: String!
    var code: String!
    var dialCode: String!
    var name: String!
    
    init(info: [String : AnyObject]) {
        Id = RConverter.string(info["CountryID"]);
        code = RConverter.string(info["CountryCode"])
        dialCode = RConverter.string(info["CountryDialCode"])
        name = RConverter.string(info["CountryName"])
    }
}

//MARK: Currency
class Currency {
    var Id : String!
    var code: String!
    var name: String!
    var country: String!
    var symbol: String!
    
    init(info : [String : AnyObject]) {
        Id      = RConverter.string(info["CurrencyID"])
        code    = RConverter.string(info["CurrencyCode"])
        name    = RConverter.string(info["CurrencyName"])
        country = RConverter.string(info["CurrencyCountry"])
        symbol  = RConverter.string(info["CurrencySymbol"])
    }
    
}


//MARKL: AccountType
class AccountType {
    var Id: String
    var name: String
    
    init(info: [String : AnyObject]) {
        Id = RConverter.string(info["AccountTypeID"])
        name = RConverter.string(info["Name"])
    }
}

//MARK: This class is used for create any menu item
class Menu {
    var Id: String!
    var title: String!
    var imgName: String!
    var selected = false
    var type: MenuType = .None
    init(title: String, imgName: String, selected: Bool  = false, type: MenuType = .None, id: String = "") {
        self.title = title
        self.imgName = imgName
        self.selected = selected
        self.type = type
        self.Id = id
    }
}
enum MenuType {
    case  Profile , ChangePass, SocialLink , Details, Settings, None
}
