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
    var isEditRequestMode = false
    
    let kSectionForLocation = 0
    let kSectionForDateTime = 1
    let kSectionForCurrencyPrice = 2
    let kSectionForPublish  = 3
    
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

    @IBAction func rideDateBtnClicked(_ sender: UIButton?) {
        self.showDatePicker(.departureDate)
    }
    
    @IBAction func rideTimeBtnClicked(_ sender: UIButton?) {
        self.showDatePicker(.departureTime)
    }
    
    //Invoke when user tapped on Currency, Travel type button in the cell.
    @IBAction func listButtonClicked(_ sender: UIButton) {
        if sender.tag == 0 {//currency
            self.navigationToCurrencyList()
            
        } else if sender.tag == 1 {
            showAddPriceView()
        } else if sender.tag == 2 {//Travel Type
            self.navigationToTravelTypeList()

        }
    }
    
    //Invoke when user tapped on Publish Request button.
    @IBAction func publishRequestBtnClicked(_ sender: UIButton) {
        let process = tRequest.validateAddRequestProcess()
        if process.isSucss {
            isEditRequestMode ? self.updateTravelRequestApiCall() : self.addTravelRequestAPICall()
        } else {
            showToastErrorMessage("", message: process.message)
        }
    }
    
    //Invoke when user change monitoring switch's state by tapping it.
    @IBAction func monitoringSwitchBtnClicked(_ sender: UISwitch) {
        let indexPath = IndexPath(item: 0, section: 3)
        if let cell = tableView.cellForRow(at: indexPath) as? TblSwitchBtnCell {
            cell.lblTitle.textColor = sender.isOn ? UIColor.scHeaderColor() : UIColor.lightGray
        }
    }
    
}

extension RequestARideStep2VC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionRows[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  [kSectionForLocation,kSectionForDateTime].contains(section) ? 40 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == kSectionForLocation {
            return 45 * _widthRatio
        } else if indexPath.section == kSectionForDateTime {
            return 80 * _widthRatio
        } else if indexPath.section == kSectionForCurrencyPrice {
            return 52 * _widthRatio
        } else {
            return indexPath.row == 0 ? 50 * _widthRatio : 55 * _widthRatio
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if [kSectionForLocation,kSectionForDateTime].contains(section) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! TVGenericeCell
            cell.lblTitle.text = section == 0 ? "Start and End point".localizedString() : "Details".localizedString()
            return cell.contentView
        } else {
            let fView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 15))
            fView.backgroundColor = UIColor.clear
            return fView
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let fView = UIView(frame: CGRect(x: 0, y: 0, width: _screenSize.width, height: 15))
            fView.backgroundColor = UIColor.clear
        return fView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == kSectionForLocation {
            let location = indexPath.row == 0 ? tRequest.fromLocation : tRequest.toLocation
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell") as! TVGenericeCell
            cell.lblTitle.text = location?.name
            return cell
            
        } else if indexPath.section == kSectionForDateTime {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rideDateTimeCell") as! TravelDateTimeCell
            cell.setDateAndTime(ForRideRequest: tRequest)
            return cell
            
        } else if indexPath.section == kSectionForCurrencyPrice {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listActionCell") as! TVGenericeCell
            cell.button?.tag = indexPath.row
            if indexPath.row == 0 {
                cell.lblTitle.text = "Currency".localizedString() + " :"
                cell.lblSubTitle.text = tRequest.currency?.name ?? "Select Currency".localizedString()
                cell.lblSubTitle.textColor = tRequest.currency == nil ? UIColor.lightGray : UIColor.scHeaderColor()
                
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
                cell.lblSubTitle.textColor = price == 0 ? UIColor.lightGray : UIColor.scHeaderColor()
                
            } else {
                cell.lblTitle.text = "Travel Type".localizedString() + " :"
                cell.lblSubTitle.text =  tRequest.travelType?.name ?? "Select_travel_type".localizedString()
                cell.lblSubTitle.textColor = tRequest.travelType == nil ? UIColor.lightGray : UIColor.scHeaderColor()
            }
            return cell
            
        } else {
            if indexPath.row == 0 { //
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchBtnCell") as! TblSwitchBtnCell
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell") as! TVGenericeCell
                let titleText = (isEditRequestMode ? "update" : "PUBLISH").localizedString().uppercased()
                cell.button?.setTitle(titleText, for: UIControlState())
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
}

//MARK: others
extension RequestARideStep2VC {
    func showAddPriceView() {
        let alert = UIAlertController(title: "Your Suggested Price".localizedString(), message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Price".localizedString()
            let price = self.tRequest.suggestedPrice
            textField.text = price == 0 ? "" : price.ToString()
        }
        
        let addAction = UIAlertAction(title: "Done".localizedString(), style: .default) { (action) in
            if let tfPrice = alert.textFields?.first {
                let text = tfPrice.text!
                self.tRequest.suggestedPrice = text.isEmpty ? 0 : text.integerValue!
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localizedString(), style: .default) { (action) in
            
        }

        alert.addAction(cancelAction)
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: Navigations
extension RequestARideStep2VC {
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//    }
    
    //Navigate to Currecy list screen for selecting currency
    func navigationToCurrencyList() {
        let cListVC = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.currency
       
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
        let cListVC = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.travelType
       
        if let tType = tRequest.travelType {
            cListVC.preSelectedIDs = [tType.Id]
        }
        
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                let tType = item.obj as! TravelType
                let indexPath = IndexPath(row: 2, section: 2)
                let cell = self.tableView.cellForRow(at: indexPath) as? TVGenericeCell
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
        let nibViews = Bundle.main.loadNibNamed("VDatePickerView", owner: nil, options: nil)!
        self.datePickerView = nibViews[0] as! VDatePickerView
        self.datePickerSelectionBlockSetup()
        self.view.addSubview(datePickerView)
    }
    
    //Call this func to Show datePicker with pre setup information. Like Min/Max date, mode etc.
    func showDatePicker(_ forType: DatePickerForType) {
        if forType == .departureDate {
            datePickerView.dateMode = .date
            datePickerView.minDate = Date()
        } else if forType == .departureTime {
            datePickerView.dateMode = .time
            datePickerView.minDate = Date()
        }
        datePickerView.currentDate = tRequest.departurDate()
        datePickerView.datePickerForType = forType
        datePickerView.show()
    }
    
    //func for setup datePicker date selection callback block
    func datePickerSelectionBlockSetup() {
        datePickerView.dateSelectionBlock = {[weak self](date, forType) in
            if let selff = self {
                if let cell = selff.tableView.cellForRow(at: IndexPath(item: 0, section: 1)) as? TravelDateTimeCell {
                    if forType == .departureDate {
                        selff.tRequest.departureDateString = dateFormator.stringFromDate(date, format: "dd/MM/yyyy hh:mm:ss")
                        cell.lblDate.text = dateFormator.stringFromDate(date, style: DateFormatter.Style.medium)

                    } else if forType == .departureTime {
                        let timeString = dateFormator.stringFromDate(date, format: "HH:mm")//24hourFormat
                        let timeArr = timeString.components(separatedBy: ":")
                        
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
        let nibViews  = Bundle.main.loadNibNamed("ShareView", owner: nil, options: nil)
        shareView  = nibViews![0] as! ShareView
        shareView.shareType = .travelRequest
        //Action block
        shareView.actionBlock = {[weak self] (action) in
            if action == .share {
                if let selfVc = self {
                    let strShare = "From " + selfVc.tRequest.fromLocation.name + " to " + selfVc.tRequest.toLocation.name + " a travel request has been created by " + me.fullname
                    let activityVC = UIActivityViewController(activityItems: [strShare], applicationActivities: nil)
                    activityVC.completionWithItemsHandler = {(str, isSuccess, obj, error) in
                        _ = selfVc.navigationController?.popToRootViewController(animated: true)
                        selfVc.shareView.hide()
                    }
                    selfVc.present(activityVC, animated: true, completion: nil)
                }
            } else if action  == .cancel {//plz do not call hide func here it automatically hide the view.
                _ = self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    
}


//MARK: API Calls
extension RequestARideStep2VC {
    
    //Add travel api calls
    func addTravelRequestAPICall() {
        self.showCentralGraySpinner()
       
        tRequest.addTravelRequestAPICall { [weak self] (response, flag) in
            if response.isSuccess {
                if let selff = self {
                    selff.shareView.showInView(selff.view)
                    
                }
                
            } else {
                //error
                showToastErrorMessage("", message: response.message)
            }
            self?.hideCentralGraySpinner()
        }
    }
    
    //Update travel request api calls
    func updateTravelRequestApiCall() {
        self.showCentralGraySpinner()
        tRequest.updateTravelRequestAPICall { [weak self] (response, flag) in
            if response.isSuccess {
                if let selff = self {
                    if let json = response.json as? [String : Any] {
                        if let object = json["Object"] as? [String : Any] {
                            selff.tRequest.reset(withInfo: object)
                            showToastMessage("", message: "UpdateRequestSuccess".localizedString())
                           _ = selff.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            } else {
                //error
                showToastErrorMessage("", message: response.message)
            }
            self?.hideCentralGraySpinner()
            
        }
    }
}
