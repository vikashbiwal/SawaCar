//
//  MyTravelRequestsVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 30/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class MyTravelRequestsVC: ParentVC {

    @IBOutlet var backBtn: UIButton!
    
    var requests = [TravelRequest]()
    var refreshControl : UIRefreshControl!
    var forArchivedRequest  = false //flag for Checking- screen is showing archived requests or upcoming requests.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        getUserTravelRequest()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //func for prepare UI
    func prepareUI() {
        // set back button's actions
        let iconName = forArchivedRequest ? "ic_back_arrow" : "ic_menu"
        backBtn.setImage(UIImage(named: iconName), forState: .Normal)
        if  forArchivedRequest {
            backBtn.addTarget(self, action: #selector(self.parentBackAction(_:)), forControlEvents: .TouchUpInside)
        } else {
            backBtn.addTarget(self, action: #selector(self.shutterAction(_:)), forControlEvents: .TouchUpInside)
        }
        
        refreshControl = self.tableView.addRefreshControl(self, selector: #selector(self.getUserTravelRequest))
        
        initEmptyDataView()
        showEmptyDataView("kMyRidesNotAvailable".localizedString())
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

    }

    @IBAction func nextBtnClicked(sender: UIButton) {
        let requestDetailVC = _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_RideRequestDetailVC") as! DRideRequestDetailVC
        self.navigationController?.pushViewController(requestDetailVC, animated: true)
    }
    
    //MARK: Navigations
    func navigateToRequestDetail(request: TravelRequest) {
        let requestDetailVC = _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_RideRequestDetailVC") as! DRideRequestDetailVC
        requestDetailVC.travelRequest = request
        self.navigationController?.pushViewController(requestDetailVC, animated: true)
    }
}


//MARK: IBActions
extension MyTravelRequestsVC {
    
    @IBAction func archivedRidesButtonClicked(sender: UIButton?) {
        //self.navigationToArchivedRides()
    }
}

//MARK: TableView DataSource and Delegate
extension MyTravelRequestsVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return forArchivedRequest ? 1 : 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forArchivedRequest {
            return requests.count
        }
        return  section == 0 ? 1 : requests.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if forArchivedRequest || (indexPath.section != 0) {
            let request = requests[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("rideRequestCell") as! TblRideRequestCell
            cell.setInfoFor(request)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("archivedRideCell") as! TVGenericeCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 40 * _widthRatio
        } else {
            return 190 * _widthRatio
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if forArchivedRequest || (indexPath.section != 0) {
            let request = requests[indexPath.row]
            self.navigateToRequestDetail(request)
        }
    }
}

//MARK: API calls
extension MyTravelRequestsVC {
    
    //Get user's travel requests
    func getUserTravelRequest() {
        if !refreshControl.refreshing {
            self.showCentralGraySpinner()
        }
        wsCall.getUserTravelRequests { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    if let objets = json["Object"] as? [[String : AnyObject]] {
                       self.requests.removeAll()
                        for obj in objets {
                            let request = TravelRequest(obj)
                            self.requests.append(request)
                        }
                        self.tableView.reloadData()
                    }
                }
                
            } else {
                //error
            }
            if !self.requests.isEmpty {
                self.emptyDataView.hide()
            }
            self.refreshControl.endRefreshing()
            self.hideCentralGraySpinner()

        }

    }
}
