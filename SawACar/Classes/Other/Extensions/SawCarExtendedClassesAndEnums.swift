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
    case ShowEmail, ShowMobile, VisibleInSearch, SpecialOrder, AcceptMonitring
    case CommunicationLanguage, SpeackingLanguage
    case Children, Pets, StopForPray, FoodAndDrink, Music, Quran, Smoking
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
    case NumberOfSeat, PassengerPrice, CarPrice, NumberOfLuggage, Tracking, OnlyWomen, None
}

//TravelSwitch : used for handle Tracking, and isOnlyWomen value.
class TravelSwitch: VkUISwitch {
    var type: TravelPreferenceType = .None
}

// --------------------------------------------

//Reference Controller - Add Signup / profile Screen
//Do not change order of items
enum TextFieldType: Int {
    case FirstName = 101, LastName, Email, Password, ConfirmPass, MobileNo, OldPassword
    case Nationality, Country, AccountType, Gender, BirthDate
    case WhatsApp, Line, Tango, Facebook, Twitter, Telegram
    case None = -1
}





