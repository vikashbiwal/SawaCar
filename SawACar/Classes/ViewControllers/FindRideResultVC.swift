//
//  FindRideResultVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 02/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class FindRideResultVC: ParentVC {

    var travels = [Travel]()
    var searchDataObject: RideSearchObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.findRidesAPICall()
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

//MARK: TableView DataSource
extension FindRideResultVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  section == 0 ? 2 : travels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 { // location cell
                let cell = tableView.dequeueReusableCellWithIdentifier("locationCell")  as! TVGenericeCell
                cell.lblTitle.text = searchDataObject.locationFrom.address
                cell.lblSubTitle.text = searchDataObject.locationTo.address
                return cell
                
            } else { //tracking switch btn cell
                let cell = tableView.dequeueReusableCellWithIdentifier("switchBtnCell")  as! TVGenericeCell
                return cell
            }
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("travelCell")  as! TVTravelCell
            let ride = travels[indexPath.row]
            cell.setRideInfo(ride)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return (indexPath.row == 0 ? 104 : 60 ) * _widthRatio
        } else {
            return 200 * _widthRatio
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.min : 40 * _widthRatio
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {return nil}
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TVGenericeCell
        return cell.contentView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

//MARK: API Calls
extension FindRideResultVC {
    func findRidesAPICall() {
        let fromAddress = searchDataObject.locationFrom.address
        let toAddress = searchDataObject.locationTo.address
        wsCall.findTravels(fromAddress, toAddress: toAddress) { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    if let objects = json["Object"] as? [[String : AnyObject]] {
                        self.travels.removeAll()
                        for item in objects {
                            let travel = Travel(item)
                            self.travels.append(travel)

                        }
                        self.tableView.reloadData()
                    }
                }
            } else {
                //error
            }
        }
    }
}
