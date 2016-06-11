//
//  ProfileViewController.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 08/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class ProfileViewController: ParentVC {

    @IBOutlet var headerView: UIView!
    @IBOutlet var imgVUserProfile: UIImageView!
    @IBOutlet var imgVCover: UIImageView!
    var user : User!
    
    let Menus = [Menu(title: "Profile",         imgName: "ic_profile_selected", selected: true, type: .Profile),
                 Menu(title: "Change Password", imgName: "ic_change_password", type: .ChangePass),
                 Menu(title: "Social Link",     imgName: "ic_social_link", type: .SocialLink),
                 Menu(title: "Details",         imgName: "ic_detail", type: .Details),
                 Menu(title: "Settings",        imgName: "ic_settings", type: .Settings)]
    var selectedMenu: Menu!
    var menuItems = [CellItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        user = User()
        selectedMenu = Menus[0]
        changeMenuItems(selectedMenu)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: IBActions
extension ProfileViewController {
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
            user.preference.children = isOn
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
        menuItems[sw.tag].boolValue = sw.on
    }
    
    @IBAction func cellTextfieldDidChangeText(txtfield: SignupTextField) {
        let value = txtfield.text
        if txtfield.type == .FirstName {
            user.firstname = value
        } else if txtfield.type == .LastName {
            user.lastname = value
        } else if txtfield.type == .MobileNo {
            user.mobile = value
        } else if txtfield.type == . OldPassword {
            
        } else if txtfield.type == .Password {
            user.password = value
        } else if txtfield.type == .ConfirmPass {
            user.confPass = value
        }
        print("\(txtfield.type) : \(value)")
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
            cell.txtField.enabled = item.txtFieldEnable
            return cell
        } else if selectedMenu.type == .ChangePass {
            if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier("passwordSaveBtnCell") as! TVSignUpFormCell
                return cell
            }else  {
                let cell = tableView.dequeueReusableCellWithIdentifier("passwordCell") as! TVSignUpFormCell
                let item = menuItems[indexPath.row]
                cell.txtField.placeholder = item.title
                cell.txtField.type = item.textfieldType
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
            cell.lblTitle.text = item.title
            cell.switchBtn.setOn(item.boolValue, animated: false)
            cell.switchBtn.type = item.settingType
            cell.switchBtn.tag = indexPath.row
            
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
    
    //MARK: Set Menu Items and UI as per seleted menu
    func changeMenuItems(menu: Menu)  {
        
        
        if menu.type == .Profile {
            menuItems = [CellItem(title: "First Name", value: user.firstname, txtFieldType: .FirstName),
                         CellItem(title: "Last Name", value: user.firstname, txtFieldType: .LastName),
                         CellItem(title: "Gender", value: user.firstname, txtFieldType: .Gender, enable: false),
                         CellItem(title: "Brith Date", value: user.firstname, txtFieldType: .BirthDate, enable: false),
                         CellItem(title: "Mobile", value: user.firstname, txtFieldType: .MobileNo),
                         CellItem(title: "Nationality", value: user.firstname, txtFieldType: .Nationality, enable: false),
                         CellItem(title: "Country", value: user.firstname, txtFieldType: .Country, enable: false),
                         CellItem(title: "Account Type", value: user.firstname, txtFieldType: .AccountType, enable: false)]
            
        } else if menu.type == .ChangePass {
            menuItems = [CellItem(title: "Old Password", value: "", txtFieldType: .OldPassword),
                         CellItem(title: "Password", value: "", txtFieldType: .Password),
                         CellItem(title: "Confirm Password", value: "", txtFieldType: .ConfirmPass),
                         CellItem(title: "Update", value: "Update", txtFieldType: .None)]
            
        } else if menu.type == .SocialLink {
            menuItems = [CellItem(title: "WhatsApp", value: user.social.Whatsapp, txtFieldType: .WhatsApp),
                         CellItem(title: "Line", value: user.social.Whatsapp, txtFieldType: .Line),
                         CellItem(title: "Tango", value: user.social.Whatsapp, txtFieldType: .Tango),
                         CellItem(title: "Telegram", value: user.social.Whatsapp, txtFieldType: .Telegram),
                         CellItem(title: "Facebook", value: user.social.Whatsapp, txtFieldType: .Facebook),
                         CellItem(title: "Twitter", value: user.social.Whatsapp, txtFieldType: .Twitter)]
            
        } else if menu.type == .Details {
            menuItems = [CellItem(title: "Member Since:", value: "25/04/2016", txtFieldType: .None),
                         CellItem(title: "Last Login:", value: "25/04/2016", txtFieldType: .None),
                         CellItem(title: "Last Activity Date:", value: "25/04/2016", txtFieldType: .None),
                         CellItem(title: "Number of Travels:", value: "15", txtFieldType: .None),
                         CellItem(title: "Contacts:", value: "12", txtFieldType: .None),
                         CellItem(title: "Email:", value: "Verified", txtFieldType: .None),
                         CellItem(title: "Phone Number:", value: "Not Verified", txtFieldType: .None),
                         CellItem(title: "Facebook:", value: "Verified", txtFieldType: .None)]
            
        } else  { //Settings
            
            menuItems = [CellItem(title: "Show email to others", value: user.preference.showEmail, settingType: .ShowEmail, icon: "ic_show_email"),
                         CellItem(title: "Show mobile to others", value: user.preference.showMobile, settingType: .ShowMobile, icon: "ic_show_mobile"),
                         CellItem(title: "Visible in search", value: user.preference.visibleInSearch, settingType: .VisibleInSearch, icon: "ic_visible_search"),
                         CellItem(title: "Accept special order", value: user.preference.specialOrder, settingType: .SpecialOrder, icon: "ic_accept_special"),
                         CellItem(title: "Accept Monitoring", value: user.preference.acceptMonitring, settingType: .AcceptMonitring, icon: "ic_monitoring"),
                         
                         CellItem(title: "Communication Language", value: true, settingType: .CommunicationLanguage, icon: "ic_communication_lang"),
                         CellItem(title: "Speaking Language", value: true, settingType: .SpeackingLanguage, icon: "ic_speaking_lang"),
                         
                         CellItem(title: "Children", value: user.preference.pets, settingType: .ShowEmail, icon: "ic_childreb"),
                         CellItem(title: "Pets", value: user.preference.pets, settingType: .ShowEmail, icon: "ic_pets"),
                         CellItem(title: "Stop for pray", value: user.preference.prayingStop, settingType: .ShowEmail, icon: "ic_pray"),
                         CellItem(title: "Food and Drinks", value: user.preference.food, settingType: .ShowEmail, icon: "ic_food_drink"),
                         CellItem(title: "Music", value: user.preference.music, settingType: .ShowEmail, icon: "ic_music"),
                         CellItem(title: "Quran", value: user.preference.quran, settingType: .ShowEmail, icon: "ic_quran"),
                         CellItem(title: "Smoking", value: user.preference.smoking, settingType: .ShowEmail, icon: "ic_smoking")]
            
        }
        
        tableView.reloadData()
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
        let menu = Menus[indexPath.row]
        menu.selected = true
        selectedMenu = menu
        collectionView.reloadData()
        self.changeMenuItems(menu)
    }
    
}

enum UserPreferenceType: Int {
    case ShowEmail, ShowMobile, VisibleInSearch, SpecialOrder, AcceptMonitring
    case CommunicationLanguage, SpeackingLanguage
    case Children, Pets, StopForPray, FoodAndDrink, Music, Quran, Smoking
}

class SignupTextField: JPWidthTextField {
    var type: TextFieldType!
}

class SettingSwitch: VkUISwitch {
    var type: UserPreferenceType!
}

class CellItem {
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
    
    init(title: String, value: Bool, settingType: UserPreferenceType , icon: String ) {
        self.title = title
        self.boolValue = value
        self.settingType = settingType
        self.iconName  = icon
    }

}
