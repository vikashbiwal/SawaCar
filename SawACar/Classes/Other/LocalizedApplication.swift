//
//  LocalizedApplication.swift
//  SawACar
//
//  Created by Vikash Kumar. on 30/05/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import Foundation

class LocalizedApplication: UIApplication {
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        // ... dispatch the message...
    }
    
    override internal var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        get {
            let currentLang = Locale.preferredLanguages[0]
            //print(currentLang)
            if currentLang.hasPrefix("ar") {
                return UIUserInterfaceLayoutDirection.rightToLeft;
            } else {
                return UIUserInterfaceLayoutDirection.leftToRight;
            }
        }
    }
}
