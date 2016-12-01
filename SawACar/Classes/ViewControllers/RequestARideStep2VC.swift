//
//  RequestARideStep2VC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 24/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit


class RequestARideStep2VC: ParentVC {

    var datePickerView: VDatePickerView!
    var shareView: ShareView!
    
    var tRequest : TravelRequest!
    var sectionRows = [2, 1, 3, 2] //number of rows in tableview sections
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDatePickerView()
        self.loadShareView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//MARK: IBActions
extension RequestARideStep2VC {

    @IBAction func rideDateBtnClicked(sender: UIButton?) {
        self.showDatePicker(.DepartureDate)
    }
    
    @IBAction func rideTimeBtnClicked(sender: UIButton?) {
        self.showDatePicker(.DepartureTime)
    }
    
    //Invoke when user tapped on Currency, Travel type button in the cell.
    @IBAction func listButtonClicked(sender: UIButton) {
        if sender.tag == 0 {//currency
            self.navigationToCurrencyList()
            
        } else if sender.tag == 1 {
            showAddPriceView()
        } else if sender.tag == 2 {//Travel Type
            self.navigationToTravelTypeList()

        }
    }
    
    //Invoke when user tapped on Publish Request button.
    @IBAction func publishRequestBtnClicked(sender: UIButton) {
        let process = tRequest.validateAddRequestProcess()
        if process.isSucss {
            self.addTravelRequestAPICall()
        } else {
            showToastErrorMessage("", message: process.message)
        }
    }
    
    //Invoke when user change monitoring switch's state by tapping it.
    @IBAction func monitoringSwitchBtnClicked(sender: UISwitch) {
        let indexPath = NSIndexPath(forItem: 0, inSection: 3)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? TblSwitchBtnCell {
            cell.lblTitle.textColor = sender.on ? UIColor.scHeaderColor() : UIColor.lightGrayColor()
        }
    }
    
}

extension RequestARideStep2VC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionRows[section]
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  [0,1].contains(section) ? 40 : 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 45 * _widthRatio
        } else if indexPath.section == 1 {
            return 80 * _widthRatio
        } else if indexPath.section == 2 {
            return 52 * _widthRatio
        } else {
            return indexPath.row == 0 ? 50 * _widthRatio : 55 * _widthRatio
        }
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if [0,1].contains(section) {
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TVGenericeCell
            cell.lblTitle.text = section == 0 ? "Start and End point".localizedString() : "Details".localizedString()
            return cell.contentView
        } else {
            let fView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
            fView.backgroundColor = UIColor.clearColor()
            return fView
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fView = UIView(frame: CGRect(x: 0, y: 0, width: _screenSize.width, height: 15))
            fView.backgroundColor = UIColor.clearColor()
        return fView
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let location = indexPath.row == 0 ? tRequest.fromLocation : tRequest.toLocation
            let cell = tableView.dequeueReusableCellWithIdentifier("locationCell") as! TVGenericeCell
            cell.lblTitle.text = location.name
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("rideDateTimeCell") as! TravelDateTimeCell
            cell.setDateAndTime(ForRideRequest: tRequest)
            return cell
            
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("listActionCell") as! TVGenericeCell
            cell.button?.tag = indexPath.row
            if indexPath.row == 0 {
                cell.lblTitle.text = "Currency".localizedString() + " :"
                cell.lblSubTitle.text = tRequest.currency?.name ?? "Select Currency".localizedString()
                cell.lblSubTitle.textColor = tRequest.currency == nil ? UIColor.lightGrayColor() : UIColor.scHeaderColor()
                
            } else if indexPath.row == 1 {
                cell.lblTitle.text = "Suggested Price".localizedString() + " :"
                let price = self.tRequest.suggestedPrice
                if price == 0 {
                    cell.lblSubTitle.text = "Add_suggested_price_ride_request".localizedString()
                } else  {
                    if let currency = tRequest.currency {
                        cell.lblSubTitle.text = currency.symbol + " " + price.ToString()
                    } else {
                        cell.lblSubTitle.text =  price.ToString()
                    }
                }
                cell.lblSubTitle.textColor = price == 0 ? UIColor.lightGrayColor() : UIColor.scHeaderColor()
                
            } else {
                cell.lblTitle.text = "Travel Type".localizedString() + " :"
                cell.lblSubTitle.text =  tRequest.travelType?.name ?? "Select_travel_type".localizedString()
                cell.lblSubTitle.textColor = tRequest.travelType == nil ? UIColor.lightGrayColor() : UIColor.scHeaderColor()
            }
            return cell
            
        } else {
            if indexPath.row == 0 { //
                let cell = tableView.dequeueReusableCellWithIdentifier("switchBtnCell") as! TblSwitchBtnCell
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("buttonCell") as! TVGenericeCell
                return cell
            }
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
}

//MARK: others
extension RequestARideStep2VC {
    func showAddPriceView() {
        let alert = UIAlertController(title: "Your Suggested Price".localizedString(), message: nil, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Price".localizedString()
            let price = self.tRequest.suggestedPrice
            textField.text = price == 0 ? "" : price.ToString()
        }
        
        let addAction = UIAlertAction(title: "Done".localizedString(), style: .Default) { (action) in
            if let tfPrice = alert.textFields?.first {
                let text = tfPrice.text!
                self.tRequest.suggestedPrice = text.isEmpty ? 0 : text.integerValue!
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localizedString(), style: .Default) { (action) in
            
        }

        alert.addAction(cancelAction)
        alert.addAction(addAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

//MARK: Navigations
extension RequestARideStep2VC {
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//    }
    
    //Navigate to Currecy list screen for selecting currency
    func navigationToCurrencyList() {
        let cListVC = _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.Currency
       
        if let currency = tRequest.currency {
            cListVC.preSelectedIDs = [currency.Id]
        }
        
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                let currency = item.obj as! Currency
                self.tRequest.currency = currency
                self.tableView.reloadData()
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)

    }
    
    //Navigate to travel list screen for selecting travel type
    func navigationToTravelTypeList() {
        let cListVC = _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.TravelType
       
        if let tType = tRequest.travelType {
            cListVC.preSelectedIDs = [tType.Id]
        }
        
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                let tType = item.obj as! TravelType
                let indexPath = NSIndexPath(forRow: 2, inSection: 2)
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? TVGenericeCell
                cell?.lblSubTitle.text = tType.name
                cell?.lblSubTitle.textColor = UIColor.scHeaderColor()
                self.tRequest.travelType = tType
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
}

//MARK: DatePicker Setup
extension RequestARideStep2VC {
    
    //load picker view from nib file
    func loadDatePickerView() {
        let nibViews = NSBundle.mainBundle().loadNibNamed("VDatePickerView", owner: nil, options: nil)!
        self.datePickerView = nibViews[0] as! VDatePickerView
        self.datePickerSelectionBlockSetup()
        self.view.addSubview(datePickerView)
    }
    
    //Call this func to Show datePicker with pre setup information. Like Min/Max date, mode etc.
    func showDatePicker(forType: DatePickerForType) {
        if forType == .DepartureDate {
            datePickerView.dateMode = .Date
            datePickerView.minDate = NSDate()
            
        } else if forType == .DepartureTime {
            datePickerView.dateMode = .Time
            datePickerView.minDate = NSDate()
        }
        
        datePickerView.datePickerForType = forType
        datePickerView.show()
    }
    
    //func for setup datePicker date selection callback block
    func datePickerSelectionBlockSetup() {
        datePickerView.dateSelectionBlock = {[weak self](date, forType) in
            if let selff = self {
                if let cell = selff.tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 1)) as? TravelDateTimeCell {
                    if forType == .DepartureDate {
                        selff.tRequest.departureDateString = dateFormator.stringFromDate(date, format: "dd/MM/yyyy hh:mm:ss")
                        cell.lblDate.text = dateFormator.stringFromDate(date, style: NSDateFormatterStyle.MediumStyle)

                    } else if forType == .DepartureTime {
                        let timeString = dateFormator.stringFromDate(date, format: "HH:mm")//24hourFormat
                        let timeArr = timeString.componentsSeparatedByString(":")
                        
                        cell.lblTime.text = dateFormator.stringFromDate(date, format: "hh:mm a")
                        selff.tRequest.departureHour = timeArr[0]
                        selff.tRequest.departureMinute = timeArr[1]
                    }
                }
            }
        }
    }
    
}

//MARK: Share view setup
extension RequestARideStep2VC {
    
    func loadShareView() {
        let nibViews  = NSBundle.mainBundle().loadNibNamed("ShareView", owner: nil, options: nil)
        shareView  = nibViews![0] as! ShareView
        shareView.shareType = .TravelRequest
        //Action block
        shareView.actionBlock = {[weak self] (action) in
            if action == .Share {
                if let selfVc = self {
                    let strShare = "From " + selfVc.tRequest.fromLocation.name + " to " + selfVc.tRequest.toLocation.name + " a travel request has been created by " + me.fullname
                    let activityVC = UIActivityViewController(activityItems: [strShare], applicationActivities: nil)
                    activityVC.completionWithItemsHandler = {(str, isSuccess, obj, error) in
                        selfVc.navigationController?.popToRootViewControllerAnimated(true)
                        selfVc.shareView.hide()
                    }
                    selfVc.presentViewController(activityVC, animated: true, completion: nil)
                }
            } else if action  == .Cancel {//plz do not call hide func here it automatically hide the view.
                self?.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    
}


//MARK: API Calls
extension RequestARideStep2VC {
    
    func addTravelRequestAPICall() {
        self.showCentralGraySpinner()
       
        tRequest.addTravelRequestAPICall { [weak self] (response, flag) in
            if let selff = self {
                selff.shareView.showInView(selff.view)
                selff.hideCentralGraySpinner()

            }
        }
    }
}
