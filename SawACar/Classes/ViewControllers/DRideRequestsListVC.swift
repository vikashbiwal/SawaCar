//
//  DRideRequestsListVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class DRideRequestsListVC: ParentVC {

    var requestSearchObj: RideRequestSearchObject!
    var rideRequests = [TravelRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        //searchRideRequestAPICall()
        getTravelRequestDetailAPICall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            cell.lblTitle.text = "Lift_Between_cities".localizedString()
            cell.imgView.image = UIImage(named: "ic_lift_btwn_cities")
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("switchBtnCell") as! TblSwitchBtnCell
            cell.lblTitle.text = "Keep_searching_for_me".localizedString()
            cell.imgView.image = UIImage(named: "ic_notification_green")
           
            if let v = cell.viewWithTag(111) {//background view
                v.layer.borderColor = UIColor.scTravelCardColor().CGColor
                v.layer.borderWidth = 2
                v.layer.cornerRadius = 3
                v.clipsToBounds = true
                v.backgroundColor = UIColor.whiteColor()
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("rideRequestCell") as! TblRideRequestCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if [0, 1].contains(indexPath.row) {
            return 45 * _widthRatio
            
        } else if indexPath.row == 2 {
            return 70 * _widthRatio
            
        }  else {
            return 190 * _widthRatio
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let ride = rideRequests[indexPath.row]
        //self.performSegueWithIdentifier("RideRequestDetailSegue", sender: ride)
    }
}

//MARK: Navigation
extension DRideRequestsListVC {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "RideRequestDetailSegue" {
            let detailVc = segue.destinationViewController as! DRideRequestDetailVC
            detailVc.travelRequest = sender as! TravelRequest
        }
    }
}

//MARK: API Calls
extension DRideRequestsListVC {
   
    func searchRideRequestAPICall() {
        
        wsCall.searchTravelRequests(requestSearchObj) { (response, flag) in
            
        }
        
    }
    
    
    func getTravelRequestDetailAPICall() {
        TravelRequest.getTravelRequestDetailAPICall("196") { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    if let trObject = json["Object"] as? [String : AnyObject] {
                        //self.travelRequest.reset(withInfo: trObject)
                        let travelRequest = TravelRequest(trObject)
                        self.performSegueWithIdentifier("RideRequestDetailSegue", sender: travelRequest)
                    }
                }
            } else {
                
            }
        }
    }

}
