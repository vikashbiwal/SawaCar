//
//  DriverDetailViewController.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 08/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit


class DriverDetailViewController: ParentVC {
    
    @IBOutlet var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var profileImageViewWidth: NSLayoutConstraint!
   
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblCountryName: UILabel!
    @IBOutlet var driverImageView: UIImageView!
    @IBOutlet var ratingView: HCSStarRatingView!
    
    var driver: User!
    let kVarificationSection = 0
    let kTravelWithMeSection = 1
    let kCarDetailSection = 2
   
    var sectionTitles = ["Verification".localizedString(), "Why Travel With Me?".localizedString()]
    var varificationItems = []
    var travelWithMeItems = [[String : String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: topViewHeightConstraint.constant, left: 0, bottom: 0, right: 0)
        
        self.setDriverInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set Driver info
    func setDriverInfo() {
        
        lblTitle.text = driver.fullname
        lblDriverName.text = driver.fullname
        lblCountryName.text = driver.country.name
        ratingView.value = CGFloat(driver.rating)
        driverImageView.setImageWithURL(NSURL(string: driver.photo)!, placeholderImage: _userPlaceholderImage)
        
        setVarificationItems()
        setWhyTravelWithMeItems()
    }
    
    //set  varification section items
    func setVarificationItems() {
        let emailVerification = ["text": "Email \(driver.isEmailVerified ? "" : "Not") Verified",
                                 "isVerified" : driver.isEmailVerified,
                                 "iconName" : "ic_message"]
        
        let mobileVerification = ["text" : "Mobile \(driver.isMobileVerified ? "" : "Not") Verified",
                                  "isVerified" : driver.isMobileVerified,
                                  "iconName" : "ic_call_white"]
        
        let termsVerification = ["text" : "Terms & Conditions \(driver.isTermsAccepted ? "" : "Not") Verified",
                                 "isVerified" : driver.isTermsAccepted,
                                 "iconName" : "ic_lock_white"]
        
        varificationItems = [emailVerification, mobileVerification, termsVerification]
    }
    
    //Set Why travel with me items
    func setWhyTravelWithMeItems() {
        let activityItem = ["title": ""] //first item is reserved for activities row.
        travelWithMeItems.append(activityItem)
        if !driver.language.isEmpty {
            let languageItem = ["title" : "Speaking Language".localizedString(), "Text" : driver.language]
            travelWithMeItems.append(languageItem as! [String : String])
        }
        if !driver.accountType.name.isEmpty {
            let accountTypeItem = ["title" : "Account Type".localizedString(), "Text" : driver.accountType.name]
            travelWithMeItems.append(accountTypeItem)
        }
        
    }
}


//MARK: IBActions
extension DriverDetailViewController {
   
    @IBAction func callButtonTapped(sender: UIButton) {
        if let url = NSURL(string: "tel://\(driver.mobile)") {
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    @IBAction func messageButtonTapped(sender: UIButton) {
        //TODO
    }
}

//MARK: TableViewDataSource
extension DriverDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == kVarificationSection {
            return varificationItems.count
            
        } else if section == kTravelWithMeSection {
            return travelWithMeItems.count
            
        } else if section == kCarDetailSection {
            return 0
            
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == kVarificationSection {
            let cell = tableView.dequeueReusableCellWithIdentifier("varificationCell") as! TVGenericeCell
            let item = varificationItems[indexPath.row]
            cell.lblTitle.text = item["text"] as? String
            cell.imgView.image = UIImage(named: item["iconName"] as! String)
            cell.imgView.layer.zPosition = 10
            return cell
            
        } else if indexPath.section == kTravelWithMeSection {//activityCell
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("activityCell") as! TVGenericeCell
                cell.lblTitle.text = driver.createDate
                cell.lblSubTitle.text = driver.lastLoginTime
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("otherActivityCell") as! TVGenericeCell
                let item = travelWithMeItems[indexPath.row]
                cell.lblTitle.text = item["title"]
                cell.lblSubTitle.text = item["Text"]
                return cell
            }
            
        } else { //indexPath.section == kCarDetailSection
            return UITableViewCell()
        }
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == kVarificationSection {
            return 35 * _widthRatio
            
        } else if indexPath.section == kTravelWithMeSection {
            if indexPath.row == 0 {
                return 95 * _widthRatio
            } else {
                return 71 * _widthRatio
            }
            
        } else { //indexPath.section == kCarDetailSection
            return 0
        }
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 * _widthRatio
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TVGenericeCell
        cell.lblTitle.text = sectionTitles[section]
        return cell.contentView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -(150 * _widthRatio) {
            topViewHeightConstraint.constant =  -scrollView.contentOffset.y
        }

    }
    
}
