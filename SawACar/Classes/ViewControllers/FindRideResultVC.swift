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
        self.initEmptyDataView()
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

    //MARK: - Navigation
    func navigateToRideDetailsScreen(_ ride: Travel) {
        let detailVC = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_TravelDetailVC") as! TravelDetailVC
        detailVC.travel = ride
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK: IBActions
    @IBAction func trackingSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            addAlertAPICall()
        }
    }
}

//MARK: TableView DataSource
extension FindRideResultVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  section == 0 ? 2 : travels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 { // location cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")  as! TVGenericeCell
                cell.lblTitle.text = searchDataObject.locationFrom
                cell.lblSubTitle.text = searchDataObject.locationTo
                return cell
                
            } else { //tracking switch btn cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchBtnCell")  as! TblSwitchBtnCell
                cell.switchBtn.isOn = false
                if let alert = searchDataObject.alert {
                    cell.switchBtn.isOn = alert.activated
                }
                return cell
            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "travelCell")  as! TVTravelCell
            let ride = travels[indexPath.row]
            cell.setRideInfo(ride)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return (indexPath.row == 0 ? 104 : 60 ) * _widthRatio
        } else {
            return 200 * _widthRatio
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let ride = travels[indexPath.row]
            self.navigateToRideDetailsScreen(ride)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : 40 * _widthRatio
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {return nil}
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! TVGenericeCell
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

//MARK: API Calls
extension FindRideResultVC {
    func findRidesAPICall() {
        self.showCentralGraySpinner()
        let fromAddress = searchDataObject.locationFrom
        let toAddress = searchDataObject.locationTo
        wsCall.findTravels(fromAddress!, toAddress: toAddress!) { (response, flag) in
            if response.isSuccess {
//                if let json = response.json {
//                    if let objects = json["Object"] as? [[String : AnyObject]] {
//                        self.travels.removeAll()
//                        for item in objects {
//                            let travel = Travel(item)
//                            self.travels.append(travel)
//
//                        }
//                        self.tableView.reloadData()
//                    }
//                }
            } else {
                //error
            }
            self.travels.isEmpty ? self.showEmptyDataView("kMyRidesNotAvailable".localizedString(), frame: CGRect(x: 0, y: 280 * _widthRatio, width: _screenSize.width, height: 40)) : self.emptyDataView.hide()
            self.tableView.isScrollEnabled = !self.travels.isEmpty
            self.hideCentralGraySpinner()
        }
    }
    
    //Add alert for passenger api call
    func addAlertAPICall() {
        self.showCentralGraySpinner()
        let params = ["UserID" : me.Id,
                      "LocationFrom": searchDataObject.locationFrom,
                      "LocationTo" : searchDataObject.locationTo]
        
        wsCall.addAlertByPassengerOnTravel(params) { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let object = json["Object"] as? [String : Any] {
                        let alert = Alert(object)
                        self.searchDataObject.alert = alert
                    }
                }
            } else {
                showToastErrorMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
    
}
