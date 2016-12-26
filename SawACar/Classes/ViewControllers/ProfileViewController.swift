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

    var selectedIndexPath: IndexPath?
    
    var user : LoggedInUser!
    var selectedMenu: Menu!
    
    var isLoading   = false
    var isEditMode  = false
    var isProfileImgeChanged = false
    
    let Menus = [Menu(title: "profile".localizedString(),         imgName: "ic_profile_selected", selected: true, type: .profile),
                 Menu(title: "change_password".localizedString(), imgName: "ic_change_password", type: .changePass),
                 Menu(title: "social_link".localizedString(),     imgName: "ic_social_link", type: .socialLink),
                 Menu(title: "details".localizedString(),         imgName: "ic_detail", type: .details),
                 Menu(title: "settings".localizedString(),        imgName: "ic_settings", type: .settings)]
    
    var menuItems = [CellItem]()
    lazy var dateFomator: DateFormatter = { //formator for birthdate
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDatePickerView()
        
        user = me.copy() as! LoggedInUser
        getMyInfoAPICall()
        setUserInfo()

        selectedMenu = Menus[0]
        changeMenuItems(selectedMenu)
        icnAddPhoto.drawShadow()
        imgVUserProfile.drawShadowWithCornerRadius()
    }

    override func viewWillAppear(_ animated: Bool) {
        //Add Keybaord observeration
        _defaultCenter.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        _defaultCenter.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
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
    @IBAction func editBtnCliclicked(_ sender: UIButton) {
        if isEditMode {
            if selectedMenu.type == .profile {
                let process = user.validateEditPersonalInfo()
                if process.isValid {
                    self.updateProfileAPICall()
                } else {
                    showToastErrorMessage("", message: process.message)
                    return
                }
            } else if selectedMenu.type == .socialLink {
                self.updateSocialLinksAPICall()
            } else if selectedMenu.type == .settings {
                self.updateUserPreferenceAPICall()
            }
            icnAddPhoto.isHidden = true
            editBtn.setImage(UIImage(named: "ic_edit"), for: UIControlState())
            editBtn.setTitle("", for: UIControlState())
        } else  {
            editBtn.setImage(nil, for: UIControlState())
            editBtn.setTitle("save".localizedString(), for: UIControlState())
            tableView.reloadData()
            if selectedMenu.type == .profile {
                icnAddPhoto.isHidden = false
            }
        }
        isEditMode = !isEditMode
        changeShutterBtnSelector()
    }
    
    //Action for pick profile image.
    @IBAction func profileImgBtnClicked(_ sender: UIButton) {
        if isEditMode && selectedMenu.type == .profile {
            showActionForImagePick()
        }
    }
    
    //UISwitch btn clicked in side tableview cell.
    @IBAction func cellSwitchBtnTapped(_ sw: SettingSwitch) {
        let isOn = sw.isOn
        if sw.type == .showEmail {
            user.preference.showEmail = isOn
        } else if sw.type == .showMobile {
            user.preference.showMobile = isOn
        } else if sw.type == .visibleInSearch {
            user.preference.visibleInSearch = isOn
        } else if sw.type == .specialOrder {
            user.preference.specialOrder = isOn
        } else if sw.type == .acceptMonitring {
            user.preference.acceptMonitring = isOn
        } else if sw.type == .children {
            user.preference.kids = isOn
        } else if sw.type == .pets {
            user.preference.pets = isOn
        } else if sw.type == .stopForPray {
            user.preference.prayingStop = isOn
        } else if sw.type == .foodAndDrink {
            user.preference.food = isOn
        } else if sw.type == .music {
            user.preference.music = isOn
        } else if sw.type == .quran {
            user.preference.quran = isOn
        } else if sw.type == .smoking {
            user.preference.smoking = isOn
        }
        menuItems[sw.tag].boolValue = isOn
    }
    
    //TextField text change action.
    @IBAction func cellTextfieldDidChangeText(_ txtfield: SignupTextField) {
        let value = txtfield.text?.trimmedString()
        let cellItem = menuItems[txtfield.tag]
        if txtfield.type == .firstName {
            user.firstname = value
        } else if txtfield.type == .lastName {
            user.lastname = value
        } else if txtfield.type == .mobileNo {
            user.mobile = value
        }
        
        else if txtfield.type == . oldPassword {
            user.oldPassword = value
        } else if txtfield.type == .password {
            user.password = value
        } else if txtfield.type == .confirmPass {
            user.confPass = value
        }
        
        else if txtfield.type == .whatsApp {
            user.social.Whatsapp = value
        } else if txtfield.type == .line {
            user.social.Line = value
        } else if txtfield.type == .tango {
            user.social.Tango = value
        } else if txtfield.type == .telegram {
            user.social.Telegram = value
        } else if txtfield.type == .facebook {
            user.social.Facebook = value
        } else if txtfield.type == .twitter {
            user.social.Twitter = value
        }
        cellItem.stringValue = value!

    }
    
    //Save Changes btn clicked.
    @IBAction func updateBtnClicked(_ sender: UIButton) {
        //Password change button
        if selectedMenu.type == .changePass {
            self.changePasswordWsCall()
        }
    }
    
    //Back btn clicked. It will turn back to user in normal mode from edit mode.
    @IBAction func backBtnClicked(_ sender: UIButton) {
        user = me.copy() as! LoggedInUser //reset user info if any changes made.
        isEditMode = !isEditMode
        changeShutterBtnSelector()
        changeMenuItems(selectedMenu)
        setUserInfo()
    }
    
    //Navigate to select country dial code for mobile number.
    @IBAction func dialCodeBtnClicked(_ sender: UIButton) {
        if isEditMode {
            let indexpath = IndexPath(item: sender.tag, section: 0)
            self.openCountryList(.dialCodeAction, indexPath: indexpath)
        }
    }
}

//MARK: ImagePicker action for profile image setup
extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        imgVUserProfile.image = image
        isProfileImgeChanged = true
        picker.dismiss(animated: true , completion: nil)
    }
}

//MARK: Tableview datasource and delegate
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedMenu.type == .profile || selectedMenu.type == .socialLink {
            let item = menuItems[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: item.cellName) as! TVSignUpFormCell
            cell.lblTitle.text = item.title
            cell.txtField.text = item.stringValue
            cell.txtField.placeholder = item.title
            cell.txtField.type = item.textfieldType
            cell.txtField.keyboardType = item.keyboardType
            cell.txtField.isEnabled = isEditMode ? item.txtFieldEnable : false
            cell.txtField.tag = indexPath.row
            cell.button?.tag = indexPath.row
            return cell
        } else if selectedMenu.type == .changePass {
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "passwordSaveBtnCell") as! TVSignUpFormCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell") as! TVSignUpFormCell
                let item = menuItems[indexPath.row]
                cell.txtField.placeholder = item.title
                cell.txtField.text = item.stringValue
                cell.txtField.type = item.textfieldType
                cell.txtField.tag = indexPath.row
                return cell
            }

        } else if selectedMenu.type == .details {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! TVSignUpFormCell
            let item = menuItems[indexPath.row]
            cell.lblTitle.text = item.title
            cell.lblSubTitle.text = item.stringValue
            return cell
        } else  { //Settings
            var cellIdentifier = "switchCell"
            if [0, 5, 7].contains(indexPath.row) {
                cellIdentifier = "switchAndTitleCell"
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TblSwitchBtnCell
            let item = menuItems[indexPath.row]
            cell.lblHeader?.text = item.strHeader
            cell.lblTitle.text = item.title
            if item.settingType == .communicationLanguage || item.settingType ==  .speackingLanguage {
                cell.lblSubTitle.text = item.stringValue
                cell.lblSubTitle.isHidden = false
                cell.switchBtn.isHidden = true
            } else {
                cell.lblSubTitle.isHidden = true
                cell.switchBtn.isHidden = false
                cell.switchBtn.setOn(item.boolValue, animated: false)
                cell.switchBtn.type = item.settingType
                cell.switchBtn.tag = indexPath.row
            }
            cell.switchBtn.isEnabled = isEditMode
            cell.imgView.image = UIImage(named:item.iconName)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedMenu.type == .settings {
            if [0, 5, 7].contains(indexPath.row) {
                return 80 * _widthRatio
            } else {
                return 55 * _widthRatio
            }
        }
        return 55 * _widthRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedMenu.type == .profile  {
            if isEditMode {
                self.view.endEditing(true)
                let item  = menuItems[indexPath.row]
                if item.textfieldType == .birthDate {
                    selectedIndexPath = indexPath
                    self.showDatePickerView()
                    
                } else if item.textfieldType == .gender {
                    self.showGenderPicker(indexPath)
                    
                } else if item.textfieldType == .nationality {
                    self.openCountryList(.nationality, indexPath: indexPath)
                    
                } else if item.textfieldType == .country {
                    self.openCountryList(.country, indexPath: indexPath)
                    
                } else if item.textfieldType == .accountType {
                    self.openAccountTypeListVC(indexPath)
                }
            }
        } else if selectedMenu.type == .settings {
            if isEditMode {
                let item = menuItems[indexPath.row]
                if item.settingType == .communicationLanguage || item.settingType == .speackingLanguage {
                    self.openLanguagesListVC(indexPath, type: item.settingType)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: CollectionView datasource and delegate
extension ProfileViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CVGenericeCell
       
        let menu = Menus[indexPath.row]
        cell.lblTitle.text = menu.title
        cell.imgView.image = UIImage(named: menu.imgName)
        cell.lblTitle.textColor = menu.selected ? UIColor.scHeaderColor() : UIColor.lightGray
        cell.imgView.tintColor = menu.selected ? UIColor.scHeaderColor() : UIColor.lightGray

        let lblLine = cell.viewWithTag(101)
        lblLine?.isHidden = indexPath.row == (Menus.count - 1) ? true : false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75 * _widthRatio, height: 80 * _widthRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         selectedMenu.selected = false
        isEditMode = false
        editBtn.setImage(UIImage(named: "ic_edit"), for: UIControlState())
        editBtn.setTitle("", for: UIControlState())
        icnAddPhoto.isHidden = true
       
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
    func showGenderPicker(_ indexPath: IndexPath) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "cancel".localizedString(), style: .cancel, handler: nil)
        
        let maleAction = UIAlertAction(title: "male".localizedString(), style: .default) { (action) in
           let cell = self.tableView.cellForRow(at: indexPath) as? TVSignUpFormCell
            let gender = "male".localizedString()
            self.user.gender = gender
            cell?.txtField.text = gender
        }
        let femaleAction    = UIAlertAction(title: "female".localizedString(), style: .default) { (action) in
            let cell = self.tableView.cellForRow(at: indexPath) as? TVSignUpFormCell
           let gender = "female".localizedString()
            self.user.gender = gender
            cell?.txtField.text = gender

        }
        sheet.addAction(maleAction)
        sheet.addAction(femaleAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    //This func navigate the user to country list screen. 
    //Where user can select country for user field Nationlity, country, and for DialCode.
    func openCountryList(_ forAction : LocationSelectionForType, indexPath: IndexPath)  {
        let cListVC = VListViewController.loadFromNib()
        cListVC.keyForTitle = "CountryName"
        cListVC.keyForId = "CountryID"
        cListVC.apiName = APIName.GetActiveCountries
       
        if forAction == .nationality {
            cListVC.preSelectedIDs = [user.nationality.Id]
            cListVC.screenTitle = "nationality".localizedString()
        } else if forAction == .dialCodeAction {
            cListVC.keyForId = "CountryDialCode"

            cListVC.preSelectedIDs = [user.mobileCountryCode]
            cListVC.screenTitle = "country_dial_code".localizedString()
            
        } else  {
            cListVC.preSelectedIDs = [user.country.Id]
            cListVC.screenTitle = "countries".localizedString()
        }
        
        cListVC.completionBlock = {(items) in
                if let item = items.first {
                    let country = Country(info: item.obj as! [String : Any])
                    if forAction == .nationality {
                        self.user.nationality = country
                        let cell = self.tableView.cellForRow(at: indexPath) as? TVSignUpFormCell
                        cell?.txtField.text = country.name
                        
                    } else if forAction == .dialCodeAction {
                        self.user.mobileCountryCode = country.dialCode
                        let cell = self.tableView.cellForRow(at: indexPath) as? TVSignUpFormCell
                        cell?.txtField.text = country.name
                        
                    } else  if forAction == .country {
                        self.user.country = country
                        let cell = self.tableView.cellForRow(at: indexPath) as? TVSignUpFormCell
                        cell?.txtField.text = country.name
                    }
                    self.changeMenuItems(self.selectedMenu)
                }
        }
        self.present(cListVC, animated: true, completion: nil)
    }
    
    
    //Navigate to pick User account type.
    func openAccountTypeListVC(_ indexPath: IndexPath)  {
        let cListVC = VListViewController.loadFromNib()
        cListVC.preSelectedIDs = [user.accountType.Id]
        cListVC.apiName = APIName.GetAccountTypes
        cListVC.keyForId = "ID"
        cListVC.keyForTitle = "Name"
        
        cListVC.completionBlock = {(items) in
            if let acType = items.first!.obj as? [String : Any] {
                let account = AccountType(info: acType)
                self.user.accountType = account
                let cell = self.tableView.cellForRow(at: indexPath) as? TVSignUpFormCell
                cell?.txtField.text = account.name
                self.changeMenuItems(self.selectedMenu)
            }
        }
        self.present(cListVC, animated: true, completion: nil)
    }
    
    //Navigate to pick user preference language.
    func openLanguagesListVC(_ indexPath: IndexPath, type: UserPreferenceType)  {
        let cListVC = VListViewController.loadFromNib()
        cListVC.screenTitle = "Language".localizedString()
        cListVC.apiName = APIName.GetLanguages
        cListVC.keyForId = "ID"
        cListVC.keyForTitle = "Name"
        
        if type == .communicationLanguage {
            cListVC.preSelectedIDs = [user.preference.defaultLanguage?.id ?? ""]
        } else {
            cListVC.enableMultipleChoice = true
            let langIds = self.user.preference.speakingLanguages.map({ (lang) -> String in
                return lang.id
            })

           cListVC.preSelectedIDs = langIds
        }
        
        cListVC.completionBlock = {(items) in
            let cell = self.tableView.cellForRow(at: indexPath) as? TblSwitchBtnCell
            if type == .communicationLanguage {
                let jsonLang = items.first!.obj as! [String : Any]
                self.user.preference.defaultLanguage = Language(jsonLang)
                cell?.lblSubTitle.text = items.first!.name

            } else if type == .speackingLanguage {
                
                let lngArr = items.map({ (item) -> Language in
                    let jsonLang = item.obj as! [String : Any]
                    let lang = Language(jsonLang)
                    return lang
                })
                self.user.preference.speakingLanguages = lngArr
                let langs = lngArr.map({ (lang) -> String in
                    return lang.code
                })

                cell?.lblSubTitle.text = langs.joined(separator: ", ")


            }
            self.changeMenuItems(self.selectedMenu)
        }
        self.present(cListVC, animated: true, completion: nil)
    }

}

//MARK: Notifications
extension ProfileViewController {
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


//MARK: Other
extension ProfileViewController {
    
    func setUserInfo() {
        lblFullName.text = user.fullname
        lblGender.text = user.gender
        let birthdDate = dateFormator.dateString(user.birthDate, fromFomat: "yyyy-MM-dd", style: DateFormatter.Style.medium)

        lblBirthDate.text = birthdDate
        imgVUserProfile.setImageWith(URL(string: user.photo)!, placeholderImage: user.placeholderImage)
        //imgVCover.setImageWithURL(NSURL(string: user.photo)!,placeholderImage: user.placeholderImage)
    }
    
    //func for set action of shutter button as per profile form's mode
    func changeShutterBtnSelector() {
        if isEditMode {
            btnShutter.removeTarget(self, action: #selector(self.shutterAction(_:)), for: .touchUpInside)
            btnShutter.addTarget(self, action: #selector(self.backBtnClicked(_:)), for: .touchUpInside)
            btnShutter.setImage(UIImage(named: "ic_back_arrow"), for: UIControlState())
        } else {
            self.view.endEditing(true)
            btnShutter.removeTarget(self, action: #selector(self.backBtnClicked(_:)), for: .touchUpInside)
            btnShutter.addTarget(self, action: #selector(self.shutterAction(_:)), for: .touchUpInside)
            btnShutter.setImage(UIImage(named: "ic_menu"), for: UIControlState())
            icnAddPhoto.isHidden = true
            editBtn.setImage(UIImage(named: "ic_edit"), for: UIControlState())
            editBtn.setTitle("", for: UIControlState())
        }
    }
    
    //MARK: Set Menu Items and UI as per seleted menu
    func changeMenuItems(_ menu: Menu)  {
        if menu.type == .profile {
            menuItems = [CellItem(title: "first_name".localizedString(), value: user.firstname, txtFieldType: .firstName),
                         CellItem(title: "last_name".localizedString(), value: user.lastname, txtFieldType: .lastName),
                         CellItem(title: "gender".localizedString(), value: user.gender, txtFieldType: .gender, enable: false)]
            
            let birthdDate = dateFormator.dateString(user.birthDate, fromFomat: "yyyy-MM-dd", style: DateFormatter.Style.medium)
            menuItems += [CellItem(title: "birth_date".localizedString(), value: birthdDate, txtFieldType: .birthDate, enable: false)]
           
            menuItems +=   [CellItem(title: "+" + user.mobileCountryCode,  value: user.mobile, txtFieldType: .mobileNo, keyboardType: .numberPad, cellName: "mobileCell"),
                            CellItem(title: "nationality".localizedString(), value: user.nationality.name,  txtFieldType: .nationality, enable: false),
                            CellItem(title: "country".localizedString(), value: user.country.name,      txtFieldType: .country, enable: false),
                            CellItem(title: "account_type".localizedString(), value: user.accountType.name,  txtFieldType: .accountType, enable: false)]
            
        } else if menu.type == .changePass {
            menuItems = [CellItem(title: "old_password".localizedString(),    value: user.oldPassword,    txtFieldType: .oldPassword),
                         CellItem(title: "password".localizedString(),        value: user.password,       txtFieldType: .password),
                         CellItem(title: "confirm_password".localizedString(),value: user.confPass,       txtFieldType: .confirmPass),
                         CellItem(title: "Update",          value: "Update",            txtFieldType: .none)]
            
        } else if menu.type == .socialLink {
            menuItems = [CellItem(title: "WhatsApp".localizedString(),    value: user.social.Whatsapp,    txtFieldType: .whatsApp),
                         CellItem(title: "Line".localizedString(),        value: user.social.Line,        txtFieldType: .line),
                         CellItem(title: "Tango".localizedString(),       value: user.social.Tango,       txtFieldType: .tango),
                         CellItem(title: "Telegram".localizedString(),    value: user.social.Telegram,    txtFieldType: .telegram),
                         CellItem(title: "Facebook".localizedString(),    value: user.social.Facebook,    txtFieldType: .facebook),
                         CellItem(title: "Twitter".localizedString(),     value: user.social.Twitter,     txtFieldType: .twitter)]
            
        } else if menu.type == .details {
            menuItems = [CellItem(title: "Member_Since".localizedString() + ":",       value: user.createDate,                 txtFieldType: .none),
                         CellItem(title: "Last_Login".localizedString() + ":",         value: user.lastLoginTime,              txtFieldType: .none),
                         CellItem(title: "Last_Activity_Date".localizedString() + ":", value: user.lastLoginTime,              txtFieldType: .none),
                         CellItem(title: "Number_of_Travels".localizedString() + ":",  value: user.numberOfTravels.ToString(), txtFieldType: .none),
                         CellItem(title: "Contacts".localizedString() + ":",           value: user.numberOfContacts.ToString(),txtFieldType: .none),
                         CellItem(title: "Email".localizedString() + ":",              value: user.EmailVerifiedString,        txtFieldType: .none),
                         CellItem(title: "Phone_Number".localizedString() + ":",       value: user.MobileVerifiedString,       txtFieldType: .none),
                         CellItem(title: "Facebook".localizedString() + ":",           value: user.FacebookVeriedString,       txtFieldType: .none)]
            
        } else  { //Settings
            
            menuItems = [CellItem(title: "Show_email_to_others".localizedString(),    value: user.preference.showEmail,       settingType: .showEmail,        icon: "ic_show_email", header: "General".localizedString()),
                         CellItem(title: "Show_mobile_to_others".localizedString(),   value: user.preference.showMobile,      settingType: .showMobile,       icon: "ic_show_mobile"),
                         CellItem(title: "Visible_in_search".localizedString(),       value: user.preference.visibleInSearch, settingType: .visibleInSearch,  icon: "ic_visible_search"),
                         CellItem(title: "Accept_special_order".localizedString(),    value: user.preference.specialOrder,    settingType: .specialOrder,     icon: "ic_accept_special"),
                         CellItem(title: "Accept_Monitoring".localizedString(),       value: user.preference.acceptMonitring, settingType: .acceptMonitring,  icon: "ic_monitoring"),
                         
                         CellItem(title: "Communication_Language".localizedString(),  value: user.preference.defaultLanguage?.name ?? "",           settingType: .communicationLanguage,    icon: "ic_communication_lang", header: "Language".localizedString())]
            
            let langs = user.preference.speakingLanguages.map({ (lang) -> String in
                return lang.code
            })
            menuItems +=       [ CellItem(title: "Speaking_Language".localizedString(),       value: langs.joined(separator: ", "),   settingType: .speackingLanguage,        icon: "ic_speaking_lang")]
            
            
            menuItems +=       [CellItem(title: "Children".localizedString(),        value: user.preference.kids,        settingType: .children,     icon: "ic_childreb", header: "My_Rules".localizedString()),
                                CellItem(title: "Pets".localizedString(),            value: user.preference.pets,        settingType: .pets,         icon: "ic_pets"),
                                CellItem(title: "Stop_for_pray".localizedString(),   value: user.preference.prayingStop, settingType: .stopForPray,  icon: "ic_pray"),
                                CellItem(title: "Food_and_Drinks".localizedString(), value: user.preference.food,        settingType: .foodAndDrink, icon: "ic_food_drink"),
                                CellItem(title: "Music".localizedString(),           value: user.preference.music,       settingType: .music,        icon: "ic_music"),
                                CellItem(title: "Quran".localizedString(),           value: user.preference.quran,       settingType: .quran,        icon: "ic_quran"),
                                CellItem(title: "Smoking".localizedString(),         value: user.preference.smoking,     settingType: .smoking,      icon: "ic_smoking")]
            
        }
        
        tableView.reloadData()
    }

}

//MARK: Webservice call 
extension ProfileViewController {
    
    
    //Get user's profile info
    func getMyInfoAPICall() {
        self.showCentralGraySpinner()
        user.getInfo { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    me.resetUserInfo(json)
                    self.user = me.copy() as! LoggedInUser
                    archiveObject(json, key: kLoggedInUserKey)
                    self.setUserInfo()
                    self.changeMenuItems(self.selectedMenu)
                }
                
            } else {
                showToastErrorMessage("Login Error", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }

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
                if let json = response.json as? [String : Any] {
                    var info = json["Object"] as! [String : Any]
                    me.resetUserInfo(info)
                    self.user = me.copy() as! LoggedInUser
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
                            _defaultCenter.post(name: Notification.Name(rawValue: kProfileUpdateNotificationKey), object: nil)
                            self.hideCentralGraySpinner()
                        })
                        
                    } else {
                        archiveObject(info, key: kLoggedInUserKey)
                        self.setUserInfo()
                        showToastMessage("", message: "kProfileUpdateSuccess".localizedString())
                        _defaultCenter.post(name: Notification.Name(rawValue: kProfileUpdateNotificationKey), object: nil)
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
                if let json = response.json as? [String : Any] {
                    let info = json["Object"] as! [String : Any]
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
                if let json = response.json as? [String : Any]  {
//                    let info = json["Object"] as! [String : AnyObject]
//                    let preference = UserPreference(info: info)
//                    me.preference = preference
                    self.changeMenuItems(self.selectedMenu)
//                    archiveObject(info, key: kLoggedInUserKey)
                    showToastMessage("", message: response.message)
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
        let nibViews = Bundle.main.loadNibNamed("VDatePickerView", owner: nil, options: nil)!
        self.datePickerView = nibViews[0] as! VDatePickerView
        self.datePickerSelectionBlockSetup()
        self.view.addSubview(datePickerView)
    }

    func showDatePickerView() {
        let dateBefor16Years = Date().dateByAddingYearOffset(-16) //Validation for user should be 16 years old.
        datePickerView.maxDate = dateBefor16Years
        datePickerView.show()
    }
    
    //func for setup datePicker date selection callback block
    func datePickerSelectionBlockSetup() {
        datePickerView.dateSelectionBlock = {[weak self](date, forType) in
            if let selff = self {
                selff.user.birthDate = selff.dateFomator.stringFromDate(date, format: "yyyy-MM-dd")
                let cell = selff.tableView.cellForRow(at: selff.selectedIndexPath!) as? TVSignUpFormCell
                cell?.txtField.text =  selff.dateFomator.stringFromDate(date, style: .medium)
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
    
    init(title: String, value: String, txtFieldType: TextFieldType, keyboardType: UIKeyboardType = .default, icon: String = "" , enable: Bool = true, cellName: String = "nameCell") {
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
