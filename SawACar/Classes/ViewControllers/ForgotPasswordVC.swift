//
//  ForgotPassword.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 30/08/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class ForgotPasswordVC: ParentVC {

    @IBOutlet var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: IBActions
    @IBAction func submitBtnClicked(sender: UIButton) {
        if validate() {
            forgotPasswordApiCall()
        }
    }
    
    //MARK: Validation
    func validate()-> Bool {
        let email = txtEmail.text!.trimmedString()
        if email.isEmpty {
            showToastErrorMessage("", message: kEmailIsRequired)
            txtEmail.text = ""
            return false
        } else {
            if !email.isValidEmailAddress() {
                showToastErrorMessage("", message: kEmailValidateMsg)
                return false
            }
        }
        return true
    }
}

//MARK: UITextfield delegate
extension ForgotPasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return txtEmail.resignFirstResponder()
    }
}

//MARK: API Calls
extension ForgotPasswordVC {

    func forgotPasswordApiCall() {
        let email = txtEmail.text!.trimmedString()
        let params = ["Email" : email]
        wsCall.forgotPassword(params) { (response, flag) in
            if response.isSuccess {
                showToastMessage("", message: "Reset password link sent to your email address.")
                self.txtEmail.text = ""
            } else {
                showToastErrorMessage("", message: response.message!)
            }
        }
    }
    
}