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
    
    lazy var user: LoggedInUser = {return LoggedInUser()}()
    var country: Country?
    var nationality: Country?
    var profileImage: UIImage?
    
    //Form type  - Determine which type of form is showing on the screen.
    var currntFormType: SignUpFormType!
    
    //Used for check why you are going to Country list VC. For select country or nationality.
    var countryActionFor = LocationSelectionForType.nationality

    //MARK: Blocks handle signup form's actions
    var signUpFormActionBlock : (_ action: SignUpFormActionType, _ value: String)-> Void = {_ in}
    var formTextFieldTextChangeBlock: (_ action: TextFieldType, _ text: String)-> Void = {_ in}
   
    //MARK: Useful Enums
    enum SignUpFormType: Int {
        case personalInfo, genderInfo, birthDateInfo, contactInfo, locationInfo
    }
    
    enum SignUpFormActionType {
        case countryAction, nationalityAction, imagePickerAction, genderAction, datePickerAction, dialCodeAction
    }
    
    
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currntFormType = .personalInfo
        handelSignUpFormActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _defaultCenter.addObserver(self, selector: #selector(SignUpVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        _defaultCenter.addObserver(self, selector: #selector(SignUpVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _defaultCenter.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    
}

//MARK: IBActions
extension SignUpVC {
    
    //Handle signup actions like - Create account - Next - Finish
    @IBAction func SignUpBtnClicked(_ sender: UIButton) {
        var index = 0
        var process:(isValid:Bool, message:String)!
       
        if currntFormType == .personalInfo {
            process = user.validatePersonalInfo()
            index = 1
        } else if currntFormType == .genderInfo {
            process = user.validateGenderInfo()
            index = 2
            
        } else if currntFormType == .birthDateInfo {
            process = user.validateBirthInfo()
            index = 3
            
        } else if  currntFormType == .locationInfo {
            process = user.validateLocationInfo()
            index = 4
            
        } else {
            process = user.validateContactInfo()
            index = 4 // no need to change index. already on last index
            if process.isValid {
                self.uploadProfileImage()
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
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true);
    }
    
    //Method: This action is used for navigate to back
    //if you are currently on signup's any one step then this navigate back to previous step
    // and when you reach first step of signup then it will navigate back on previous screen (Login screen).
    @IBAction func backBtnClicked(_ sender: UIButton) {
       var index  = 0
        if currntFormType == .contactInfo  {
           index = 3
        } else if currntFormType == .locationInfo {
          index = 2
        } else if currntFormType == .birthDateInfo {
          index = 1
        } else if currntFormType == .genderInfo {
          index = 0
        } else  {
           _ =  self.navigationController?.popViewController(animated: true)
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
            if type == .firstName {
                self.user.firstname = text
            } else if type == .lastName {
                self.user.lastname = text
            } else if type == .email {
                self.user.email = text
            } else if type == .password {
                self.user.password = text
            } else if type == .confirmPass {
                self.user.confPass = text
            } else if type == .mobileNo {
                self.user.mobile = text
            }
        }
        
        //actions block
        signUpFormActionBlock = {[unowned self] (action, value) in
            if action == .genderAction {
                self.user.gender = value
                
            } else if action == .imagePickerAction {
                self.showActionForImagePick()
                
            } else if action == .nationalityAction {
                self.openCountryList(.nationalityAction)
                
            } else if action == .countryAction {
                self.openCountryList(.countryAction)
                
            } else if action == .dialCodeAction {
                self.openCountryList(.dialCodeAction)
                
            } else if action == .datePickerAction {
                self.user.birthDate = value
            }
        }
    }

}

//MARK: Notifications
extension SignUpVC {
    //Keyboard Notifications
    func keyboardWillShow(_ nf: Notification)  {
        let cells = CollectionView.visibleCells
        if !cells.isEmpty {
            let cell = cells.first as? SignUpCollectionViewCell
            cell?.tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0)
        }
        if currntFormType == .contactInfo {
            btnHideKbord.isHidden = false
        }
    }
    
    func keyboardWillHide(_ nf: Notification)  {
        let cells = CollectionView.visibleCells
        if !cells.isEmpty {
            let cell = cells.first as? SignUpCollectionViewCell
            cell?.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        btnHideKbord.isHidden = true
    }

}

//MARK: CollectionView DataSource and delegate
extension SignUpVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SignUpCollectionViewCell
         cell.user = user
        if indexPath.row == 0 {
            cell.formType = .personalInfo
            cell.textFieldChangeBlock = formTextFieldTextChangeBlock
            
        } else if indexPath.row == 1 {
            cell.formType = .genderInfo
            
        } else  if indexPath.row == 2 {
            cell.formType = .birthDateInfo
            
        } else if indexPath.row == 3 {
            cell.formType = .locationInfo
            
        } else  {
            cell.formType = .contactInfo
            cell.textFieldChangeBlock = formTextFieldTextChangeBlock

        }
        
        cell.signUpFormActionBlock = signUpFormActionBlock
        cell.tableView.reloadData()
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: _screenSize.width, height: 470 * _heighRatio)
    }
   
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int( scrollView.contentOffset.x / scrollView.frame.size.width)
        setUIForAfterCollViewScroll(index)
    }
    
    func scrollCollectionViewForSignupStep(_ index: Int) {
        let indexPathToScroll = IndexPath(item: index, section: 0)
        CollectionView.scrollToItem(at: indexPathToScroll, at: .centeredHorizontally, animated: true)
        setUIForAfterCollViewScroll(index)
    }

    func setUIForAfterCollViewScroll(_ index: Int) {
        pagerControl.currentPage = index
        var str = ""
        if index == 0 {
            str = "create_your_account".localizedString()
            currntFormType = .personalInfo
        } else if index == 1 {
            str = "next".localizedString()
            currntFormType = .genderInfo
        } else if index == 2 {
            str = "next".localizedString()
            currntFormType = .birthDateInfo
        } else if index == 3 {
            str = "next".localizedString()
            currntFormType = .locationInfo
        } else  {
            str = "finish".localizedString()
            currntFormType = .contactInfo
            
        }
        btnFinish.setTitle(str, for: UIControlState())
    }
}

//MARK: Country and Nationality Selection Operations
extension SignUpVC {
    //Method : Open country list controller for select user's nationality and country
    func openCountryList(_ forAction : SignUpFormActionType)  {
        let cListVC = VListViewController.loadFromNib()
        cListVC.keyForTitle = "CountryName"
        cListVC.keyForId = "CountryID"
        cListVC.apiName = APIName.GetActiveCountries
        
        if forAction == .nationalityAction {
            cListVC.preSelectedIDs = [user.nationality.Id]
            cListVC.screenTitle = "nationality".localizedString()
            cListVC.apiName = APIName.GetAllCountries
            
        } else if forAction == .countryAction {
            cListVC.preSelectedIDs = [user.country.Id]
            cListVC.screenTitle = "countries".localizedString()
            
        } else if forAction == .dialCodeAction {
            cListVC.preSelectedIDs = [user.mobileCountryCode]
            cListVC.screenTitle = "country_dial_code".localizedString()
        }
        
        cListVC.completionBlock = {(countries) in
            let cells = self.CollectionView.visibleCells
            let cell = cells.first as! SignUpCollectionViewCell
            if let item = countries.first {
                let country = Country(info: item.obj as! [String : AnyObject])
                if forAction == .nationalityAction {
                    self.user.nationality = country
                    let tblcell = cell.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! TVSignUpFormCell
                    tblcell.txtField.text = country.name
                    
                } else if forAction == .countryAction {
                    self.user.country = country
                    self.user.mobileCountryCode = country.dialCode
                    let tblcell = cell.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! TVSignUpFormCell
                    tblcell.txtField.text = country.name
                    
                } else if forAction == .dialCodeAction {
                    let tblcell = cell.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! TVSignUpFormCell
                    tblcell.lblTitle.text = "+" + country.dialCode
                    self.user.mobileCountryCode = country.dialCode
                }
            }
        }
        
        self.present(cListVC, animated: true, completion: nil)
    }
    
}

//MARK: ImagePicker action for profile image setup
extension SignUpVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Show ActionSheet to Choose image for profile picture
    func showActionForImagePick() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction  = UIAlertAction(title: "cancel".localizedString(), style: .cancel, handler: nil)
        let cameraActiton = UIAlertAction(title: "take_a_photo".localizedString(), style: .default) { (action) in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "choose_from_gallery".localizedString(), style: .default) { (action) in
            self.openGallery()
        }
        sheet.addAction(cameraActiton)
        sheet.addAction(galleryAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    func openCamera()  {
        VAuthorization.checkAuthorizationStatusForCamera { (isAuthorized) in
            if isAuthorized {
                let iPicker = UIImagePickerController()
                iPicker.delegate = self
                iPicker.sourceType = .camera
                iPicker.allowsEditing = true
                self.present(iPicker, animated: true, completion: nil)
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
                iPicker.sourceType = .photoLibrary
                iPicker.allowsEditing = true
                self.present(iPicker, animated: true, completion: nil)
            } else {
                VAuthorization.showPhotosAccessDeniedAlert(self)
            }
        }
    }
    
    //Image Picker delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        profileImage = image
        let cells = CollectionView.visibleCells
        let cell = cells.first as! SignUpCollectionViewCell
        let tblcell = cell.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TVSignUpFormCell
        tblcell.button!.setImage(image, for: UIControlState())
        picker.dismiss(animated: true , completion: nil)
    }
}

//MARK: Webservice calls
extension SignUpVC {
    
    func uploadProfileImage() {
        if let image = self.profileImage {
            self.showCentralGraySpinner()
            let imgData = image.mediumQualityJPEGNSData
            wsCall.uploadProfileImage(forSignup: imgData, block: { (response, flag) in
                if response.isSuccess {
                    if let json = response.json as? [String : AnyObject] {
                        let imgName = json["Photo"] as! String
                        self.signupWSCall(imgName)
                        
                    }
                    
                } else {
                    self.hideCentralGraySpinner()
                }
            })
        } else {
            self.signupWSCall()
        }
        
    }
    
    //Sign up ws call
    func signupWSCall(_ imageName: String = "") {
        user.photo = imageName
        user.singUp({ (response, flag) in
            if response.isSuccess {
                if let _ = response.json as? [String : Any] {
                    self.parentBackAction(nil)
                    showToastMessage("", message: response.message)
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
    func checkEmailAvailability(_ email: String) {
        showCentralGraySpinner()
        wsCall.checkEmailAvailability(email) { (response, flag) in
            self.hideCentralGraySpinner()
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
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

