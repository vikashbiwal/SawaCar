//
//  RequestARideStep2VC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 24/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class RequestARideStep2VC: ParentVC {

    var tRequest : TravelRequest!
    var sectionRows = [2, 1, 3, 2] //number of rows in tableview sections
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RequestARideStep2VC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionRows[section]
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  [0,1].contains(section) ? 40 : 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 45 * _widthRatio
        } else if indexPath.section == 1 {
            return 80 * _widthRatio
        } else if indexPath.section == 2 {
            return 50 * _widthRatio
        } else {
            return indexPath.row == 0 ? 50 * _widthRatio : 55 * _widthRatio
        }
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if [0,1].contains(section) {
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TVGenericeCell
            cell.lblTitle.text = section == 0 ? "Start and End point".localizedString() : "Details".localizedString()
            return cell.contentView
        } else {
            let fView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
            fView.backgroundColor = UIColor.clearColor()
            return fView
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fView = UIView(frame: CGRect(x: 0, y: 0, width: _screenSize.width, height: 15))
            fView.backgroundColor = UIColor.clearColor()
        return fView
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as! TVGenericeCell
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("rideDateTimeCell") as! TravelDateTimeCell
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("listActionCell") as! TVGenericeCell
            return cell
            
        } else {
            if indexPath.row == 0 { //
                let cell = tableView.dequeueReusableCellWithIdentifier("switchBtnCell") as! TblSwitchBtnCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("buttonCell") as! TVGenericeCell
                return cell
            }
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
