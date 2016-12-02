//
//  MyRidesVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 31/08/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import Firebase

class MyRidesVC: ParentVC {

    @IBOutlet var backBtn: UIButton!
    
    var myRides = [Travel]()
    var refreshControl : UIRefreshControl!
    var forArchivedRides  = false //flag for Checking- screen is showing archived rides or upcoming rides.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        getRidesAPICalls()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toRideDetailsSegue" {
            let rideDetailVC = segue.destinationViewController as! TravelDetailVC
            rideDetailVC.travel = sender as! Travel
        }
    }
    
    //func for navigation to archive rides screen
    func navigationToArchivedRides() {
        let arVC = _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_MyRidesVC") as! MyRidesVC
        arVC.forArchivedRides = true
        self.navigationController?.pushViewController(arVC, animated: true)
    }
    
    //func for prepare UI
    func prepareUI() {
       // set back button's actions
        let iconName = forArchivedRides ? "ic_back_arrow" : "ic_menu"
        backBtn.setImage(UIImage(named: iconName), forState: .Normal)
        if  forArchivedRides {
            backBtn.addTarget(self, action: #selector(self.parentBackAction(_:)), forControlEvents: .TouchUpInside)
        } else {
            backBtn.addTarget(self, action: #selector(self.shutterAction(_:)), forControlEvents: .TouchUpInside)
        }
        
        refreshControl = self.tableView.addRefreshControl(self, selector: #selector(self.getMyRidesAPICall))
        
        initEmptyDataView()
        showEmptyDataView("kMyRidesNotAvailable".localizedString())
    }
}

//MARK: IBActions
extension MyRidesVC {
    
    @IBAction func archivedRidesButtonClicked(sender: UIButton?) {
        self.navigationToArchivedRides()
    }
}

//MARK: TableView DataSource and Delegate
extension MyRidesVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forArchivedRides ? myRides.count :  myRides.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) && !forArchivedRides {//archivedRideCell
            let cell = tableView.dequeueReusableCellWithIdentifier("archivedRideCell") as! TVGenericeCell
            return cell
        }
        let index = forArchivedRides ? indexPath.row : indexPath.row - 1
        let cell = tableView.dequeueReusableCellWithIdentifier("travelCell") as! TVTravelCell
        let ride = myRides[index]
        cell.setRideInfo(ride)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) && !forArchivedRides {//archivedRideCell
            return 40 * _widthRatio
        }
        return 200 * _widthRatio
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) && !forArchivedRides {//archivedRideCell
            return
        }
        let index = forArchivedRides ? indexPath.row : indexPath.row - 1
        let ride = myRides[index]
        self.performSegueWithIdentifier("toRideDetailsSegue", sender: ride)
    }
}

//MARK: API Calls
extension MyRidesVC {
    //get rides api calls
    func getRidesAPICalls() {
        forArchivedRides ? getArchivedRidesAPICall() : getMyRidesAPICall()
    }

    //Get My Rides API Call
    func getMyRidesAPICall() {
        if !refreshControl.refreshing {
            showCentralGraySpinner()
        }
        let userid = me.Id
        
        wsCall.getTravels(userid) { (response, flag) in
            if response.isSuccess {
                
                if let arrRides = response.json!["Object"] as? [[String : AnyObject]] {
                    if self.refreshControl.refreshing {
                        self.myRides.removeAll()
                    }
                    for json in arrRides {
                        let ride = Travel(json)
                        self.myRides.append(ride)
                    }
                }
                
                self.myRides.isEmpty ? self.showEmptyDataView("ArchivedRidesNotAvailable".localizedString(), frame: CGRect(x: 0, y: 120, width: _screenSize.width, height: 40)) : self.emptyDataView.hide()
                self.tableView.reloadData()
            } else {
                showToastErrorMessage("", message: response.message!)
            }
            self.refreshControl.endRefreshing()
            self.hideCentralGraySpinner()
        }
    }
    
    //Get My Rides API Call
    func getArchivedRidesAPICall() {
        if !refreshControl.refreshing {
            showCentralGraySpinner()
        }
        let userid = me.Id
        
        wsCall.getArchivedTravels(userid) { (response, flag) in
            if response.isSuccess {
                
                if let arrRides = response.json!["Object"] as? [[String : AnyObject]] {
                    if self.refreshControl.refreshing {
                        self.myRides.removeAll()
                    }
                    for json in arrRides {
                        let ride = Travel(json)
                        self.myRides.append(ride)
                    }
                }
                
                self.myRides.isEmpty ? self.showEmptyDataView("ArchivedRidesNotAvailable".localizedString(), frame: CGRect(x: 0, y: 120, width: _screenSize.width, height: 40)) : self.emptyDataView.hide()
                self.tableView.reloadData()
            } else {
                showToastErrorMessage("", message: response.message!)
            }
            self.refreshControl.endRefreshing()
            self.hideCentralGraySpinner()
        }
    }
    

}
