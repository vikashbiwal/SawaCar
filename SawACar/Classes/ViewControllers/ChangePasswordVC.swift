//
//  ChangePasswordVC.swift
//  SawACar
//  Created by Vikash Prajapati
//  Created by Yudiz Solutions Pvt. Ltd. on 20/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class ChangePasswordVC: ParentVC {
    
    //MARK: IBOutlets
    @IBOutlet var txtOldPass : UITextField!
    @IBOutlet var txtNewPass : UITextField!
    @IBOutlet var txtConfPass : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction
    @IBAction func clickedAtSaveBtn(sender: UIButton) {
        self.changePasswordWSCall()
    }
    
    //MARK: Validate user input info
    func validateProcess() -> Bool {
        let alertTitle = "Login Error"
       
        if txtOldPass.text!.isEmpty {
            showAlert("Please enter your old password.", title: alertTitle)
            return false
        }
        
        if txtNewPass.text!.isEmpty {
            showAlert("Please enter your new password.", title: alertTitle)
            return false
        }
        
        if txtConfPass.text!.isEmpty {
            showAlert("Please enter password for confirmation.", title: alertTitle)
            return false
        } else {
            if txtConfPass.text != txtNewPass.text {
                showAlert("Password is not matched.", title: alertTitle)
                return false
            }
        }
        return  true
    }
    
    //MARK: WebService call
    func changePasswordWSCall()  {
        if validateProcess() {
            let params = ["Email": "vikash@gmail.com",//me.email!,
                          "OldPassword": txtOldPass.text!,
                          "NewPassword": txtNewPass.text!]
            wsCall.changePassword(params, block: { (response, statusCode) in
                if statusCode == 200 {
                    if response.isSuccess {
                        // success code
                    } else {
                        //error message
                    }
                } else {
                    self.showAlert("Server error.", title: "Error")
                }
            })
        }
    }
}
