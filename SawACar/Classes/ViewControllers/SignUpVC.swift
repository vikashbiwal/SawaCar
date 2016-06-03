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
    
    //Form type  - Determine which type of form is showing on the screen.
    var currntFormType: SignUpFormType!
    //Used for check why you are going to Country list VC. For select country or nationality.
    var countryActionFor = CountrySelectionFor.Nationality

    //MARK: Blocks handle signup form actions
    var signUpFormActionBlock : (action: SignUpFormActionType, value: String)-> Void = {_ in}
    var formTextFieldTextChangeBlock: (action: TextFieldType, text: String)-> Void = {_ in}
   
    //MARK: Useful Enums
    enum TextFieldType: Int {
        case FirstName = 101, LastName, Email, Password, ConfirmPass, MobileNo, None = 0
    }

    enum SignUpFormType: Int {
        case PersonalInfo, GenderInfo, BirthDateInfo, ContactInfo, LocationInfo
    }
    
    enum SignUpFormActionType {
        case CountryAction, NationalityAction, ImagePickerAction, GenderAction, DatePickerAction
    }
    
    enum CountrySelectionFor {
        case Nationality
        case Country
        case None
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
            
        } else if  currntFormType == .ContactInfo {
            process = user.validateContactInfo()
            index = 4
            
        } else {
            process = user.validateLocationInfo()
            index = 4 // no need to change index. already on last index
            self.signupWSCall()
            return
        }
        
        if process.isValid {
            let indexPathToScroll = NSIndexPath(forItem: index, inSection: 0)
            CollectionView.scrollToItemAtIndexPath(indexPathToScroll, atScrollPosition: .CenteredHorizontally, animated: true)
            setUIForAfterCollViewScroll(index)
            
        } else {
            showAlert(process.message, title: "SawACar")
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
        if currntFormType == .LocationInfo {
           index = 3
        } else if currntFormType == .ContactInfo {
          index = 2
        } else if currntFormType == .BirthDateInfo {
          index = 1
        } else if currntFormType == .GenderInfo {
          index = 0
        } else  {
           self.navigationController?.popViewControllerAnimated(true)
            return
        }
        let indexPathToScroll = NSIndexPath(forItem: index, inSection: 0)
        CollectionView.scrollToItemAtIndexPath(indexPathToScroll, atScrollPosition: .CenteredHorizontally, animated: true)
        setUIForAfterCollViewScroll(index)
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
                
            } else if action == .DatePickerAction {
                self.user.birthYear = value
            }
        }
    }

}

//MARK: Notifications
extension SignUpVC {
    //Keyboard Notifications
    func keyboardWillShow(nf: NSNotification)  {
        let cells = CollectionView.visibleCells()
        let cell = cells.first as! SignUpCollectionViewCell
        cell.tableView.contentInset = UIEdgeInsetsMake(0, 0, 150, 0)
        if currntFormType == .ContactInfo {
            btnHideKbord.hidden = false
        }
    }
    
    func keyboardWillHide(nf: NSNotification)  {
        let cells = CollectionView.visibleCells()
        let cell = cells.first as! SignUpCollectionViewCell
        cell.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
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

        if indexPath.row == 0 {
            cell.formType = .PersonalInfo
            cell.textFieldChangeBlock = formTextFieldTextChangeBlock
            
        } else if indexPath.row == 1 {
            cell.formType = .GenderInfo
            
        } else  if indexPath.row == 2 {
            cell.formType = .BirthDateInfo
            
        } else if indexPath.row == 3 {
            cell.formType = .ContactInfo
            cell.textFieldChangeBlock = formTextFieldTextChangeBlock
            
        } else  {
            cell.formType = .LocationInfo
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
    
    func setUIForAfterCollViewScroll(index: Int) {
        pagerControl.currentPage = index
        var str = ""
        if index == 0 {
            str = "Create your account"
            currntFormType = .PersonalInfo
        } else if index == 1 {
            str = "Next"
            currntFormType = .GenderInfo
        } else if index == 2 {
            str = "Next"
            currntFormType = .BirthDateInfo
        } else if index == 3 {
            str = "Next"
            currntFormType = .ContactInfo
        } else  {
            str = "Finish"
            currntFormType = .LocationInfo
            
        }
        btnFinish.setTitle(str, forState: .Normal)
    }
}

//MARK: Country and Nationality Selection Operations
extension SignUpVC {
    //Method : Open country list controller for select user's nationality and country
    func openCountryList(forAction : SignUpFormActionType)  {
        let cListVC = self.storyboard?.instantiateViewControllerWithIdentifier("SBID_CountryListVC") as! CountryListVC
        if forAction == .NationalityAction {
            cListVC.selectedCountryId = user.nationalityId
        } else  {
            cListVC.selectedCountryId = user.countryId
        }
        
        cListVC.completionBlock = {(country) in
            let cells = self.CollectionView.visibleCells()
            let cell = cells.first as! SignUpCollectionViewCell

            if forAction == .NationalityAction {
                self.user.nationalityId = country.Id
                let tblcell = cell.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as! TVSignUpFormCell
                tblcell.txtField.text = country.name
                
            } else  {
                self.user.countryId = country.Id
                self.user.mobileCountryCode = country.dialCode
                let tblcell = cell.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! TVSignUpFormCell
                tblcell.txtField.text = country.name
            }
        }
        
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
    
}

//MARK: ImagePicker action for profile image setup
extension SignUpVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Show ActionSheet to Choose image for profile picture
    func showActionForImagePick() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cancelAction  = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let cameraActiton = UIAlertAction(title: "Take a Photo", style: .Default) { (action) in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Choose from Gallery", style: .Default) { (action) in
            self.openGallery()
        }
        sheet.addAction(cameraActiton)
        sheet.addAction(galleryAction)
        sheet.addAction(cancelAction)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    func openCamera()  {
        let iPicker = UIImagePickerController()
        iPicker.delegate = self
        iPicker.sourceType = .Camera
        iPicker.allowsEditing = true
        self.presentViewController(iPicker, animated: true, completion: nil)
    }
    
    func openGallery()  {
        let iPicker = UIImagePickerController()
        iPicker.delegate = self
        iPicker.sourceType = .PhotoLibrary
        iPicker.allowsEditing = true
        self.presentViewController(iPicker, animated: true, completion: nil)
    
    }
    
    //Image Picker delegate method
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
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
                me = User(json: response.json! as! [String : AnyObject])
            } else {
                self.showAlert(response.message, title: "SignUp Error")
            }
            self.hideCentralGraySpinner()
        })
    }
}
