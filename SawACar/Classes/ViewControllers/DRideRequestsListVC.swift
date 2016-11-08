//
//  DRideRequestsListVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class DRideRequestsListVC: ParentVC {

    var rideRequests = [RideRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


//MARK: TableView DataSource and Delegate
extension DRideRequestsListVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6//rideRequests.count + 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as! TVGenericeCell
            cell.lblTitle.text = "Arabia"
            cell.imgView.image = UIImage(named: "ic_location")
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as! TVGenericeCell
            cell.lblTitle.text = "Lift Between cities"
            cell.imgView.image = UIImage(named: "ic_lift_btwn_cities")
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("switchBtnCell") as! TblSwitchBtnCell
            cell.lblTitle.text = "Keep searching for me"
            cell.imgView.image = UIImage(named: "ic_notification_green")
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("rideRequestCell") as! TblRideRequestCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if [0, 1].contains(indexPath.row) {
            return 66 * _widthRatio
            
        } else if indexPath.row == 2 {
            return 70 * _widthRatio
            
        }  else {
            return 200 * _widthRatio
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ride = rideRequests[indexPath.row]
        self.performSegueWithIdentifier("toRideDetailsSegue", sender: ride)
    }
}
