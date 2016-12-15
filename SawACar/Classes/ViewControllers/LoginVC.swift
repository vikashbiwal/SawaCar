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
    var profileImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func viewDidAppear(animated: Bool) {
        //Add Keybaord observeration
        _defaultCenter.addObserver(self, selector: #selector(SignUpVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        _defaultCenter.addObserver(self, selector: #selector(SignUpVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        _defaultCenter.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: IBActions
extension LoginVC {
    @IBAction func signUpBtnClicked(sender: UIButton?) {
        self.performSegueWithIdentifier("SBSegue_SignUP", sender: nil)
    }
    
    @IBAction func loginBtnclicked(sender: UIButton?) {
        self.loginWithEmailWS()
    }
    
    @IBAction func loginWithFacebookBtnClicked(sender: UIButton?) {
        self.loginWithFacebook()
    }
}


//MARK: Notifications
extension LoginVC {
    //Keyboard Notifications
    func keyboardWillShow(nf: NSNotification)  {
        let userinfo = nf.userInfo!
        if let keyboarFrame = (userinfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:keyboarFrame.size.height , right: 0)
        }
    }
    
    func keyboardWillHide(nf: NSNotification)  {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:0 , right: 0)
    }
    
}

//MARK: UITextfield delegate
extension LoginVC {
    override func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === txtEmail {
            txtpassword.becomeFirstResponder()
        } else {
         self.loginBtnclicked(nil)
            txtpassword.resignFirstResponder()
        }
        return true
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
            self.showCentralGraySpinner()
            user.login({ (response, flag) in
                if response.isSuccess {
                    if let json = response.json {
                        let info = json["Object"] as! [String : AnyObject]
                        me = User(info: info)
                        archiveObject(info, key: kLoggedInUserKey)
                        self.performSegueWithIdentifier("SBSegueToUserType", sender: nil)
                    } else {
                        showToastErrorMessage("Login Error", message: response.message!)
                    }
                } else {
                    showToastErrorMessage("Login Error", message: response.message!)
                }
                self.hideCentralGraySpinner()
            })
        } else {
            showToastErrorMessage("Login Error", message: process.msg)
        }
    }
    
    //MARK: Login With Facebook
    func loginWithFacebook() {
        self.showCentralGraySpinner()
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        fbManager.logInWithReadPermissions(_fbLoginReadPermissions, fromViewController: self) { (result, error) in
            if let  _ =  error {
                //login error
                self.hideCentralGraySpinner()
            } else if result.isCancelled {
                //cancel
                self.hideCentralGraySpinner()
            } else {
                //succes
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : _fbUserInfoRequestParam])
                request.startWithCompletionHandler({ (con, result, error) in
                    if let _ = error {
                        self.hideCentralGraySpinner()
                    }
                    //getProfile image url from fb data
                    let info = result as! [String : AnyObject]
                    var imgageUrl = ""
                    if let picture = info["picture"]  {
                        if let data = picture["data"] as? NSDictionary {
                            if let url = data["url"] as? String {
                                imgageUrl = url
                            }
                        }
                    }
                    self.donwloadFbProfileImage(imgageUrl)

                    //Login APICall
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
                                            "Gender" : gender,
                                            "FCMToken": _FCMToken]
        
        wsCall.loginWithFacebook(params) { (response, statusCode) in
            if response.isSuccess {
                if let json = response.json {
                    var info = json["Object"] as! [String : AnyObject]
                    me = User(info: info)
                    //Navigate to home
                    if let image  = self.profileImage {
                        self.showCentralGraySpinner()
                        me.updateProfileImage(image.mediumQualityJPEGNSData, block: {(path) in
                            self.hideCentralGraySpinner()
                            info["Photo"] = path ?? ""
                            archiveObject(info, key: kLoggedInUserKey)
                            self.performSegueWithIdentifier("SBSegueToUserType", sender: nil)
                        })
                    }
                    archiveObject(info, key: kLoggedInUserKey)
                } else {
                    showToastErrorMessage("", message: response.message!)
                }
            } else {
                showToastErrorMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Download Facebook Profile Image to store in SawACar api.
    func donwloadFbProfileImage(url: String) {
        if let url = NSURL(string:  url) {
            if let imgdata = NSData(contentsOfURL: url) {
                if let img = UIImage(data: imgdata) {
                    self.profileImage = img
                }
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
            showToastMessage(alertTitle, message: "kEmailIsRequired".localizedString())
            return false
        } else {
            if !txtEmail.text!.isValidEmailAddress() {
                showToastMessage(alertTitle, message: "kEmailValidateMsg".localizedString())
                return false
            }
        }
        if txtpassword.text!.isEmpty {
            showToastMessage(alertTitle, message: "kPasswordIsRequired".localizedString())
            return false
        }
        return  true
    }
    
}

