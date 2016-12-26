//
//  Popups.swift
//
//  Created by Tom Swindell on 25/05/2015.
//  Copyright (c) 2015 Tom Swindell. All rights reserved.
//

import Foundation
import UIKit

class Popups {
    
    private static let SharedInstance = Popups()
    
    // MARK: - Variables
    var alertComletion : ((String) -> Void)!
    var alertButtons : [String]!

    
    // MARK - func
    func ShowAlert(_ sender: UIViewController, title: String, message: String, buttons : [String], completion: ((_ buttonPressed: String) -> Void)?) {
        if(UIDevice.isAtLeastiOSVersion("8.0")) {
            let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for b in buttons {
                
                alertView.addAction(UIAlertAction(title: b, style: UIAlertActionStyle.default, handler: {
                    (action : UIAlertAction) -> Void in
                    completion!(action.title!)
                }))
            }
            sender.present(alertView, animated: true, completion: nil)
        } else {
            self.alertComletion = completion
            self.alertButtons = buttons
            let alertView  = UIAlertView()
            alertView.delegate = self
            alertView.title = title
            alertView.message = message
            for b in buttons {
                alertView.addButton(withTitle: b)
            }
            alertView.show()
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(self.alertComletion != nil) {
            self.alertComletion!(self.alertButtons[buttonIndex])
        }
    }
    
    func ShowPopup(_ title : String, message : String) {
        let alert: UIAlertView = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButton(withTitle: "Ok")
        alert.show()
    }
}
