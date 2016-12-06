//
//  AddTravelStep2VC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 21/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

typealias VCounterRange = (min: Int, value: Int, max: Int)

class AddTravelStep2VC: ParentVC {

    var travel: Travel!
    var shareView: ShareView!

    //MARK: view cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initShareView()
        getUserCarsAPICall()
        getCurrency()
    }

    override func viewWillAppear(animated: Bool) {
        //Add Keybaord observeration
        _defaultCenter.addObserver(self, selector: #selector(AddTravelStep2VC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        _defaultCenter.addObserver(self, selector: #selector(AddTravelStep2VC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        _defaultCenter.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SBSegue_ToCarList" {
            let vc = segue.destinationViewController as! CarListVC
            vc.selectedCar = travel.car
            vc.completionBlock = {(car) in
                self.travel.car = car
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? StopoverCell
                cell?.lblStop2.text = car.name
                self.travel.travelSeat.max = car.seatCounter.value
                self.travel.travelSeat.value = car.seatCounter.value
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: Share view setup
extension AddTravelStep2VC {
    func initShareView() {
        let views  = NSBundle.mainBundle().loadNibNamed("ShareView", owner: nil, options: nil)
        shareView  = views![0] as! ShareView
        shareView.actionBlock = {[weak self] (action) in
            if action == .Share {
                if let selfVc = self {
                    let strShare = "From " + selfVc.travel.locationFrom!.name + " to " + selfVc.travel.locationTo!.name + " a travel has been created by " + me.fullname
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

//MARK: Notifications
extension AddTravelStep2VC {
    //Keyboard Notifications
    func keyboardWillShow(nf: NSNotification)  {
        if let kbInfo = nf.userInfo {
            let kbFrame = (kbInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kbFrame.size.height, 0)
        }
    }
    
    func keyboardWillHide(nf: NSNotification)  {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
}

//MARK: Tableview datasource and delegate
extension AddTravelStep2VC: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = ""
        if indexPath.row == 0 {
            cellIdentifier = "switchCell"
            let cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! TravelSwitchCell
            cell.switchBtn1.on = travel.ladiesOnly
            cell.switchBtn1.type = TravelPreferenceType.OnlyWomen
            cell.switchBtn2.on = travel.trackingEnable
            cell.switchBtn2.type = TravelPreferenceType.Tracking
            return cell
            
        } else if indexPath.row == 1 {
            cellIdentifier = "CurrencyCarCell"
            let cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! StopoverCell
            cell.lblStop1.text = travel.currency == nil ? "Currency".localizedString() : travel.currency!.name + "(\(travel.currency!.code))"
            cell.lblStop2.text = travel.car == nil ? "Car".localizedString() : travel.car!.name
            return cell
            
        } else if indexPath.row == 6 { //Publish BtnCell
            cellIdentifier = "buttonCell"
            let cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! TVGenericeCell
            let title = travel.inEditMode ? "SAVE".localizedString() : "PUBLISH".localizedString()
            cell.button!.setTitle(title, forState: .Normal)
            return cell
            
        } else {
            cellIdentifier = "counterCell"
            let cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SteperCell
            cell.delegate = self
            if indexPath.row == 2 {
                cell.lblTitle.text = "Number_of_Seat".localizedString()
                cell.txtField.text = travel.travelSeat.value.ToString()
                cell.steperForType = TravelPreferenceType.NumberOfSeat
                cell.txtField.userInteractionEnabled = false
                
            } else if indexPath.row == 3 {
                cell.lblTitle.text = "Price_Passenger".localizedString()
                let currencySymbol = travel.currency?.symbol ?? ""
                cell.txtField.text =  currencySymbol + "\(travel.passengerPrice.value)"
                cell.steperForType = TravelPreferenceType.PassengerPrice
                cell.txtField.userInteractionEnabled = true
                
            } else if indexPath.row == 4 {
                cell.lblTitle.text = "Price_Car".localizedString()
                let currencySymbol = travel.currency?.symbol ?? ""
                cell.txtField.text = currencySymbol + travel.carPrice.value.ToString()
                cell.steperForType = TravelPreferenceType.CarPrice
                cell.txtField.userInteractionEnabled = true
                
            } else  {
                cell.lblTitle.text = "Number_of_luggage".localizedString()
                cell.txtField.text = travel.travelLuggage.value.ToString()
                cell.steperForType = TravelPreferenceType.NumberOfLuggage
                cell.txtField.userInteractionEnabled = false
            }
            cell.btnIncreaseCount.indexPath = indexPath
            cell.btnDecreaseCount.indexPath = indexPath
            cell.txtField.indexpath = indexPath
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 124 * _widthRatio
        } else if indexPath.row == 1 {
            return 138 * _widthRatio
        } else if indexPath.row == 6 {
            return 80 * _widthRatio
        } else {
            return 45 * _widthRatio
        }
    }
}

//MARK: IBActions
extension AddTravelStep2VC {
    
    @IBAction func travelPublishBtnClicked(sender: UIButton) {
        if validateTravel() {
            travel.inEditMode ? updateTravelAPICall() : addTravelAPICall()
        }
    }
    
    @IBAction func currencyBtnClicked(sender: UIButton) {
        openCurrencyListVC()
    }
    
    @IBAction func carBtnClicked(sender: UIButton ) {
        self.performSegueWithIdentifier("SBSegue_ToCarList", sender: nil)
    }
    
    //Steper cell's counter btn (for seat, price, luggage) clicked
    @IBAction func counterBtnClicked(sender: IndexPathButton) {
        var counter: VCounterRange!
        if let cell = tableView.cellForRowAtIndexPath(sender.indexPath) as? SteperCell {
            let type = cell.steperForType
            switch type {
            case .NumberOfSeat:
                travel.travelSeat.value = sender.tag == 1 ? (travel.travelSeat.value - 1) : (travel.travelSeat.value + 1)
                travel.travelSeat.value = valueFromCounterRange(travel.travelSeat)
                cell.txtField.text = travel.travelSeat.value.ToString()
                counter = travel.travelSeat
                break
            case .CarPrice:
                let value = sender.tag == 1 ? (travel.carPrice.value - 1) : (travel.carPrice.value + 1)
                travel.carPrice.value = value <= travel.carPrice.min ? travel.passengerPrice.min : value
                let currencySymbol = travel.currency?.symbol ?? ""
                cell.txtField.text = currencySymbol + travel.carPrice.value.ToString()
                counter = travel.carPrice
                break
            case .PassengerPrice:
                let value = sender.tag == 1 ? (travel.passengerPrice.value - 1) : (travel.passengerPrice.value + 1)
                travel.passengerPrice.value = value <= travel.passengerPrice.min ? travel.passengerPrice.min : value
                let currencySymbol = travel.currency?.symbol ?? ""
                cell.txtField.text = currencySymbol + travel.passengerPrice.value.ToString()
                counter = travel.passengerPrice
                break
            case .NumberOfLuggage:
                travel.travelLuggage.value = sender.tag == 1 ? (travel.travelLuggage.value - 1) : (travel.travelLuggage.value + 1)
                travel.travelLuggage.value = valueFromCounterRange(travel.travelLuggage)
                cell.txtField.text = travel.travelLuggage.value.ToString()
                counter = travel.travelLuggage
                break
            default:
                break
            }
            
            if type == .NumberOfSeat || type == .NumberOfLuggage {
                if counter.value > counter.min {
                    cell.btnDecreaseCount.enabled = true
                } else {
                    cell.btnDecreaseCount.enabled = false
                }
                if counter.value >= counter.max {
                    cell.btnIncreaseCount.enabled = false
                } else {
                    cell.btnIncreaseCount.enabled = true
                }
            }  else {
                if counter.value > counter.min {
                    cell.btnDecreaseCount.enabled = true
                } else {
                    cell.btnDecreaseCount.enabled = false
                }
            }
        }
    }
    
    //Steper cell textfield did begin editing
    @IBAction func steperTextFieldDidBeginEditing(sender: IndexPathTextField) {
        if let cell = tableView.cellForRowAtIndexPath(sender.indexpath) as? SteperCell {
            let type = cell.steperForType
            switch type {
            case .NumberOfSeat:
                cell.txtField.text = travel.travelSeat.value.ToString()
                break
            case .CarPrice:
                cell.txtField.text = travel.carPrice.value.ToString()
                break
            case .PassengerPrice:
                cell.txtField.text = travel.passengerPrice.value.ToString()
                break
            case .NumberOfLuggage:
                cell.txtField.text = travel.travelLuggage.value.ToString()
                break
            default:
                break
            }
            
        }
    }
 
    //Steper cell's textfield didChange editing
    @IBAction func steperTextfieldDidChangedEditing(sender: IndexPathTextField) {
        if let cell = tableView.cellForRowAtIndexPath(sender.indexpath) as? SteperCell {
            let type = cell.steperForType
            var counter: (min: Int, value: Int, max: Int)!
            
            switch type {
            case .NumberOfSeat:
                let value = sender.text?.integerValue ?? travel.travelSeat.min
                travel.travelSeat.value = value
                travel.travelSeat.value = valueFromCounterRange(travel.travelSeat)
                cell.txtField.text = travel.travelSeat.value.ToString()
                counter = travel.travelSeat
                break
            case .CarPrice:
                let value = sender.text?.integerValue ?? 0
                travel.carPrice.value = value
                cell.txtField.text = travel.carPrice.value.ToString()
                counter = travel.carPrice
                break
            case .PassengerPrice:
                let value = sender.text?.integerValue ?? 0
                travel.passengerPrice.value = value
                cell.txtField.text =  travel.passengerPrice.value.ToString()
                counter = travel.passengerPrice
                break
            case .NumberOfLuggage:
                let value = sender.text?.integerValue ?? travel.travelLuggage.min
                travel.travelLuggage.value = value
                travel.travelLuggage.value = valueFromCounterRange(travel.travelLuggage)
                cell.txtField.text = travel.travelLuggage.value.ToString()
                counter = travel.travelLuggage
                break
            default:
                break
            }
            
            if type == .NumberOfSeat || type == .NumberOfLuggage {
                if counter.value >= counter.min {
                    cell.btnDecreaseCount.enabled = true
                } else {
                    cell.btnDecreaseCount.enabled = false
                }
                
                if counter.value >= counter.max {
                    cell.btnIncreaseCount.enabled = false
                } else {
                    cell.btnIncreaseCount.enabled = true
                }
            } else {
                if counter.value > counter.min {
                    cell.btnDecreaseCount.enabled = true
                } else {
                    cell.btnDecreaseCount.enabled = false
                }
            }
        }
    }
    
    //Function call when keyboard (opened for Steper Cell's textField) will hide
    //This function call from Steper cell
    func steperTextFieldCompleteEditing(type: TravelPreferenceType, cell: SteperCell) {
        switch type {
        case .NumberOfSeat:
            cell.txtField.text = travel.travelSeat.value.ToString()
            break
        case .CarPrice:
            let currencySymbol = travel.currency?.symbol ?? ""
            cell.txtField.text = currencySymbol + travel.carPrice.value.ToString()
            break
        case .PassengerPrice:
            let currencySymbol = travel.currency?.symbol ?? ""
            cell.txtField.text =  currencySymbol + travel.passengerPrice.value.ToString()
            break
        case .NumberOfLuggage:
            cell.txtField.text = travel.travelLuggage.value.ToString()
            break
        default:
            break
        }
    }
    
    @IBAction func switchBtnValueChanged(sender: TravelSwitch) {
        let type = sender.type
        if type == TravelPreferenceType.OnlyWomen {
            travel.ladiesOnly = sender.on
        } else if type == TravelPreferenceType.Tracking {
            travel.trackingEnable = sender.on
        }
    }
}

//Other Important functions
extension AddTravelStep2VC {
    //navigate to select currency
    func openCurrencyListVC()  {
        let cListVC = _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.Currency
        if let currency = travel.currency {
            cListVC.preSelectedIDs = [currency.Id]
        }
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                let currency = item.obj as! Currency
                let indexPath = NSIndexPath(forRow: 1, inSection: 0)
                let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? StopoverCell
                cell?.lblStop1.text = currency.name + " (\(currency.code))"
                self.travel.currency = currency
                self.tableView.reloadData()
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
    
    //counter value with min, max, and current value
    func valueFromCounterRange(counter: VCounterRange)-> Int {
        if counter.value <= counter.min {
            return counter.min
        } else if counter.value >= counter.max {
            return counter.max
        } else {
            return counter.value
        }
    }

    func validateTravel()-> Bool {
        guard let _ = travel.currency else {
        //select currency message
            showToastErrorMessage("", message: "select_Currency_for_Ride".localizedString())
            return false
        }
        guard let _ = travel.car else {
            //select car message
            showToastErrorMessage("", message: "Select_Car_for_Ride".localizedString())
            return false
        }
        return true
    }
}

//MARK: API Calls
extension AddTravelStep2VC {
    
    //MARK: AddTravel API
    func addTravelAPICall () {
        self.showCentralGraySpinner()
        travel.addTravel {[weak self] (isSuccess) in
            if isSuccess {
                if let selff = self {
                _defaultCenter.postNotificationName(kTravelAddedNotificationKey, object: nil)
                selff.shareView.showInView(selff.view)
                }
            } else {
             //
            }
            self?.hideCentralGraySpinner()
        }
    }
    
    //Update travel api call
    func updateTravelAPICall() {
        self.showCentralGraySpinner()
        travel.updateTravel {[weak self] (isSuccess) in
            if isSuccess {
                if let selff = self {
                    //TODO after update success
                }
            } else {
                //
            }
            self?.hideCentralGraySpinner()
        }
    
    }
    
    //Get users car
    func getUserCarsAPICall() {
        if let _ = travel.car {
            return
        }
        
        wsCall.getCarOfUser(me.Id) { (response, flag) in
            if response.isSuccess {
                let carsObject = response.json!["Object"] as! [[String : AnyObject]]
                for item in carsObject {
                    self.travel.car = Car(item)
                    self.tableView.reloadData()
                    break;
                }
            } else {
                
            }
        }
    }

    //get currency for location from where travel will be start.
    func getCurrency() {
        if let _ = travel.currency {
            return
        }
        
        let currencyCode =  getCurrencyCode(forCountryCode: travel.locationFrom!.countryCode)
        if let code = currencyCode {
            // need to call api to get currency by currency code.
            wsCall.GetCurrency(code) { (response, flag) in
                if response.isSuccess {
                    let obj = response.json as! [String : AnyObject]
                    let currInfo = obj["Object"] as! [String :  AnyObject]
                    let currency = Currency(currInfo)
                    self.travel.currency = currency
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //Createa a booking api call
    func bookTravelAPICall() {
        
    }
    
}

