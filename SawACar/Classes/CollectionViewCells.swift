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
    var signUpFormActionBlock : (_ action: SignUpVC.SignUpFormActionType, _ value: String)-> Void = {_ in}
    var textFieldChangeBlock : (_ type: TextFieldType, _ text: String) -> Void = {_ in}
    
    @IBOutlet var tableView: UITableView!
    var formType  = SignUpVC.SignUpFormType.personalInfo
    weak var user: User!
    
    lazy var dateFomator: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyy-MM-dd"
        return df
    }()
    
    //MARK: Tableview datasource and delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfCell = 0
       
        switch formType {
        case .personalInfo:
            numberOfCell = 7
            break
        case .genderInfo, .birthDateInfo, .contactInfo :
            numberOfCell = 3
            break
        case .locationInfo:
            numberOfCell = 4
            break
        }
        
        return numberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if formType == .personalInfo {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "imagePickerCell") as! TVSignUpFormCell
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "formDescriptionCell") as! TVSignUpFormCell
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "nameFieldCell") as! TVSignUpFormCell
                cell.txtField.placeholder = "first_name".localizedString()
                cell.txtField.tag = 101
                cell.txtField.returnKeyType = .next
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "nameFieldCell") as! TVSignUpFormCell
                cell.txtField.placeholder = "last_name".localizedString()
                cell.txtField.tag = 102
                cell.txtField.returnKeyType = .next
                return cell
            } else if indexPath.row == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "emailFieldCell") as! TVSignUpFormCell
                cell.txtField.tag = 103
                cell.txtField.returnKeyType = .next
                return cell
            } else if indexPath.row == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "passwordFieldCell") as! TVSignUpFormCell
                cell.txtField.placeholder = "password".localizedString()
                cell.txtField.tag = 104
                cell.txtField.returnKeyType = .next
                return cell
            } else  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "passwordFieldCell") as! TVSignUpFormCell
                cell.txtField.placeholder = "confirm_password".localizedString()
                cell.txtField.tag = 105
                cell.txtField.returnKeyType = .default
                return cell
            }
        } else  { // .GenderInfo, .BirthInfo, .ContactInfo, .LocationInfo
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "appLogoCell") as! TVSignUpFormCell
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "formDescriptionCell2") as! TVSignUpFormCell
                if formType == .genderInfo {
                    cell.lblTitle.text = "what_is_your_gender".localizedString()
                } else if formType == .birthDateInfo {
                    cell.lblTitle.text = "when_is_your_birthday".localizedString()
                } else if formType == .contactInfo {
                    cell.lblTitle.text = "what_is_your_number".localizedString()
                } else {
                    cell.lblTitle.text = "where_are_you_living".localizedString()
                }
                return cell
            } else {
                
                if formType == .genderInfo {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "genderSelectionCell") as! TVSignUpFormCell
                    return cell
                } else if formType == .birthDateInfo {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "dateSelectionCell") as! TVSignUpFormCell
                    let dateBefor16Years = Date().dateByAddingYearOffset(-16)
                    cell.dtPicker.maximumDate = dateBefor16Years //Validation for user should be 16 years old.
                    return cell
                    
                } else if formType == .locationInfo { // formType == .LocationInfo
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! TVSignUpFormCell
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
                    let cell = tableView.dequeueReusableCell(withIdentifier: "mobileNoCell") as! TVSignUpFormCell
                    cell.txtField.tag = 106
                    cell.lblTitle.text = "+" + user.mobileCountryCode
                    return cell
                    
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if formType == .personalInfo {
            if indexPath.row == 0 {
                return 160 * _widthRatio
            } else if indexPath.row == 1 {
                return 75 * _widthRatio
            } else  {
                return 44 * _widthRatio
            }
        } else if formType == .genderInfo || formType == .birthDateInfo {
            if indexPath.row == 0 {
                return 140 * _widthRatio
            } else if indexPath.row == 1 {
                return 75 * _widthRatio
            } else {
                return 160 * _widthRatio
            }
        } else if formType == .contactInfo || formType == .locationInfo {
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
    func textFieldShouldReturn(_ sender: UITextField) -> Bool {
         var index = 0
        if sender.tag == TextFieldType.firstName.rawValue {
            index = 3
        } else if sender.tag == TextFieldType.lastName.rawValue {
            index = 4
        } else if sender.tag == TextFieldType.email.rawValue {
            index = 5
        } else if sender.tag == TextFieldType.password.rawValue {
            index = 6
        } else if sender.tag == TextFieldType.confirmPass.rawValue {
            return sender.resignFirstResponder()
        } else if sender.tag == TextFieldType.mobileNo.rawValue {
            sender.resignFirstResponder()
        } else {
            return sender.resignFirstResponder()
        }
        
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! TVSignUpFormCell
        cell.txtField.becomeFirstResponder()
        return true
    }
    
    //MARK: IBActions
    @IBAction func textfieldTextChange(_ sender: UITextField) {
        var type  =  TextFieldType.none
        if sender.tag == TextFieldType.firstName.rawValue {
            type = .firstName
        } else if sender.tag == TextFieldType.lastName.rawValue {
            type = .lastName
        } else if sender.tag == TextFieldType.email.rawValue {
            type = .email
        } else if sender.tag == TextFieldType.password.rawValue {
            type = .password
        } else if sender.tag == TextFieldType.confirmPass.rawValue {
            type = .confirmPass
        } else if sender.tag == TextFieldType.mobileNo.rawValue {
            type = .mobileNo
            let mobileNo = sender.text!
            if mobileNo.characters.count > 14 { //user could not be add more than 14 digits as mobile number.
                let substring = mobileNo.substring(to: mobileNo.characters.index(mobileNo.endIndex, offsetBy: -1))
                sender.text = substring
                return
            }
        }
        let str = sender.text?.trimmedString()
        textFieldChangeBlock(type, str!)
    }
    
    @IBAction func genderBtnClicked(_ sender: UIButton) {
        let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0))
        let femaleBtn   = cell?.viewWithTag(1)  as! UIButton
        let maleBtn     = cell?.viewWithTag(2)  as! UIButton
        let femaleLbl   = cell?.viewWithTag(11) as! UILabel
        let maleLbl     = cell?.viewWithTag(12) as! UILabel
        
        femaleBtn.tintColor = UIColor.lightGray
        maleBtn.tintColor   = UIColor.lightGray
        maleLbl.textColor   = UIColor.lightGray
        femaleLbl.textColor = UIColor.lightGray
        
        sender.tintColor = UIColor.scHeaderColor()
        (sender.tag == 1 ? femaleLbl : maleLbl).textColor = UIColor.scHeaderColor()
        signUpFormActionBlock(.genderAction, sender.tag == 1 ? "female".localizedString() : "male".localizedString())
    }
    
    @IBAction func locationBtnClicked(_ sender: UIButton) {
        //value parameter is not important here
        signUpFormActionBlock((sender.tag == 100 ? .nationalityAction : .countryAction), "Location")
    }
    @IBAction func dialCodeBtnClicked(_ sender: UIButton) {
        //value parameter is not important here
        signUpFormActionBlock(.dialCodeAction, "DialCode")
    }

    @IBAction func imagePickerBtnClicked(_ sender: UIButton) {
        //value parameter is not important here
        signUpFormActionBlock(.imagePickerAction, "Pick image")
    }
    
    @IBAction func datePickerDidChangeDate(_ dPicker: UIDatePicker) {
        let strYear = dateFomator.string(from: dPicker.date)
        signUpFormActionBlock(.datePickerAction, strYear)
    }
    
    
}

