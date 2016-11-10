//
//  CollectionViewCells.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 12/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class CVGenericeCell: ConstrainedCollectionViewCell {
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var imgView : UIImageView!
}


// This Collection view cell is used in Signup screen.
class SignUpCollectionViewCell: CVGenericeCell, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
   
    //Block for handle singUp actions
    var signUpFormActionBlock : (action: SignUpVC.SignUpFormActionType, value: String)-> Void = {_ in}
    var textFieldChangeBlock : (type: TextFieldType, text: String) -> Void = {_ in}
    
    @IBOutlet var tableView: UITableView!
    var formType  = SignUpVC.SignUpFormType.PersonalInfo
    weak var user: User!
    
    lazy var dateFomator: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df
    }()
    
    //MARK: Tableview datasource and delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfCell = 0
       
        switch formType {
        case .PersonalInfo:
            numberOfCell = 7
            break
        case .GenderInfo, .BirthDateInfo, .ContactInfo :
            numberOfCell = 3
            break
        case .LocationInfo:
            numberOfCell = 4
            break
        }
        
        return numberOfCell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if formType == .PersonalInfo {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("imagePickerCell") as! TVSignUpFormCell
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("formDescriptionCell") as! TVSignUpFormCell
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCellWithIdentifier("nameFieldCell") as! TVSignUpFormCell
                cell.txtField.placeholder = "first_name".localizedString()
                cell.txtField.tag = 101
                cell.txtField.returnKeyType = .Next
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier("nameFieldCell") as! TVSignUpFormCell
                cell.txtField.placeholder = "last_name".localizedString()
                cell.txtField.tag = 102
                cell.txtField.returnKeyType = .Next
                return cell
            } else if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCellWithIdentifier("emailFieldCell") as! TVSignUpFormCell
                cell.txtField.tag = 103
                cell.txtField.returnKeyType = .Next
                return cell
            } else if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCellWithIdentifier("passwordFieldCell") as! TVSignUpFormCell
                cell.txtField.placeholder = "password".localizedString()
                cell.txtField.tag = 104
                cell.txtField.returnKeyType = .Next
                return cell
            } else  {
                let cell = tableView.dequeueReusableCellWithIdentifier("passwordFieldCell") as! TVSignUpFormCell
                cell.txtField.placeholder = "confirm_password".localizedString()
                cell.txtField.tag = 105
                cell.txtField.returnKeyType = .Default
                return cell
            }
        } else  { // .GenderInfo, .BirthInfo, .ContactInfo, .LocationInfo
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("appLogoCell") as! TVSignUpFormCell
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier("formDescriptionCell2") as! TVSignUpFormCell
                if formType == .GenderInfo {
                    cell.lblTitle.text = "what_is_your_gender".localizedString()
                } else if formType == .BirthDateInfo {
                    cell.lblTitle.text = "when_is_your_birthday".localizedString()
                } else if formType == .ContactInfo {
                    cell.lblTitle.text = "what_is_your_number".localizedString()
                } else {
                    cell.lblTitle.text = "where_are_you_living".localizedString()
                }
                return cell
            } else {
                
                if formType == .GenderInfo {
                    let cell = tableView.dequeueReusableCellWithIdentifier("genderSelectionCell") as! TVSignUpFormCell
                    return cell
                } else if formType == .BirthDateInfo {
                    let cell = tableView.dequeueReusableCellWithIdentifier("dateSelectionCell") as! TVSignUpFormCell
                    let dateBefor16Years = NSDate().dateByAddingYearOffset(-16)
                    cell.dtPicker.maximumDate = dateBefor16Years //Validation for user should be 16 years old.
                    return cell
                    
                } else if formType == .LocationInfo { // formType == .LocationInfo
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as! TVSignUpFormCell
                    if indexPath.row == 2 {
                        cell.txtField.placeholder = "nationality".localizedString()
                        cell.button?.tag = 100
                        return cell
                    } else  {
                        cell.txtField.placeholder = "country".localizedString()
                        cell.button?.tag = 101
                        return cell
                    }
                    
                }  else  { //formType == .ContactInfo
                    let cell = tableView.dequeueReusableCellWithIdentifier("mobileNoCell") as! TVSignUpFormCell
                    cell.txtField.tag = 106
                    cell.lblTitle.text = "+" + user.mobileCountryCode
                    return cell
                    
                }
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if formType == .PersonalInfo {
            if indexPath.row == 0 {
                return 160 * _widthRatio
            } else if indexPath.row == 1 {
                return 75 * _widthRatio
            } else  {
                return 44 * _widthRatio
            }
        } else if formType == .GenderInfo || formType == .BirthDateInfo {
            if indexPath.row == 0 {
                return 140 * _widthRatio
            } else if indexPath.row == 1 {
                return 75 * _widthRatio
            } else {
                return 160 * _widthRatio
            }
        } else if formType == .ContactInfo || formType == .LocationInfo {
            if indexPath.row == 0 {
                return 140 * _widthRatio
            } else if indexPath.row == 1 {
                return 75 * _widthRatio
            } else  {
                return 44 * _widthRatio
            }
        }  else {
            return 0
        }
    }
    
    
    //MARK: TextField Delegate
    func textFieldShouldReturn(sender: UITextField) -> Bool {
         var index = 0
        if sender.tag == TextFieldType.FirstName.rawValue {
            index = 3
        } else if sender.tag == TextFieldType.LastName.rawValue {
            index = 4
        } else if sender.tag == TextFieldType.Email.rawValue {
            index = 5
        } else if sender.tag == TextFieldType.Password.rawValue {
            index = 6
        } else if sender.tag == TextFieldType.ConfirmPass.rawValue {
            return sender.resignFirstResponder()
        } else if sender.tag == TextFieldType.MobileNo.rawValue {
            sender.resignFirstResponder()
        } else {
            return sender.resignFirstResponder()
        }
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! TVSignUpFormCell
        cell.txtField.becomeFirstResponder()
        return true
    }
    
    //MARK: IBActions
    @IBAction func textfieldTextChange(sender: UITextField) {
        var type  =  TextFieldType.None
        if sender.tag == TextFieldType.FirstName.rawValue {
            type = .FirstName
        } else if sender.tag == TextFieldType.LastName.rawValue {
            type = .LastName
        } else if sender.tag == TextFieldType.Email.rawValue {
            type = .Email
        } else if sender.tag == TextFieldType.Password.rawValue {
            type = .Password
        } else if sender.tag == TextFieldType.ConfirmPass.rawValue {
            type = .ConfirmPass
        } else if sender.tag == TextFieldType.MobileNo.rawValue {
            type = .MobileNo
            let mobileNo = sender.text!
            if mobileNo.characters.count > 14 { //user could not be add more than 14 digits as mobile number.
                let substring = mobileNo.substringToIndex(mobileNo.endIndex.advancedBy(-1))
                sender.text = substring
                return
            }
        }
        let str = sender.text?.trimmedString()
        textFieldChangeBlock(type: type, text: str!)
    }
    
    @IBAction func genderBtnClicked(sender: UIButton) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0))
        let femaleBtn   = cell?.viewWithTag(1)  as! UIButton
        let maleBtn     = cell?.viewWithTag(2)  as! UIButton
        let femaleLbl   = cell?.viewWithTag(11) as! UILabel
        let maleLbl     = cell?.viewWithTag(12) as! UILabel
        
        femaleBtn.tintColor = UIColor.lightGrayColor()
        maleBtn.tintColor   = UIColor.lightGrayColor()
        maleLbl.textColor   = UIColor.lightGrayColor()
        femaleLbl.textColor = UIColor.lightGrayColor()
        
        sender.tintColor = UIColor.scHeaderColor()
        (sender.tag == 1 ? femaleLbl : maleLbl).textColor = UIColor.scHeaderColor()
        signUpFormActionBlock(action: .GenderAction, value: sender.tag == 1 ? "female".localizedString() : "male".localizedString())
    }
    
    @IBAction func locationBtnClicked(sender: UIButton) {
        //value parameter is not important here
        signUpFormActionBlock(action: (sender.tag == 100 ? .NationalityAction : .CountryAction), value: "Location")
    }
    @IBAction func dialCodeBtnClicked(sender: UIButton) {
        //value parameter is not important here
        signUpFormActionBlock(action: .DialCodeAction, value: "DialCode")
    }

    @IBAction func imagePickerBtnClicked(sender: UIButton) {
        //value parameter is not important here
        signUpFormActionBlock(action: .ImagePickerAction, value: "Pick image")
    }
    
    @IBAction func datePickerDidChangeDate(dPicker: UIDatePicker) {
        let strYear = dateFomator.stringFromDate(dPicker.date)
        signUpFormActionBlock(action: .DatePickerAction, value: strYear)
    }
    
    
}

