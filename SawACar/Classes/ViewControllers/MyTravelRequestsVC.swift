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
        backBtn.setImage(UIImage(named: iconName), for: UIControlState())
        if  forArchivedRequest {
            backBtn.addTarget(self, action: #selector(self.parentBackAction(_:)), for: .touchUpInside)
        } else {
            backBtn.addTarget(self, action: #selector(self.shutterAction(_:)), for: .touchUpInside)
        }
        
        refreshControl = self.tableView.addRefreshControl(self, selector: #selector(self.getUserTravelRequest))
        
        initEmptyDataView()
        showEmptyDataView("kMyRidesNotAvailable".localizedString())
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

    }

    @IBAction func nextBtnClicked(_ sender: UIButton) {
        let requestDetailVC = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_RideRequestDetailVC") as! DRideRequestDetailVC
        self.navigationController?.pushViewController(requestDetailVC, animated: true)
    }
    
    //MARK: Navigations
    func navigateToRequestDetail(_ request: TravelRequest) {
        let requestDetailVC = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_RideRequestDetailVC") as! DRideRequestDetailVC
        requestDetailVC.travelRequest = request
        self.navigationController?.pushViewController(requestDetailVC, animated: true)
    }
}


//MARK: IBActions
extension MyTravelRequestsVC {
    
    @IBAction func archivedRidesButtonClicked(_ sender: UIButton?) {
        //self.navigationToArchivedRides()
    }
}

//MARK: TableView DataSource and Delegate
extension MyTravelRequestsVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return forArchivedRequest ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forArchivedRequest {
            return requests.count
        }
        return  section == 0 ? 1 : requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if forArchivedRequest || (indexPath.section != 0) {
            let request = requests[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "rideRequestCell") as! TblRideRequestCell
            cell.setInfoFor(request)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "archivedRideCell") as! TVGenericeCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 40 * _widthRatio
        } else {
            return 190 * _widthRatio
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        if !refreshControl.isRefreshing {
            self.showCentralGraySpinner()
        }
        wsCall.getUserTravelRequests { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let objets = json["Object"] as? [[String : Any]] {
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
