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
    @IBOutlet var btnShutter: UIButton!
    
    var datePickerView: VDatePickerView!

    var selectedIndexPath: NSIndexPath?
    
    var user : User!
    var selectedMenu: Menu!
    
    var isLoading   = false
    var isEditMode  = false
    var isProfileImgeChanged = false
    
    let Menus = [Menu(title: "profile".localizedString(),         imgName: "ic_profile_selected", selected: true, type: .Profile),
                 Menu(title: "change_password".localizedString(), imgName: "ic_change_password", type: .ChangePass),
                 Menu(title: "social_link".localizedString(),     imgName: "ic_social_link", type: .SocialLink),
                 Menu(title: "details".localizedString(),         imgName: "ic_detail", type: .Details),
                 Menu(title: "settings".localizedString(),        imgName: "ic_settings", type: .Settings)]
    
    var menuItems = [CellItem]()
    lazy var dateFomator: NSDateFormatter = { //formator for birthdate
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDatePickerView()
        
        user = me.copy() as! User
        selectedMenu = Menus[0]
        changeMenuItems(selectedMenu)
        setUserInfo()
        icnAddPhoto.drawShadow()
        imgVUserProfile.drawShadowWithCornerRadius()
    }

    override func viewWillAppear(animated: Bool) {
        //Add Keybaord observeration
        _defaultCenter.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        _defaultCenter.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
    
    //Edit btn action for change mode (edit or normal mode).
    @IBAction func editBtnCliclicked(sender: UIButton) {
        if isEditMode {
            if selectedMenu.type == .Profile {
                let process = user.validateEditPersonalInfo()
                if process.isValid {
                    self.updateProfileAPICall()
                } else {
                    showToastErrorMessage("", message: process.message)
                    return
                }
            } else if selectedMenu.type == .SocialLink {
                self.updateSocialLinksAPICall()
            } else if selectedMenu.type == .Settings {
                self.updateUserPreferenceAPICall()
            }
            icnAddPhoto.hidden = true
            editBtn.setImage(UIImage(named: "ic_edit"), forState: .Normal)
            editBtn.setTitle("", forState: .Normal)
        } else  {
            editBtn.setImage(nil, forState: .Normal)
            editBtn.setTitle("save".localizedString(), forState: .Normal)
            tableView.reloadData()
            if selectedMenu.type == .Profile {
                icnAddPhoto.hidden = false
            }
        }
        isEditMode = !isEditMode
        changeShutterBtnSelector()
    }
    
    //Action for pick profile image.
    @IBAction func profileImgBtnClicked(sender: UIButton) {
        if isEditMode && selectedMenu.type == .Profile {
            showActionForImagePick()
        }
    }
    
    //UISwitch btn clicked in side tableview cell.
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
    
    //TextField text change action.
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
    
    //Save Changes btn clicked.
    @IBAction func updateBtnClicked(sender: UIButton) {
        //Password change button
        if selectedMenu.type == .ChangePass {
            self.changePasswordWsCall()
        }
    }
    
    //Back btn clicked. It will turn back to user in normal mode from edit mode.
    @IBAction func backBtnClicked(sender: UIButton) {
        user = me.copy() as! User //reset user info if any changes made.
        isEditMode = !isEditMode
        changeShutterBtnSelector()
        changeMenuItems(selectedMenu)
        setUserInfo()
    }
    
    //Navigate to select country dial code for mobile number.
    @IBAction func dialCodeBtnClicked(sender: UIButton) {
        if isEditMode {
            let indexpath = NSIndexPath(forItem: sender.tag, inSection: 0)
            self.openCountryList(.DialCodeAction, indexPath: indexpath)
        }
    }
}

//MARK: ImagePicker action for profile image setup
extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            let item = menuItems[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(item.cellName) as! TVSignUpFormCell
            cell.lblTitle.text = item.title
            cell.txtField.text = item.stringValue
            cell.txtField.placeholder = item.title
            cell.txtField.type = item.textfieldType
            cell.txtField.keyboardType = item.keyboardType
            cell.txtField.enabled = isEditMode ? item.txtFieldEnable : false
            cell.txtField.tag = indexPath.row
            cell.button?.tag = indexPath.row
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
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! TblSwitchBtnCell
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
                    selectedIndexPath = indexPath
                    self.showDatePickerView()
                    
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

//MARK: Actions for Cell item
extension ProfileViewController {
    
    //Open actionsheet for Gender
    func showGenderPicker(indexPath: NSIndexPath) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "cancel".localizedString(), style: .Cancel, handler: nil)
        
        let maleAction = UIAlertAction(title: "male".localizedString(), style: .Default) { (action) in
           let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVSignUpFormCell
            let gender = "male".localizedString()
            self.user.gender = gender
            cell?.txtField.text = gender
        }
        let femaleAction    = UIAlertAction(title: "female".localizedString(), style: .Default) { (action) in
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVSignUpFormCell
           let gender = "female".localizedString()
            self.user.gender = gender
            cell?.txtField.text = gender

        }
        sheet.addAction(maleAction)
        sheet.addAction(femaleAction)
        sheet.addAction(cancelAction)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    //This func navigate the user to country list screen. 
    //Where user can select country for user field Nationlity, country, and for DialCode.
    func openCountryList(forAction : LocationSelectionForType, indexPath: NSIndexPath)  {
        let cListVC = VListViewController.loadFromNib()
        cListVC.keyForTitle = "CountryName"
        cListVC.keyForId = "CountryID"
        cListVC.apiName = APIName.GetActiveCountries
       
        if forAction == .Nationality {
            cListVC.preSelectedIDs = [user.nationality.Id]
            cListVC.screenTitle = "nationality".localizedString()
        } else if forAction == .DialCodeAction {
            cListVC.keyForId = "CountryDialCode"

            cListVC.preSelectedIDs = [user.mobileCountryCode]
            cListVC.screenTitle = "country_dial_code".localizedString()
            
        } else  {
            cListVC.preSelectedIDs = [user.country.Id]
            cListVC.screenTitle = "countries".localizedString()
        }
        
        cListVC.completionBlock = {(items) in
                if let item = items.first {
                    let country = Country(info: item.obj as! [String : AnyObject])
                    if forAction == .Nationality {
                        self.user.nationality = country
                        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVSignUpFormCell
                        cell?.txtField.text = country.name
                        
                    } else if forAction == .DialCodeAction {
                        self.user.mobileCountryCode = country.dialCode
                        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVSignUpFormCell
                        cell?.txtField.text = country.name
                        
                    } else  if forAction == .Country {
                        self.user.country = country
                        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVSignUpFormCell
                        cell?.txtField.text = country.name
                    }
                    self.changeMenuItems(self.selectedMenu)
                }
        }
        self.presentViewController(cListVC, animated: true, completion: nil)
    }
    
    
    //Navigate to pick User account type.
    func openAccountTypeListVC(indexPath: NSIndexPath)  {
        let cListVC = VListViewController.loadFromNib()
        cListVC.preSelectedIDs = [user.accountType.Id]
        cListVC.apiName = APIName.GetAccountTypes
        cListVC.keyForId = "ID"
        cListVC.keyForTitle = "Name"
        
        cListVC.completionBlock = {(items) in
            if let acType = items.first!.obj as? [String : AnyObject] {
                let account = AccountType(info: acType)
                self.user.accountType = account
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVSignUpFormCell
                cell?.txtField.text = account.name
                self.changeMenuItems(self.selectedMenu)
            }
        }
        self.presentViewController(cListVC, animated: true, completion: nil)
    }
    
    //Navigate to pick user preference language.
    func openLanguagesListVC(indexPath: NSIndexPath, type: UserPreferenceType)  {
        let cListVC = VListViewController.loadFromNib()
        cListVC.screenTitle = "Language".localizedString()
        cListVC.apiName = APIName.GetLanguages
        cListVC.keyForId = "ID"
        cListVC.keyForTitle = "Name"
        
        if type == .CommunicationLanguage {
            cListVC.preSelectedIDs = [user.preference.defaultLanguage?.id ?? ""]
        } else {
            cListVC.enableMultipleChoice = true
            let langIds = self.user.preference.speakingLanguages.map({ (lang) -> String in
                return lang.id
            })

           cListVC.preSelectedIDs = langIds
        }
        
        cListVC.completionBlock = {(items) in
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TblSwitchBtnCell
            if type == .CommunicationLanguage {
                let jsonLang = items.first!.obj as! [String : AnyObject]
                self.user.preference.defaultLanguage = Language(jsonLang)
                cell?.lblSubTitle.text = items.first!.name

            } else if type == .SpeackingLanguage {
                
                let lngArr = items.map({ (item) -> Language in
                    let jsonLang = item.obj as! [String : AnyObject]
                    let lang = Language(jsonLang)
                    return lang
                })
                self.user.preference.speakingLanguages = lngArr
                let langs = lngArr.map({ (lang) -> String in
                    return lang.code
                })

                cell?.lblSubTitle.text = langs.joinWithSeparator(", ")


            }
            self.changeMenuItems(self.selectedMenu)
        }
        self.presentViewController(cListVC, animated: true, completion: nil)
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


//MARK: Other
extension ProfileViewController {
    
    func setUserInfo() {
        lblFullName.text = user.fullname
        lblGender.text = user.gender
        let birthdDate = dateFormator.dateString(user.birthDate, fromFomat: "yyyy-MM-dd", style: NSDateFormatterStyle.MediumStyle)

        lblBirthDate.text = birthdDate
        imgVUserProfile.setImageWithURL(NSURL(string: user.photo)!, placeholderImage: user.placeholderImage)
        //imgVCover.setImageWithURL(NSURL(string: user.photo)!,placeholderImage: user.placeholderImage)
    }
    
    //func for set action of shutter button as per profile form's mode
    func changeShutterBtnSelector() {
        if isEditMode {
            btnShutter.removeTarget(self, action: #selector(self.shutterAction(_:)), forControlEvents: .TouchUpInside)
            btnShutter.addTarget(self, action: #selector(self.backBtnClicked(_:)), forControlEvents: .TouchUpInside)
            btnShutter.setImage(UIImage(named: "ic_back_arrow"), forState: .Normal)
        } else {
            self.view.endEditing(true)
            btnShutter.removeTarget(self, action: #selector(self.backBtnClicked(_:)), forControlEvents: .TouchUpInside)
            btnShutter.addTarget(self, action: #selector(self.shutterAction(_:)), forControlEvents: .TouchUpInside)
            btnShutter.setImage(UIImage(named: "ic_menu"), forState: .Normal)
            icnAddPhoto.hidden = true
            editBtn.setImage(UIImage(named: "ic_edit"), forState: .Normal)
            editBtn.setTitle("", forState: .Normal)
        }
    }
    
    //MARK: Set Menu Items and UI as per seleted menu
    func changeMenuItems(menu: Menu)  {
        if menu.type == .Profile {
            menuItems = [CellItem(title: "first_name".localizedString(), value: user.firstname, txtFieldType: .FirstName),
                         CellItem(title: "last_name".localizedString(), value: user.lastname, txtFieldType: .LastName),
                         CellItem(title: "gender".localizedString(), value: user.gender, txtFieldType: .Gender, enable: false)]
            
            let birthdDate = dateFormator.dateString(user.birthDate, fromFomat: "yyyy-MM-dd", style: NSDateFormatterStyle.MediumStyle)
            menuItems += [CellItem(title: "birth_date".localizedString(), value: birthdDate, txtFieldType: .BirthDate, enable: false)]
           
            menuItems +=   [CellItem(title: "+" + user.mobileCountryCode,  value: user.mobile, txtFieldType: .MobileNo, keyboardType: .NumberPad, cellName: "mobileCell"),
                            CellItem(title: "nationality".localizedString(), value: user.nationality.name,  txtFieldType: .Nationality, enable: false),
                            CellItem(title: "country".localizedString(), value: user.country.name,      txtFieldType: .Country, enable: false),
                            CellItem(title: "account_type".localizedString(), value: user.accountType.name,  txtFieldType: .AccountType, enable: false)]
            
        } else if menu.type == .ChangePass {
            menuItems = [CellItem(title: "old_password".localizedString(),    value: user.oldPassword,    txtFieldType: .OldPassword),
                         CellItem(title: "password".localizedString(),        value: user.password,       txtFieldType: .Password),
                         CellItem(title: "confirm_password".localizedString(),value: user.confPass,       txtFieldType: .ConfirmPass),
                         CellItem(title: "Update",          value: "Update",            txtFieldType: .None)]
            
        } else if menu.type == .SocialLink {
            menuItems = [CellItem(title: "WhatsApp".localizedString(),    value: user.social.Whatsapp,    txtFieldType: .WhatsApp),
                         CellItem(title: "Line".localizedString(),        value: user.social.Line,        txtFieldType: .Line),
                         CellItem(title: "Tango".localizedString(),       value: user.social.Tango,       txtFieldType: .Tango),
                         CellItem(title: "Telegram".localizedString(),    value: user.social.Telegram,    txtFieldType: .Telegram),
                         CellItem(title: "Facebook".localizedString(),    value: user.social.Facebook,    txtFieldType: .Facebook),
                         CellItem(title: "Twitter".localizedString(),     value: user.social.Twitter,     txtFieldType: .Twitter)]
            
        } else if menu.type == .Details {
            menuItems = [CellItem(title: "Member_Since".localizedString() + ":",       value: user.createDate,                 txtFieldType: .None),
                         CellItem(title: "Last_Login".localizedString() + ":",         value: user.lastLoginTime,              txtFieldType: .None),
                         CellItem(title: "Last_Activity_Date".localizedString() + ":", value: user.lastLoginTime,              txtFieldType: .None),
                         CellItem(title: "Number_of_Travels".localizedString() + ":",  value: user.numberOfTravels.ToString(), txtFieldType: .None),
                         CellItem(title: "Contacts".localizedString() + ":",           value: user.numberOfContacts.ToString(),txtFieldType: .None),
                         CellItem(title: "Email".localizedString() + ":",              value: user.EmailVerifiedString,        txtFieldType: .None),
                         CellItem(title: "Phone_Number".localizedString() + ":",       value: user.MobileVerifiedString,       txtFieldType: .None),
                         CellItem(title: "Facebook".localizedString() + ":",           value: user.FacebookVeriedString,       txtFieldType: .None)]
            
        } else  { //Settings
            
            menuItems = [CellItem(title: "Show_email_to_others".localizedString(),    value: user.preference.showEmail,       settingType: .ShowEmail,        icon: "ic_show_email", header: "General".localizedString()),
                         CellItem(title: "Show_mobile_to_others".localizedString(),   value: user.preference.showMobile,      settingType: .ShowMobile,       icon: "ic_show_mobile"),
                         CellItem(title: "Visible_in_search".localizedString(),       value: user.preference.visibleInSearch, settingType: .VisibleInSearch,  icon: "ic_visible_search"),
                         CellItem(title: "Accept_special_order".localizedString(),    value: user.preference.specialOrder,    settingType: .SpecialOrder,     icon: "ic_accept_special"),
                         CellItem(title: "Accept_Monitoring".localizedString(),       value: user.preference.acceptMonitring, settingType: .AcceptMonitring,  icon: "ic_monitoring"),
                         
                         CellItem(title: "Communication_Language".localizedString(),  value: user.preference.defaultLanguage?.name ?? "",           settingType: .CommunicationLanguage,    icon: "ic_communication_lang", header: "Language".localizedString())]
            
            let langs = user.preference.speakingLanguages.map({ (lang) -> String in
                return lang.code
            })
            menuItems +=       [ CellItem(title: "Speaking_Language".localizedString(),       value: langs.joinWithSeparator(", "),   settingType: .SpeackingLanguage,        icon: "ic_speaking_lang")]
            
            
            menuItems +=       [CellItem(title: "Children".localizedString(),        value: user.preference.kids,        settingType: .Children,     icon: "ic_childreb", header: "My_Rules".localizedString()),
                                CellItem(title: "Pets".localizedString(),            value: user.preference.pets,        settingType: .Pets,         icon: "ic_pets"),
                                CellItem(title: "Stop_for_pray".localizedString(),   value: user.preference.prayingStop, settingType: .StopForPray,  icon: "ic_pray"),
                                CellItem(title: "Food_and_Drinks".localizedString(), value: user.preference.food,        settingType: .FoodAndDrink, icon: "ic_food_drink"),
                                CellItem(title: "Music".localizedString(),           value: user.preference.music,       settingType: .Music,        icon: "ic_music"),
                                CellItem(title: "Quran".localizedString(),           value: user.preference.quran,       settingType: .Quran,        icon: "ic_quran"),
                                CellItem(title: "Smoking".localizedString(),         value: user.preference.smoking,     settingType: .Smoking,      icon: "ic_smoking")]
            
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
            let params = ["OldPassword": user.oldPassword,
                          "NewPassword": user.password]
            wsCall.changePassword(params, block: { (response, statusCode) in
                if response.isSuccess {
                    // success code
                    showToastMessage("", message: response.message)
                    self.user.password = ""
                    self.user.oldPassword = ""
                    self.user.confPass = ""
                    self.changeMenuItems(self.selectedMenu)
                } else {
                    //error message
                    showToastErrorMessage("", message: "kOldPassIsInvalid".localizedString())
                }
                self.hideCentralGraySpinner()
            })
            
        } else  {
            showToastErrorMessage("", message: process.msg)
        }
    }
    
    //Update Profile Info
    func updateProfileAPICall() {
        self.showCentralGraySpinner()
        user.updateProfileInfo { (response, flag) in
            self.hideCentralGraySpinner()
            if response.isSuccess {
                if let json = response.json {
                    var info = json["Object"] as! [String : AnyObject]
                    me.resetUserInfo(info)
                    self.user = me.copy() as! User
                    self.changeMenuItems(self.selectedMenu)
                    
                    if self.isProfileImgeChanged {
                        self.showCentralGraySpinner()
                        me.updateProfileImage(self.imgVUserProfile.image!.mediumQualityJPEGNSData, block: { (path) in
                            info["Photo"] = path ?? ""
                            self.user.photo = me.photo
                            archiveObject(info, key: kLoggedInUserKey)
                            self.isProfileImgeChanged = false
                            self.setUserInfo()
                            showToastMessage("", message: "kProfileUpdateSuccess".localizedString())
                            _defaultCenter.postNotificationName(kProfileUpdateNotificationKey, object: nil)
                            self.hideCentralGraySpinner()
                        })
                        
                    } else {
                        archiveObject(info, key: kLoggedInUserKey)
                        self.setUserInfo()
                        showToastMessage("", message: "kProfileUpdateSuccess".localizedString())
                        _defaultCenter.postNotificationName(kProfileUpdateNotificationKey, object: nil)
                    }
                    
                }
            } else {
                showToastErrorMessage("", message: response.message)
            }
        }
    }
    
    //Update Social Links
    func updateSocialLinksAPICall() {
        self.showCentralGraySpinner()
        user.updateSocialInfo { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    let info = json["Object"] as! [String : AnyObject]
                    let social = UserSocial(info: info)
                    me.social = social
                    self.changeMenuItems(self.selectedMenu)
                    archiveObject(info, key: kLoggedInUserKey)
                    showToastMessage("", message: "kSocialUpdatedSuccess".localizedString())
                }
            } else {
                showToastErrorMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Update User Preference from Setting tab
    func updateUserPreferenceAPICall() {
        self.showCentralGraySpinner()
        user.updateUserPreference { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    let info = json["Object"] as! [String : AnyObject]
                    let preference = UserPreference(info: info)
                    me.preference = preference
                    self.changeMenuItems(self.selectedMenu)
                    archiveObject(info, key: kLoggedInUserKey)
                    showToastMessage("", message: "kPreferenceSettingSucess".localizedString())
                }
            } else {
                showToastErrorMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
}


//MARK: DatePicker Methods
extension ProfileViewController {
    //load picker view from nib file
    func loadDatePickerView() {
        let nibViews = NSBundle.mainBundle().loadNibNamed("VDatePickerView", owner: nil, options: nil)!
        self.datePickerView = nibViews[0] as! VDatePickerView
        self.datePickerSelectionBlockSetup()
        self.view.addSubview(datePickerView)
    }

    func showDatePickerView() {
        let dateBefor16Years = NSDate().dateByAddingYearOffset(-16) //Validation for user should be 16 years old.
        datePickerView.maxDate = dateBefor16Years
        datePickerView.show()
    }
    
    //func for setup datePicker date selection callback block
    func datePickerSelectionBlockSetup() {
        datePickerView.dateSelectionBlock = {[weak self](date, forType) in
            if let selff = self {
                selff.user.birthDate = selff.dateFomator.stringFromDate(date, format: "yyyy-MM-dd")
                let cell = selff.tableView.cellForRowAtIndexPath(selff.selectedIndexPath!) as? TVSignUpFormCell
                cell?.txtField.text =  selff.dateFomator.stringFromDate(date, style: .MediumStyle)
            }
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
    var cellName = ""
    
    init(title: String, value: String, txtFieldType: TextFieldType, keyboardType: UIKeyboardType = .Default, icon: String = "" , enable: Bool = true, cellName: String = "nameCell") {
        self.title = title
        self.stringValue = value
        self.textfieldType = txtFieldType
        self.keyboardType = keyboardType
        self.iconName = icon
        txtFieldEnable = enable
        self.cellName = cellName
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
