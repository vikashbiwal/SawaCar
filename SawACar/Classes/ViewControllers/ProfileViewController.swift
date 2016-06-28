//
//  ProfileViewController.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 08/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class ProfileViewController: ParentVC {
    @IBOutlet var headerView:   UIView!
    @IBOutlet var imgVUserProfile: UIImageView!
    @IBOutlet var imgVCover:    UIImageView!
    @IBOutlet var icnAddPhoto: UIImageView!
    @IBOutlet var editBtn :     UIButton!
    @IBOutlet var lblFullName:  UILabel!
    @IBOutlet var lblGender:    UILabel!
    @IBOutlet var lblBirthDate: UILabel!
    
    var user : User!
    var selectedMenu: Menu!
    
    var isLoading   = false
    var isEditMode  = false
    var isProfileImgeChanged = false
    
    let Menus = [Menu(title: "Profile",         imgName: "ic_profile_selected", selected: true, type: .Profile),
                 Menu(title: "Change Password", imgName: "ic_change_password", type: .ChangePass),
                 Menu(title: "Social Link",     imgName: "ic_social_link", type: .SocialLink),
                 Menu(title: "Details",         imgName: "ic_detail", type: .Details),
                 Menu(title: "Settings",        imgName: "ic_settings", type: .Settings)]
    
    var menuItems = [CellItem]()
    lazy var dateFomator: NSDateFormatter = { //formator for birthdate
        let df = NSDateFormatter()
        df.dateFormat = "yyyy"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = me
        selectedMenu = Menus[0]
        changeMenuItems(selectedMenu)
        setUserInfo()
        icnAddPhoto.drawShadow()
        imgVUserProfile.drawShadowWithCornerRadius()
    }

    override func viewWillAppear(animated: Bool) {
        //Add Keybaord observeration
        _defaultCenter.addObserver(self, selector: #selector(SignUpVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        _defaultCenter.addObserver(self, selector: #selector(SignUpVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
    
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
extension ProfileViewController {
    
    @IBAction func editBtnCliclicked(sender: UIButton) {
        if isEditMode {
            editBtn.setImage(UIImage(named: "ic_edit"), forState: .Normal)
            editBtn.setTitle("", forState: .Normal)
            
            if selectedMenu.type == .Profile {
                self.updateProfile()
            } else if selectedMenu.type == .SocialLink {
                self.updateSocialLinks()
            } else if selectedMenu.type == .Settings {
                self.updateUserPreference()
            }
            icnAddPhoto.hidden = true

        } else  {
            editBtn.setImage(nil, forState: .Normal)
            editBtn.setTitle("Save", forState: .Normal)
            tableView.reloadData()
            if selectedMenu.type == .Profile {
                icnAddPhoto.hidden = false
            }
        }
        isEditMode = !isEditMode

    }
    
    @IBAction func profileImgBtnClicked(sender: UIButton) {
        if isEditMode && selectedMenu.type == .Profile {
            showActionForImagePick()
        }
    }
    
    @IBAction func cellSwitchBtnTapped(sw: SettingSwitch) {
        let isOn = sw.on
        if sw.type == .ShowEmail {
            user.preference.showEmail = isOn
        } else if sw.type == .ShowMobile {
            user.preference.showMobile = isOn
        } else if sw.type == .VisibleInSearch {
            user.preference.visibleInSearch = isOn
        } else if sw.type == .SpecialOrder {
            user.preference.specialOrder = isOn
        } else if sw.type == .AcceptMonitring {
            user.preference.acceptMonitring = isOn
        } else if sw.type == .Children {
            user.preference.kids = isOn
        } else if sw.type == .Pets {
            user.preference.pets = isOn
        } else if sw.type == .StopForPray {
            user.preference.prayingStop = isOn
        } else if sw.type == .FoodAndDrink {
            user.preference.food = isOn
        } else if sw.type == .Music {
            user.preference.music = isOn
        } else if sw.type == .Quran {
            user.preference.quran = isOn
        } else if sw.type == .Smoking {
            user.preference.smoking = isOn
        }
        menuItems[sw.tag].boolValue = isOn
    }
    
    @IBAction func cellTextfieldDidChangeText(txtfield: SignupTextField) {
        let value = txtfield.text?.trimmedString()
        let cellItem = menuItems[txtfield.tag]
        if txtfield.type == .FirstName {
            user.firstname = value
        } else if txtfield.type == .LastName {
            user.lastname = value
        } else if txtfield.type == .MobileNo {
            user.mobile = value
        }
        
        else if txtfield.type == . OldPassword {
            user.oldPassword = value
        } else if txtfield.type == .Password {
            user.password = value
        } else if txtfield.type == .ConfirmPass {
            user.confPass = value
        }
        
        else if txtfield.type == .WhatsApp {
            user.social.Whatsapp = value
        } else if txtfield.type == .Line {
            user.social.Line = value
        } else if txtfield.type == .Tango {
            user.social.Tango = value
        } else if txtfield.type == .Telegram {
            user.social.Telegram = value
        } else if txtfield.type == .Facebook {
            user.social.Facebook = value
        } else if txtfield.type == .Twitter {
            user.social.Twitter = value
        }
        cellItem.stringValue = value!
        
    }
    
    @IBAction func updateBtnClicked(sender: UIButton) {
        //Password change button
        if selectedMenu.type == .ChangePass {
            self.changePasswordWsCall()
        }
    }
    
}

//MARK: ImagePicker action for profile image setup
extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        imgVUserProfile.image = image
        isProfileImgeChanged = true
        picker.dismissViewControllerAnimated(true , completion: nil)
    }
}

//MARK: Tableview datasource and delegate
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if selectedMenu.type == .Profile || selectedMenu.type == .SocialLink {
            let cell = tableView.dequeueReusableCellWithIdentifier("nameCell") as! TVSignUpFormCell
            let item = menuItems[indexPath.row]
            cell.lblTitle.text = item.title
            cell.txtField.text = item.stringValue
            cell.txtField.placeholder = item.title
            cell.txtField.type = item.textfieldType
            cell.txtField.keyboardType = item.keyboardType
            cell.txtField.enabled = isEditMode ? item.txtFieldEnable : false
            cell.txtField.tag = indexPath.row
            return cell
        } else if selectedMenu.type == .ChangePass {
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier("passwordSaveBtnCell") as! TVSignUpFormCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("passwordCell") as! TVSignUpFormCell
                let item = menuItems[indexPath.row]
                cell.txtField.placeholder = item.title
                cell.txtField.text = item.stringValue
                cell.txtField.type = item.textfieldType
                cell.txtField.tag = indexPath.row
                return cell
            }

        } else if selectedMenu.type == .Details {
            let cell = tableView.dequeueReusableCellWithIdentifier("detailCell") as! TVSignUpFormCell
            let item = menuItems[indexPath.row]
            cell.lblTitle.text = item.title
            cell.lblSubTitle.text = item.stringValue
            return cell
        } else  { //Settings
            var cellIdentifier = "switchCell"
            if [0, 5, 7].contains(indexPath.row) {
                cellIdentifier = "switchAndTitleCell"
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! ProfileSettingCell
            let item = menuItems[indexPath.row]
            cell.lblHeader?.text = item.strHeader
            cell.lblTitle.text = item.title
            if item.settingType == .CommunicationLanguage || item.settingType ==  .SpeackingLanguage {
                cell.lblSubTitle.text = item.stringValue
                cell.lblSubTitle.hidden = false
                cell.switchBtn.hidden = true
            } else {
                cell.lblSubTitle.hidden = true
                cell.switchBtn.hidden = false
                cell.switchBtn.setOn(item.boolValue, animated: false)
                cell.switchBtn.type = item.settingType
                cell.switchBtn.tag = indexPath.row
            }
            cell.switchBtn.enabled = isEditMode
            cell.imgView.image = UIImage(named:item.iconName)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedMenu.type == .Settings {
            if [0, 5, 7].contains(indexPath.row) {
                return 80 * _widthRatio
            } else {
                return 55 * _widthRatio
            }
        }
        return 55 * _widthRatio
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedMenu.type == .Profile  {
            if isEditMode {
                self.view.endEditing(true)
                let item  = menuItems[indexPath.row]
                if item.textfieldType == .BirthDate {
                    self.openDatePicker(indexPath)
                    
                } else if item.textfieldType == .Gender {
                    self.showGenderPicker(indexPath)
                    
                } else if item.textfieldType == .Nationality {
                    self.openCountryList(.Nationality, indexPath: indexPath)
                    
                } else if item.textfieldType == .Country {
                    self.openCountryList(.Country, indexPath: indexPath)
                    
                } else if item.textfieldType == .AccountType {
                    self.openAccountTypeListVC(indexPath)
                }
            }
        } else if selectedMenu.type == .Settings {
            if isEditMode {
                let item = menuItems[indexPath.row]
                if item.settingType == .CommunicationLanguage || item.settingType == .SpeackingLanguage {
                    self.openLanguagesListVC(indexPath, type: item.settingType)
                }
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

//MARK: CollectionView datasource and delegate
extension ProfileViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Menus.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CVGenericeCell
       
        let menu = Menus[indexPath.row]
        cell.lblTitle.text = menu.title
        cell.imgView.image = UIImage(named: menu.imgName)
        cell.lblTitle.textColor = menu.selected ? UIColor.scHeaderColor() : UIColor.lightGrayColor()
        cell.imgView.tintColor = menu.selected ? UIColor.scHeaderColor() : UIColor.lightGrayColor()

        let lblLine = cell.viewWithTag(101)
        lblLine?.hidden = indexPath.row == (Menus.count - 1) ? true : false
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 75 * _widthRatio, height: 80 * _widthRatio)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
         selectedMenu.selected = false
        isEditMode = false
        editBtn.setImage(UIImage(named: "ic_edit"), forState: .Normal)
        editBtn.setTitle("", forState: .Normal)
        icnAddPhoto.hidden = true
       
        let menu = Menus[indexPath.row]
        menu.selected = true
        selectedMenu = menu
        collectionView.reloadData()
        self.changeMenuItems(menu)
    }
    
}

//MARK: Cell Item Actions
extension ProfileViewController {
    
    func showGenderPicker(indexPath: NSIndexPath) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let maleAction = UIAlertAction(title: "Male", style: .Default) { (action) in
           let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVSignUpFormCell
            let gender = "Male"
            cell?.txtField.text = gender
        }
        let femaleAction    = UIAlertAction(title: "Female", style: .Default) { (action) in
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVSignUpFormCell
           let gender = "Female"
            cell?.txtField.text = gender

        }
        sheet.addAction(maleAction)
        sheet.addAction(femaleAction)
        sheet.addAction(cancelAction)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    func openDatePicker(indexPath: NSIndexPath) {
        if !isLoading {
            isLoading = true
            let datepickerVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_DatePickerVC") as! VDatePickerVC
            datepickerVC.completionBlock = {(date) in
                if let date = date {
                    self.user.birthYear = self.dateFomator.stringFromDate(date)
                    let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVSignUpFormCell
                    cell?.txtField.text =  self.user.birthYear
                }
                self.isLoading = false
            }
            datepickerVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            self.presentViewController(datepickerVC, animated: true, completion: nil)
        }
    }
     
    func openCountryList(forAction : LocationSelectionForType, indexPath: NSIndexPath)  {
        let cListVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_CountryListVC") as! CountryListVC
       
        if forAction == .Nationality {
            cListVC.selectedCountryId = user.nationality.Id
            cListVC.titleString = "Nationality"
        } else  {
            cListVC.selectedCountryId = user.country.Id
            cListVC.titleString = "Countries"
        }
        
        cListVC.completionBlock = {(country) in
            if forAction == .Nationality {
                self.user.nationality = country
               let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVSignUpFormCell
                cell?.txtField.text = country.name
            } else  if forAction == .Country {
                self.user.country = country
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVSignUpFormCell
                cell?.txtField.text = country.name
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
    
    func openAccountTypeListVC(indexPath: NSIndexPath)  {
        let cListVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
        cListVC.preSelectedIDs = [user.accountType.Id]
        cListVC.listType = ListType.AccountType
        cListVC.completionBlock = {(items) in
            let acType = items.first!.obj as! AccountType
            self.user.accountType = acType
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVSignUpFormCell
            cell?.txtField.text = acType.name
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
    
    func openLanguagesListVC(indexPath: NSIndexPath, type: UserPreferenceType)  {
        let cListVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.Language
        if type == .CommunicationLanguage {
        } else {
            cListVC.enableMultipleChoice = true
        }
        cListVC.completionBlock = {(items) in
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? ProfileSettingCell
            if type == .CommunicationLanguage {
                self.user.preference.communicationLanguage = items.first!.name
                cell?.lblSubTitle.text = items.first!.name
                
            } else if type == .SpeackingLanguage {
                let lngArr = items.map({ (item) -> String in
                    return item.code
                })
                self.user.preference.speackingLanguage = lngArr
                cell?.lblSubTitle.text = lngArr.joinWithSeparator(", ")
                
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }

}

//MARK: Notifications
extension ProfileViewController {
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

//MARK: UITextField delegate and actions
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

//MARK: Other
extension ProfileViewController {
    
    func setUserInfo() {
        lblFullName.text = user.fullname
        lblGender.text = user.gender
        lblBirthDate.text = user.birthYear
        imgVUserProfile.setImageWithURL(NSURL(string: user.photo)!, placeholderImage: user.placeholderImage)
        imgVCover.setImageWithURL(NSURL(string: user.photo)!,placeholderImage: user.placeholderImage)
    }
    
    //MARK: Set Menu Items and UI as per seleted menu
    func changeMenuItems(menu: Menu)  {
        if menu.type == .Profile {
            menuItems = [CellItem(title: "First Name",      value: user.firstname,      txtFieldType: .FirstName),
                         CellItem(title: "Last Name",       value: user.lastname,       txtFieldType: .LastName),
                         CellItem(title: "Gender",          value: user.gender,         txtFieldType: .Gender, enable: false),
                         CellItem(title: "Birth Year",      value: user.birthYear,      txtFieldType: .BirthDate, enable: false),
                         CellItem(title: "Mobile",          value: user.mobile,         txtFieldType: .MobileNo, keyboardType: .NumberPad),
                         CellItem(title: "Nationality",     value: user.nationality.name,  txtFieldType: .Nationality, enable: false),
                         CellItem(title: "Country",         value: user.country.name,      txtFieldType: .Country, enable: false),
                         CellItem(title: "Account Type",    value: user.accountType.name,  txtFieldType: .AccountType, enable: false)]
            
        } else if menu.type == .ChangePass {
            menuItems = [CellItem(title: "Old Password",    value: user.oldPassword,    txtFieldType: .OldPassword),
                         CellItem(title: "Password",        value: user.password,       txtFieldType: .Password),
                         CellItem(title: "Confirm Password",value: user.confPass,       txtFieldType: .ConfirmPass),
                         CellItem(title: "Update",          value: "Update",            txtFieldType: .None)]
            
        } else if menu.type == .SocialLink {
            menuItems = [CellItem(title: "WhatsApp",    value: user.social.Whatsapp,    txtFieldType: .WhatsApp),
                         CellItem(title: "Line",        value: user.social.Line,        txtFieldType: .Line),
                         CellItem(title: "Tango",       value: user.social.Tango,       txtFieldType: .Tango),
                         CellItem(title: "Telegram",    value: user.social.Telegram,    txtFieldType: .Telegram),
                         CellItem(title: "Facebook",    value: user.social.Facebook,    txtFieldType: .Facebook),
                         CellItem(title: "Twitter",     value: user.social.Twitter,     txtFieldType: .Twitter)]
            
        } else if menu.type == .Details {
            menuItems = [CellItem(title: "Member Since:",       value: user.createDate,             txtFieldType: .None),
                         CellItem(title: "Last Login:",         value: "25/04/2016",                txtFieldType: .None),
                         CellItem(title: "Last Activity Date:", value: "25/04/2016",                txtFieldType: .None),
                         CellItem(title: "Number of Travels:",  value: "15",                        txtFieldType: .None),
                         CellItem(title: "Contacts:",           value: "12",                        txtFieldType: .None),
                         CellItem(title: "Email:",              value: user.EmailVerifiedString,    txtFieldType: .None),
                         CellItem(title: "Phone Number:",       value: user.MobileVerifiedString,   txtFieldType: .None),
                         CellItem(title: "Facebook:",           value: user.FacebookVeriedString,   txtFieldType: .None)]
            
        } else  { //Settings
            
            menuItems = [CellItem(title: "Show email to others",    value: user.preference.showEmail,       settingType: .ShowEmail,        icon: "ic_show_email", header: "General"),
                         CellItem(title: "Show mobile to others",   value: user.preference.showMobile,      settingType: .ShowMobile,       icon: "ic_show_mobile"),
                         CellItem(title: "Visible in search",       value: user.preference.visibleInSearch, settingType: .VisibleInSearch,  icon: "ic_visible_search"),
                         CellItem(title: "Accept special order",    value: user.preference.specialOrder,    settingType: .SpecialOrder,     icon: "ic_accept_special"),
                         CellItem(title: "Accept Monitoring",       value: user.preference.acceptMonitring, settingType: .AcceptMonitring,  icon: "ic_monitoring"),
                         
                         CellItem(title: "Communication Language",  value: "English",           settingType: .CommunicationLanguage,    icon: "ic_communication_lang", header: "Language"),
                         CellItem(title: "Speaking Language",       value: "English, French",   settingType: .SpeackingLanguage,        icon: "ic_speaking_lang"),
                         
                         CellItem(title: "Children",        value: user.preference.kids,        settingType: .Children,     icon: "ic_childreb", header: "My Rules"),
                         CellItem(title: "Pets",            value: user.preference.pets,        settingType: .Pets,         icon: "ic_pets"),
                         CellItem(title: "Stop for pray",   value: user.preference.prayingStop, settingType: .StopForPray,  icon: "ic_pray"),
                         CellItem(title: "Food and Drinks", value: user.preference.food,        settingType: .FoodAndDrink, icon: "ic_food_drink"),
                         CellItem(title: "Music",           value: user.preference.music,       settingType: .Music,        icon: "ic_music"),
                         CellItem(title: "Quran",           value: user.preference.quran,       settingType: .Quran,        icon: "ic_quran"),
                         CellItem(title: "Smoking",         value: user.preference.smoking,     settingType: .Smoking,      icon: "ic_smoking")]
            
        }
        
        tableView.reloadData()
    }

}

//MARK: Webservice call 
extension ProfileViewController {
    //Change user Password
    func changePasswordWsCall()  {
        let process = user.validateChangePassProcess()
        if process.isValid {
            self.showCentralGraySpinner()
            let params = ["Email": user.email,
                          "OldPassword": user.oldPassword,
                          "NewPassword": user.password]
            wsCall.changePassword(params, block: { (response, statusCode) in
                if response.isSuccess {
                    // success code
                    showToastMessage("", message: response.message!)
                    self.user.password = ""
                    self.user.oldPassword = ""
                    self.user.confPass = ""
                    self.changeMenuItems(self.selectedMenu)
                } else {
                    //error message
                    showToastMessage("", message: kOldPassIsInvalid)
                }
                self.hideCentralGraySpinner()
            })
            
        } else  {
            showToastMessage("", message: process.msg)
        }
    }
    
    //Update Profile Info
    func updateProfile() {
        self.showCentralGraySpinner()
        user.updateProfileInfo { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    var info = json["Object"] as! [String : AnyObject]
                    me = User(info: info)
                    self.user = me
                    self.changeMenuItems(self.selectedMenu)
                    if self.isProfileImgeChanged {
                        me.updateProfileImage(self.imgVUserProfile.image!.mediumQualityJPEGNSData, block: { (path) in
                            info["Photo"] = path ?? ""
                            archiveObject(info, key: kLoggedInUserKey)
                            self.isProfileImgeChanged = false
                            self.setUserInfo()
                            showToastMessage("", message: kProfileUpdateSuccess)
                            _defaultCenter.postNotificationName(kProfileUpdateNotificationKey, object: nil)
                        })
                    } else {
                        archiveObject(info, key: kLoggedInUserKey)
                        self.setUserInfo()
                        showToastMessage("", message: kProfileUpdateSuccess)
                        _defaultCenter.postNotificationName(kProfileUpdateNotificationKey, object: nil)
                    }
                    
                }
            } else {
                showToastMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Update Social Links
    func updateSocialLinks() {
        self.showCentralGraySpinner()
        user.updateSocialInfo { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    let info = json["Object"] as! [String : AnyObject]
                    let social = UserSocial(info: info)
                    me.social = social
                    self.changeMenuItems(self.selectedMenu)
                    archiveObject(info, key: kLoggedInUserKey)
                    showToastMessage("", message: kSocialUpdatedSuccess)
                }
            } else {
                showToastMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Update User Preference from Setting tab
    func updateUserPreference() {
        self.showCentralGraySpinner()
        user.updateUserPreference { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    let info = json["Object"] as! [String : AnyObject]
                    let preference = UserPreference(info: info)
                    me.preference = preference
                    self.changeMenuItems(self.selectedMenu)
                    archiveObject(info, key: kLoggedInUserKey)
                    showToastMessage("", message: kPreferenceSettingSucess)
                }
            } else {
                showToastMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
        }
    }
}


//MARK:---------------------------------------------
//Other Important classes and enum for profile Screen


class CellItem {
    var strHeader: String = ""
    var title: String = ""
    var stringValue: String = ""
    var boolValue = false
    var textfieldType: TextFieldType!
    var settingType: UserPreferenceType!
    var keyboardType : UIKeyboardType!
    var iconName: String = ""
    var txtFieldEnable = true
   
    init(title: String, value: String, txtFieldType: TextFieldType, keyboardType: UIKeyboardType = .Default, icon: String = "" , enable: Bool = true) {
        self.title = title
        self.stringValue = value
        self.textfieldType = txtFieldType
        self.keyboardType = keyboardType
        self.iconName = icon
        txtFieldEnable = enable
    }
    
    init(title: String, value: Bool, settingType: UserPreferenceType , icon: String, header: String = "") {
        self.title = title
        self.boolValue = value
        self.settingType = settingType
        self.iconName  = icon
        self.strHeader = header
    }
   
    init(title: String, value: String, settingType: UserPreferenceType , icon: String, header: String = "") {
        self.title = title
        self.stringValue = value
        self.settingType = settingType
        self.iconName  = icon
        self.strHeader = header
    }


}
