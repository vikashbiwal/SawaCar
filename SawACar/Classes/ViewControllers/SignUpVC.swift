//
//  ViewController.swift
//  SawACar
//  Created by Vikash Prajapati
//  Created by Yudiz Solutions Pvt. Ltd. on 11/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import FBSDKLoginKit



class SignUpVC: ParentVC {
    //MARK: Outlets and Variables
    @IBOutlet var CollectionView: UICollectionView!
    @IBOutlet var pagerControl  : UIPageControl!
    @IBOutlet var btnFinish     : UIButton!
    @IBOutlet var btnHideKbord: UIButton!
    
    var country: Country?
    var nationality: Country?
    var user: User!
    var profileImage: UIImage?
    
    //Form type  - Determine which type of form is showing on the screen.
    var currntFormType: SignUpFormType!
    //Used for check why you are going to Country list VC. For select country or nationality.
    var countryActionFor = LocationSelectionForType.Nationality

    //MARK: Blocks handle signup form actions
    var signUpFormActionBlock : (action: SignUpFormActionType, value: String)-> Void = {_ in}
    var formTextFieldTextChangeBlock: (action: TextFieldType, text: String)-> Void = {_ in}
   
    //MARK: Useful Enums
    enum SignUpFormType: Int {
        case PersonalInfo, GenderInfo, BirthDateInfo, ContactInfo, LocationInfo
    }
    
    enum SignUpFormActionType {
        case CountryAction, NationalityAction, ImagePickerAction, GenderAction, DatePickerAction, DialCodeAction
    }
    
    
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User()
        currntFormType = .PersonalInfo
        handelSignUpFormActions()
    }
    
    override func viewWillAppear(animated: Bool) {
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
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    }
    
}

//MARK: IBActions
extension SignUpVC {
    
    //Handle signup actions like - Create account - Next - Finish
    @IBAction func SignUpBtnClicked(sender: UIButton) {
        var index = 0
        var process:(isValid:Bool, message:String)!
       
        if currntFormType == .PersonalInfo {
            process = user.validatePersonalInfo()
            index = 1
        } else if currntFormType == .GenderInfo {
            process = user.validateGenderInfo()
            index = 2
            
        } else if currntFormType == .BirthDateInfo {
            process = user.validateBirthInfo()
            index = 3
            
        } else if  currntFormType == .LocationInfo {
            process = user.validateLocationInfo()
            index = 4
            
        } else {
            process = user.validateContactInfo()
            index = 4 // no need to change index. already on last index
            if process.isValid {
                self.signupWSCall()
            } else {
                showToastErrorMessage("", message: process.message)
            }
            return
        }
        
        if process.isValid {
            if index == 1 {//verify email is available or not. Could not be navigate if email is not available for signup.
                self.checkEmailAvailability(user.email)
                return
            }
            self.scrollCollectionViewForSignupStep(index)
            
        } else {
            showToastErrorMessage("", message: process.message)
        }
    }
    
    //Method: This method is used for hide keybord when keyboard type is number pad.
    //The button only appear when mobile number field become first responder.
    @IBAction func doneBtnTapped(sender: UIButton) {
        self.view.endEditing(true);
    }
    
    //Method: This action is used for navigate to back
    //if you are currently on signup's any one step then this navigate back to previous step
    // and when you reach first step of signup then it will navigate back on previous screen (Login screen).
    @IBAction func backBtnClicked(sender: UIButton) {
       var index  = 0
        if currntFormType == .ContactInfo  {
           index = 3
        } else if currntFormType == .LocationInfo {
          index = 2
        } else if currntFormType == .BirthDateInfo {
          index = 1
        } else if currntFormType == .GenderInfo {
          index = 0
        } else  {
           self.navigationController?.popViewControllerAnimated(true)
            return
        }
        self.view.endEditing(true)
        scrollCollectionViewForSignupStep(index)
    }
    
    //MARK: Sing Up Form Actions
    //Method : This method handle all the actions of Signup form
    // like - textChange, Gender selection, country/nationlity selection,
    // birthdate selection
    func handelSignUpFormActions()  {
        
        formTextFieldTextChangeBlock = {[unowned self] (type, text)  in
            if type == .FirstName {
                self.user.firstname = text
            } else if type == .LastName {
                self.user.lastname = text
            } else if type == .Email {
                self.user.email = text
            } else if type == .Password {
                self.user.password = text
            } else if type == .ConfirmPass {
                self.user.confPass = text
            } else if type == .MobileNo {
                self.user.mobile = text
            }
        }
        
        //actions block
        signUpFormActionBlock = {[unowned self] (action, value) in
            if action == .GenderAction {
                self.user.gender = value
                
            } else if action == .ImagePickerAction {
                self.showActionForImagePick()
                
            } else if action == .NationalityAction {
                self.openCountryList(.NationalityAction)
                
            } else if action == .CountryAction {
                self.openCountryList(.CountryAction)
                
            } else if action == .DialCodeAction {
                self.openCountryList(.DialCodeAction)
                
            } else if action == .DatePickerAction {
                self.user.birthDate = value
            }
        }
    }

}

//MARK: Notifications
extension SignUpVC {
    //Keyboard Notifications
    func keyboardWillShow(nf: NSNotification)  {
        let cells = CollectionView.visibleCells()
        if !cells.isEmpty {
            let cell = cells.first as? SignUpCollectionViewCell
            cell?.tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0)
        }
        if currntFormType == .ContactInfo {
            btnHideKbord.hidden = false
        }
    }
    
    func keyboardWillHide(nf: NSNotification)  {
        let cells = CollectionView.visibleCells()
        if !cells.isEmpty {
            let cell = cells.first as? SignUpCollectionViewCell
            cell?.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        btnHideKbord.hidden = true
    }

}

//MARK: CollectionView DataSource and delegate
extension SignUpVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! SignUpCollectionViewCell
         cell.user = user
        if indexPath.row == 0 {
            cell.formType = .PersonalInfo
            cell.textFieldChangeBlock = formTextFieldTextChangeBlock
            
        } else if indexPath.row == 1 {
            cell.formType = .GenderInfo
            
        } else  if indexPath.row == 2 {
            cell.formType = .BirthDateInfo
            
        } else if indexPath.row == 3 {
            cell.formType = .LocationInfo
            
        } else  {
            cell.formType = .ContactInfo
            cell.textFieldChangeBlock = formTextFieldTextChangeBlock

        }
        
        cell.signUpFormActionBlock = signUpFormActionBlock
        cell.tableView.reloadData()
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: _screenSize.width, height: 470 * _heighRatio)
    }
   
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = Int( scrollView.contentOffset.x / scrollView.frame.size.width)
        setUIForAfterCollViewScroll(index)
    }
    
    func scrollCollectionViewForSignupStep(index: Int) {
        let indexPathToScroll = NSIndexPath(forItem: index, inSection: 0)
        CollectionView.scrollToItemAtIndexPath(indexPathToScroll, atScrollPosition: .CenteredHorizontally, animated: true)
        setUIForAfterCollViewScroll(index)
    }

    func setUIForAfterCollViewScroll(index: Int) {
        pagerControl.currentPage = index
        var str = ""
        if index == 0 {
            str = "create_your_account".localizedString()
            currntFormType = .PersonalInfo
        } else if index == 1 {
            str = "next".localizedString()
            currntFormType = .GenderInfo
        } else if index == 2 {
            str = "next".localizedString()
            currntFormType = .BirthDateInfo
        } else if index == 3 {
            str = "next".localizedString()
            currntFormType = .LocationInfo
        } else  {
            str = "finish".localizedString()
            currntFormType = .ContactInfo
            
        }
        btnFinish.setTitle(str, forState: .Normal)
    }
}

//MARK: Country and Nationality Selection Operations
extension SignUpVC {
    //Method : Open country list controller for select user's nationality and country
    func openCountryList(forAction : SignUpFormActionType)  {
        let cListVC = VListViewController.loadFromNib()
        cListVC.keyForTitle = "CountryName"
        cListVC.keyForId = "CountryID"
        cListVC.apiName = APIName.GetActiveCountries
        
        if forAction == .NationalityAction {
            cListVC.preSelectedIDs = [user.nationality.Id]
            cListVC.screenTitle = "nationality".localizedString()
            cListVC.apiName = APIName.GetAllCountries
            
        } else if forAction == .CountryAction {
            cListVC.preSelectedIDs = [user.country.Id]
            cListVC.screenTitle = "countries".localizedString()
            
        } else if forAction == .DialCodeAction {
            cListVC.preSelectedIDs = [user.mobileCountryCode]
            cListVC.screenTitle = "country_dial_code".localizedString()
        }
        
        cListVC.completionBlock = {(countries) in
            let cells = self.CollectionView.visibleCells()
            let cell = cells.first as! SignUpCollectionViewCell
            if let item = countries.first {
                let country = Country(info: item.obj as! [String : AnyObject])
                if forAction == .NationalityAction {
                    self.user.nationality = country
                    let tblcell = cell.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! TVSignUpFormCell
                    tblcell.txtField.text = country.name
                    
                } else if forAction == .CountryAction {
                    self.user.country = country
                    self.user.mobileCountryCode = country.dialCode
                    let tblcell = cell.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! TVSignUpFormCell
                    tblcell.txtField.text = country.name
                    
                } else if forAction == .DialCodeAction {
                    let tblcell = cell.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! TVSignUpFormCell
                    tblcell.lblTitle.text = "+" + country.dialCode
                    self.user.mobileCountryCode = country.dialCode
                }
            }
        }
        
        self.presentViewController(cListVC, animated: true, completion: nil)
    }
    
}

//MARK: ImagePicker action for profile image setup
extension SignUpVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Show ActionSheet to Choose image for profile picture
    func showActionForImagePick() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cancelAction  = UIAlertAction(title: "cancel".localizedString(), style: .Cancel, handler: nil)
        let cameraActiton = UIAlertAction(title: "take_a_photo".localizedString(), style: .Default) { (action) in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "choose_from_gallery".localizedString(), style: .Default) { (action) in
            self.openGallery()
        }
        sheet.addAction(cameraActiton)
        sheet.addAction(galleryAction)
        sheet.addAction(cancelAction)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    func openCamera()  {
        VAuthorization.checkAuthorizationStatusForCamera { (isAuthorized) in
            if isAuthorized {
                let iPicker = UIImagePickerController()
                iPicker.delegate = self
                iPicker.sourceType = .Camera
                iPicker.allowsEditing = true
                self.presentViewController(iPicker, animated: true, completion: nil)
            } else {
                VAuthorization.showCameraAccessDeniedAlert(self)
            }
        }
    }
    
    func openGallery()  {
        VAuthorization.checkAuthorizationStatusForPhotoLibarary { (isAuthorized) in
            if isAuthorized {
                let iPicker = UIImagePickerController()
                iPicker.delegate = self
                iPicker.sourceType = .PhotoLibrary
                iPicker.allowsEditing = true
                self.presentViewController(iPicker, animated: true, completion: nil)
            } else {
                VAuthorization.showPhotosAccessDeniedAlert(self)
            }
        }
    }
    
    //Image Picker delegate method
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        profileImage = image
        let cells = CollectionView.visibleCells()
        let cell = cells.first as! SignUpCollectionViewCell
        let tblcell = cell.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TVSignUpFormCell
        tblcell.button!.setImage(image, forState: .Normal)
        picker.dismissViewControllerAnimated(true , completion: nil)
    }
}

//MARK: Webservice calls
extension SignUpVC {
    //Sign up ws call
    func signupWSCall() {
        self.showCentralGraySpinner()
        user.singUp({ (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    var info = json["Object"] as! [String : AnyObject]
                    me = User(info: info)
                    if let image = self.profileImage {
                        let imgData = image.mediumQualityJPEGNSData
                        me.updateProfileImage(imgData, block: {(path) in
                            info["Photo"] = path ?? ""
                            archiveObject(info, key: kLoggedInUserKey)
                        })
                    } else {
                        archiveObject(info, key: kLoggedInUserKey)
                    }
                    
                    self.performSegueWithIdentifier("SBSegueToUserType", sender: nil)
                } else {
                    showToastErrorMessage("Signup Error", message: response.message)
                }
            } else {
                showToastErrorMessage("Signup Error", message: response.message)
            }
            self.hideCentralGraySpinner()
        })
    }
    
    //Verify email available or not for signup a new user.
    func checkEmailAvailability(email: String) {
        showCentralGraySpinner()
        wsCall.checkEmailAvailability(email) { (response, flag) in
            self.hideCentralGraySpinner()
            if response.isSuccess {
                if let json = response.json {
                    let result = RConverter.boolean(json["Object"])
                    if result {
                        self.scrollCollectionViewForSignupStep(1)
                    } else {
                        let message = json["Message"] as! String
                        showToastErrorMessage("Signup Error", message: message)
                    }
                }
            } else {
                showToastErrorMessage("Signup Error", message: response.message)
            }
        }
    }
}

