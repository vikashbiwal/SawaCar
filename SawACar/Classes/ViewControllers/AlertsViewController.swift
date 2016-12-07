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
        if me.userMode == .Driver {
            refreshControl = self.tableView.addRefreshControl(self, selector:  #selector(self.getAlertsForDriverAPICall))
            self.getAlertsForDriverAPICall()

        } else {
            refreshControl = self.tableView.addRefreshControl(self, selector: #selector(self.getAlertsForPassengerAPICall))
            self.getAlertsForPassengerAPICall()
        }
    }
    
    //MARK: Navigation
    //This func invoke when passenger clicked on view matching button.
    func navigateToRideSearch(alert: Alert) {
        let findTravelVC = _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_FindRideResultVC") as! FindRideResultVC
        
        let searchResultObj = RideSearchObject()
        searchResultObj.locationFrom = alert.locationFrom
        searchResultObj.locationTo = alert.locationTo
        searchResultObj.alert = alert
        findTravelVC.searchDataObject = searchResultObj
        
        self.navigationController?.pushViewController(findTravelVC, animated: true)
    }
    
    //This func invoke when driver clicked on view matching button
    func navigateToRideRequestSearch(alert: Alert) {
        let requestSearchVC = _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_DRideQuestsVC") as! DRideRequestsListVC
       
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("travelAlertCell") as! AlertCell
        let alert = alerts[indexPath.row]
        if me.userMode == .Driver {
            cell.setInfo(forTravelRequest: alert, index: indexPath.row)
        } else {
            cell.setInfo(forTravel: alert, index: indexPath.row)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100 * _widthRatio
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

//MARK: IBActions
extension AlertsViewController{
    
    //navigateTo view matching travels
    @IBAction func viewMatchingBtnClicked(sender: UIButton) {
        let alert = alerts[sender.tag]
        me.userMode == .Driver ? navigateToRideRequestSearch(alert) : navigateToRideSearch(alert)
    }
}

//MARK: WebServices call
extension AlertsViewController {
    
    //Get alerts for passenger
    func getAlertsForPassengerAPICall() {
        if !refreshControl.refreshing {
            self.showCentralGraySpinner()
        }
        wsCall.getAlerts(forPassenger: me.Id) { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
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
                showToastErrorMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
            self.refreshControl.endRefreshing()
            self.alerts.isEmpty ? self.emptyDataView.showInView(self.tableView, message: "NotTravelAlrts".localizedString(), frame: CGRect(x: 0, y: 30, width: ScreenSize.SCREEN_WIDTH, height: 40)) : self.emptyDataView.hide()
        }
        
    }
    
    //Get alerts for passenger
    func getAlertsForDriverAPICall() {
        if !refreshControl.refreshing {
            self.showCentralGraySpinner()
        }
        wsCall.getAlerts(forDriver: me.Id) { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
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
                showToastErrorMessage("", message: response.message!)
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
        cardView?.layer.borderColor = UIColor.scTravelCardColor().CGColor
        cardView?.layer.borderWidth = 2.0
    }
    
    //set info for alert added on travel
    func setInfo(forTravel alert: Alert, index: Int) {
        lblTitle.text = alert.locationFrom
        lblSubTitle.text = alert.locationTo
        switchBtn.on = alert.activated
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
        switchBtn.on = alert.activated
        viewMatchingBtn.tag = index
        switchBtn.tag = index
        notificationBtn.tag = index
        imgView1.image = UIImage(named: "ic_location_grey")
        imgView2.image = UIImage(named: "ic_lift_btwn_cities")
    }

}
