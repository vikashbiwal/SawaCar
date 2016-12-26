//
//  AlertsViewController.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class AlertsViewController: ParentVC {

    var alerts = [Alert]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareUI() {
        self.initEmptyDataView()
        if me.userMode == .driver {
            refreshControl = self.tableView.addRefreshControl(self, selector:  #selector(self.getAlertsForDriverAPICall))
            self.getAlertsForDriverAPICall()

        } else {
            refreshControl = self.tableView.addRefreshControl(self, selector: #selector(self.getAlertsForPassengerAPICall))
            self.getAlertsForPassengerAPICall()
        }
    }
    
    //MARK: Navigation
    //This func invoke when passenger clicked on view matching button.
    func navigateToRideSearch(_ alert: Alert) {
        let findTravelVC = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_FindRideResultVC") as! FindRideResultVC
        
        let searchResultObj = RideSearchObject()
        searchResultObj.locationFrom = alert.locationFrom
        searchResultObj.locationTo = alert.locationTo
        searchResultObj.alert = alert
        findTravelVC.searchDataObject = searchResultObj
        
        self.navigationController?.pushViewController(findTravelVC, animated: true)
    }
    
    //This func invoke when driver clicked on view matching button
    func navigateToRideRequestSearch(_ alert: Alert) {
        let requestSearchVC = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_DRideQuestsVC") as! DRideRequestsListVC
       
        let searchObj = RideRequestSearchObject()
        searchObj.countryId = alert.countryId
        searchObj.countryName = alert.countryName
        
        searchObj.travelTypeId = alert.travelTypeId
        searchObj.travelTypeName = alert.travelTypeName
        searchObj.alert = alert
        requestSearchVC.requestSearchObj = searchObj
        self.navigationController?.pushViewController(requestSearchVC, animated: true)
        
    }

    

}

//MARK: Tableview DataSource
extension AlertsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "travelAlertCell") as! AlertCell
        let alert = alerts[indexPath.row]
        if me.userMode == .driver {
            cell.setInfo(forTravelRequest: alert, index: indexPath.row)
        } else {
            cell.setInfo(forTravel: alert, index: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 * _widthRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: IBActions
extension AlertsViewController{
    
    //navigateTo view matching travels
    @IBAction func viewMatchingBtnClicked(_ sender: UIButton) {
        let alert = alerts[sender.tag]
        me.userMode == .driver ? navigateToRideRequestSearch(alert) : navigateToRideSearch(alert)
    }
}

//MARK: WebServices call
extension AlertsViewController {
    
    //Get alerts for passenger
    func getAlertsForPassengerAPICall() {
        if !refreshControl.isRefreshing {
            self.showCentralGraySpinner()
        }
        wsCall.getAlerts(forPassenger: me.Id) { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let objects = json["Object"] as? [[String : AnyObject]] {
                        self.alerts.removeAll()
                        for object in objects {
                            let alert = Alert(object)
                            self.alerts.append(alert)
                        }
                        self.tableView.reloadData()
                    }
                }
            } else {
                showToastErrorMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
            self.refreshControl.endRefreshing()
            self.alerts.isEmpty ? self.emptyDataView.showInView(self.tableView, message: "NotTravelAlrts".localizedString(), frame: CGRect(x: 0, y: 30, width: ScreenSize.SCREEN_WIDTH, height: 40)) : self.emptyDataView.hide()
        }
        
    }
    
    //Get alerts for passenger
    func getAlertsForDriverAPICall() {
        if !refreshControl.isRefreshing {
            self.showCentralGraySpinner()
        }
        wsCall.getAlerts(forDriver: me.Id) { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let objects = json["Object"] as? [[String : Any]] {
                        self.alerts.removeAll()
                        for object in objects {
                            let alert = Alert(object)
                            self.alerts.append(alert)
                        }
                        self.tableView.reloadData()
                    }
                }
            } else {
                showToastErrorMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
            self.refreshControl.endRefreshing()
            self.alerts.isEmpty ? self.emptyDataView.showInView(self.tableView, message: "NotTravelRequestAlrts".localizedString(), frame: CGRect(x: 0, y: 30, width: ScreenSize.SCREEN_WIDTH, height: 40)) : self.emptyDataView.hide()
        }
        
    }

}

//MARK: AlertCell
class AlertCell: TVGenericeCell {
   @IBOutlet var switchBtn: UISwitch!
   @IBOutlet var notificationBtn: UIButton!
   @IBOutlet var viewMatchingBtn: UIButton!
   @IBOutlet var cardView: UIView!
    @IBOutlet var imgView1: UIImageView!
    @IBOutlet var imgView2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView?.layer.cornerRadius = 5 * _widthRatio
        cardView?.layer.borderColor = UIColor.scTravelCardColor().cgColor
        cardView?.layer.borderWidth = 2.0
    }
    
    //set info for alert added on travel
    func setInfo(forTravel alert: Alert, index: Int) {
        lblTitle.text = alert.locationFrom
        lblSubTitle.text = alert.locationTo
        switchBtn.isOn = alert.activated
        viewMatchingBtn.tag = index
        switchBtn.tag = index
        notificationBtn.tag = index
        imgView1.image = UIImage(named: "ic_location_green")
        imgView2.image = UIImage(named: "ic_location_red")
    }
    
    //set info for alert added on travel request
    func setInfo(forTravelRequest alert: Alert, index: Int) {
        lblTitle.text = alert.countryName
        lblSubTitle.text = alert.travelTypeName
        switchBtn.isOn = alert.activated
        viewMatchingBtn.tag = index
        switchBtn.tag = index
        notificationBtn.tag = index
        imgView1.image = UIImage(named: "ic_location_grey")
        imgView2.image = UIImage(named: "ic_lift_btwn_cities")
    }

}
