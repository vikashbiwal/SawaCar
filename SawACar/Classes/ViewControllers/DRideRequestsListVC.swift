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
    var resultRequests = [TravelRequest]()
   
    let kSectionForLoctionAndTracking = 0
    let kSectionForRideRequests = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        initEmptyDataView()
        searchRideRequestAPICall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: IBAction
    @IBAction func trackingBtnClicked(_ sender: UISwitch) {
        if sender.isOn {
            self.addAlertAPICall()
        }
    }
    
}


//MARK: TableView DataSource and Delegate
extension DRideRequestsListVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == kSectionForLoctionAndTracking ? 3 : resultRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == kSectionForLoctionAndTracking {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! TVGenericeCell
                cell.lblTitle.text = requestSearchObj.countryName
                cell.imgView.image = UIImage(named: "ic_location")
                return cell
                
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! TVGenericeCell
                cell.lblTitle.text = requestSearchObj.travelTypeName
                cell.imgView.image = UIImage(named: "ic_lift_btwn_cities")
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchBtnCell") as! TblSwitchBtnCell
                cell.lblTitle.text = "Keep_searching_for_me".localizedString()
                cell.imgView.image = UIImage(named: "ic_notification_green")
                cell.switchBtn.isOn = false
                
                if let alert  = requestSearchObj.alert {
                    cell.switchBtn.isOn = alert.activated
                }
                
                if let v = cell.viewWithTag(111) {//background view
                    v.layer.borderColor = UIColor.scTravelCardColor().cgColor
                    v.layer.borderWidth = 2
                    v.layer.cornerRadius = 3
                    v.clipsToBounds = true
                    v.backgroundColor = UIColor.white
                }
                return cell
            }
            
        } else { //==kSectionForRideRequests
            let cell = tableView.dequeueReusableCell(withIdentifier: "rideRequestCell") as! TblRideRequestCell
            let request = resultRequests[indexPath.row]
            cell.setInfoFor(request)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == kSectionForLoctionAndTracking {
            if [0, 1].contains(indexPath.row) {
                return 45 * _widthRatio
                
            } else if indexPath.row == 2 {
                return 70 * _widthRatio
                
            }  else {
                return 0
            }

        } else {
            return 190 * _widthRatio
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == kSectionForRideRequests {
            let ride = resultRequests[indexPath.row]
            self.performSegue(withIdentifier: "RideRequestDetailSegue", sender: ride)
        }
    }
}

//MARK: Navigation
extension DRideRequestsListVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RideRequestDetailSegue" {
            let detailVc = segue.destination as! DRideRequestDetailVC
            detailVc.travelRequest = sender as! TravelRequest
        }
    }
}

//MARK: API Calls
extension DRideRequestsListVC {
   
    //Search ride api calls
    func searchRideRequestAPICall() {
        self.showCentralGraySpinner()
        wsCall.searchTravelRequests(requestSearchObj) { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let trObjects = json["Object"] as? [[String : Any]] {
                        for item in trObjects {
                            let request = TravelRequest(item)
                            self.resultRequests.append(request)
                        }
                    }
                }
                
                self.resultRequests.isEmpty ? self.showEmptyDataView("kMyRidesNotAvailable".localizedString(), frame: CGRect(x: 0, y: 280 * _widthRatio, width: _screenSize.width, height: 40)) : self.emptyDataView.hide()
                self.tableView.isScrollEnabled = !self.resultRequests.isEmpty
                self.tableView.reloadData()
            } else {
                showToastMessage("", message: response.message)
            }
            
            self.hideCentralGraySpinner()
        }
        
    }
    
    
    //Add alert for driver api call
    func addAlertAPICall() {
        self.showCentralGraySpinner()
        let params = ["UserID" : me.Id,
                      "CountryID": requestSearchObj.countryId,
                      "TravelTypeID" : requestSearchObj.travelTypeId]
        
        wsCall.addAlertByDriverOnTravelRequest(params) { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let object = json["Object"] as? [String : Any] {
                        let alert = Alert(object)
                        self.requestSearchObj.alert = alert
                    }
                }
            } else {
                showToastErrorMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
    

    
}
