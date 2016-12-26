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
    lazy var user: LoggedInUser = {return LoggedInUser()}()
    var profileImage : UIImage?
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        //Add Keybaord observeration
        _defaultCenter.addObserver(self, selector: #selector(SignUpVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        _defaultCenter.addObserver(self, selector: #selector(SignUpVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        _defaultCenter.removeObserver(self)
    }
   
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetInput() {
        txtEmail.text = ""
        txtpassword.text = ""
        txtEmail.resignFirstResponder()
        txtpassword.resignFirstResponder()
    }
    
}

//MARK: IBActions
extension LoginVC {
    @IBAction func signUpBtnClicked(_ sender: UIButton?) {
        self.performSegue(withIdentifier: "SBSegue_SignUP", sender: nil)
    }
    
    @IBAction func loginBtnclicked(_ sender: UIButton?) {
        self.loginWithEmailWS()
    }
    
    @IBAction func loginWithFacebookBtnClicked(_ sender: UIButton?) {
        self.loginWithFacebook()
    }
}


//MARK: Notifications
extension LoginVC {
    //Keyboard Notifications
    func keyboardWillShow(_ nf: Notification)  {
        let userinfo = nf.userInfo!
        if let keyboarFrame = (userinfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:keyboarFrame.size.height , right: 0)
        }
    }
    
    func keyboardWillHide(_ nf: Notification)  {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:0 , right: 0)
    }
    
}

//MARK: UITextfield delegate
extension LoginVC {
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
                self.hideCentralGraySpinner()
                if response.isSuccess {
                    if let json = response.json {//change size width and height change postition delete this label remove text
                        if let info = json as? [String : AnyObject] {
                            let access_token = info["access_token"] as! String
                            wsCall.addAccesTokenToHeader(access_token) //set the access token to api request header
                            archiveObject(info as AnyObject, key: kAuthorizationInfoKey)
                            self.resetInput()
                            self.getMyInfoAPICall()
                            
                        } else {
                            showToastErrorMessage("Login Error", message: response.message)
                        }
                    } else {
                        showToastErrorMessage("Login Error", message: response.message)
                    }
                } else {
                    showToastErrorMessage("Login Error", message: response.message)
                }
            })
        } else {
            showToastErrorMessage("Login Error", message: process.msg)
        }
    }
    
    //Get user's profile info
    func getMyInfoAPICall() {
        self.showCentralGraySpinner()
        
        user.getInfo { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : AnyObject] {
                    me = LoggedInUser(info: json)
                    archiveObject(json as AnyObject, key: kLoggedInUserKey)
                    self.performSegue(withIdentifier: "SBSegueToUserType", sender: nil)
                }
                
            } else {
                showToastErrorMessage("Login Error", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //MARK: Login With Facebook
    func loginWithFacebook() {
        self.showCentralGraySpinner()
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        fbManager.logIn(withReadPermissions: _fbLoginReadPermissions, from: self) { (result, error) in
            if let  _ =  error {
                //login error
                self.hideCentralGraySpinner()
            } else if (result?.isCancelled)! {
                //cancel
                self.hideCentralGraySpinner()
            } else {
                //succes
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : _fbUserInfoRequestParam])
                _ = request?.start(completionHandler: { (con, result, error) in
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
    
    
    
    func loginWithFacebookWSCall(_ fbInfo : [String : AnyObject])  {
        print(fbInfo)
        let gender = fbInfo["gender"] as! String == "male" ? true : false
        let params: [String : AnyObject] = ["FacebookID" : fbInfo["id"] as! String as AnyObject,
                                            "Email" : fbInfo["email"] as! String as AnyObject,
                                            "FirstName" : fbInfo["first_name"] as! String as AnyObject,
                                            "LastName" : fbInfo["last_name"] as! String as AnyObject,
                                            "Gender" : gender as AnyObject,
                                            "FCMToken": _FCMToken as AnyObject]
        
        wsCall.loginWithFacebook(params) { (response, statusCode) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    me = LoggedInUser(info: json)
                    //Navigate to home
                    if let _  = self.profileImage {
                        //self.showCentralGraySpinner()
//                        me.updateProfileImage(image.mediumQualityJPEGNSData, block: {(path) in
//                            self.hideCentralGraySpinner()
//                            init["Photo"] = path  ?? ""
//                            archiveObject(info , key: kLoggedInUserKey)
//                            self.performSegue(withIdentifier: "SBSegueToUserType", sender: nil)
//                        })
                    }
                    //archiveObject(info , key: kLoggedInUserKey)
                } else {
                    showToastErrorMessage("", message: response.message)
                }
            } else {
                showToastErrorMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Download Facebook Profile Image to store in SawACar api.
    func donwloadFbProfileImage(_ url: String) {
        if let url = URL(string:  url) {
            if let imgdata = try? Data(contentsOf: url) {
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

