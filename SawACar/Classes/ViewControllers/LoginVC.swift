//
//  ViewController.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 11/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginVC: ParentVC {
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtpassword: UITextField!
    let user: User = {return User()}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func viewDidAppear(animated: Bool) {
        setViewContainerSize()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: IBActions
extension LoginVC {
    @IBAction func signUpBtnClicked(sender: UIButton) {
        self.performSegueWithIdentifier("SBSegue_SignUP", sender: nil)
    }
    
    @IBAction func loginBtnclicked(sender: UIButton) {
        self.loginWithEmailWS()
    }
    
    @IBAction func loginWithFacebookBtnClicked(sender: UIButton) {
        self.loginWithFacebook()
    }
}

//MARK: WS call
extension LoginVC {
    
    //MARK: Login with email
    func loginWithEmailWS()  {
        user.email = txtEmail.text
        user.password = txtpassword.text!
        let process = user.validateLoginProcess()
        if process.isValid {
            user.login({ (response, flag) in
                if response.isSuccess {
                    me = User(json: response.json! as! [String : AnyObject])
                    //navigate to home now.
                } else {
                    self.showAlert(response.message, title: "Login Error")
                }
            })
        } else {
            self.showAlert(process.msg, title: "Login Error")
        }
    }
    
    //MARK: Login With Facebook
    func loginWithFacebook() {
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        fbManager.logInWithReadPermissions(_fbLoginReadPermissions, fromViewController: self) { (result, error) in
            if let  _ =  error {
                //login error
            } else if result.isCancelled {
                //cancel
            } else {
                //succes
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : _fbUserInfoRequestParam])
                request.startWithCompletionHandler({ (con, result, error) in
                    print(result)
                    self.loginWithFacebookWSCall(result as! [String : AnyObject])
                })
            }
        }
    }
    
    func loginWithFacebookWSCall(fbInfo : [String : AnyObject])  {
        print(fbInfo)
        let gender = fbInfo["gender"] as! String == "male" ? true : false
        let params: [String : AnyObject] = ["FacebookID" : fbInfo["id"] as! String,
                      "Email" : fbInfo["email"] as! String,
                      "FirstName" : fbInfo["first_name"] as! String,
                      "LastName" : fbInfo["last_name"] as! String,
                      "Gender" : gender]
        //fbInfo["gender"] as! String
        wsCall.loginWithFacebook(params) { (response, statusCode) in
            if response.isSuccess {
                me = User(json: response.json as! [String : AnyObject])
                //Navigate to home
                
            } else {
                self.showAlert(response.message, title: "Login Error");
            }
        }
    }
    
}

//MARK: Other
extension LoginVC {
    //Validate email login process
    func validateEmailLogin() -> Bool {
        let alertTitle = "Login Error"
        if txtEmail.text!.isEmpty {
            showAlert("Please enter email.", title: alertTitle)
            return false
        } else {
            if !txtEmail.text!.isValidEmailAddress() {
                showAlert("Please enter a valid email address.", title: alertTitle)
                return false
            }
        }
        if txtpassword.text!.isEmpty {
            showAlert("Please enter your password.", title: alertTitle)
            return false
        }
        return  true
    }
    
}

