//
//  SawCarExtendexClassesAndEnums.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 22/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

//Reference Controller - ProfileScreen
enum UserPreferenceType: Int {
    case showEmail, showMobile, visibleInSearch, specialOrder, acceptMonitring
    case communicationLanguage, speackingLanguage
    case children, pets, stopForPray, foodAndDrink, music, quran, smoking
}

class SignupTextField: JPWidthTextField {
    var type: TextFieldType!
}

class SettingSwitch: VkUISwitch {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var type: UserPreferenceType!
}

// --------------------------------------------

//Reference Controller - Add Travel screen
//Enum TravelSteper used for define number of Seat, Passenger, car and etc.
enum TravelPreferenceType {
    case numberOfSeat, passengerPrice, carPrice, numberOfLuggage, tracking, onlyWomen, none
}

//TravelSwitch : used for handle Tracking, and isOnlyWomen value.
class TravelSwitch: VkUISwitch {
    var type: TravelPreferenceType = .none
}

// --------------------------------------------

//Reference Controller - Add Signup / profile Screen
//Do not change order of items
enum TextFieldType: Int {
    case firstName = 101, lastName, email, password, confirmPass, mobileNo, oldPassword
    case nationality, country, accountType, gender, birthDate
    case whatsApp, line, tango, facebook, twitter, telegram
    case none = -1
}





