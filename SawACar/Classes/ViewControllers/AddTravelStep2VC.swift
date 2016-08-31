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
    
    //MARK: view cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
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
            cell.lblStop1.text = travel.currency == nil ? "Currency" : travel.currency!.name + "(\(travel.currency!.code))"
            cell.lblStop2.text = travel.car == nil ? "Car" : travel.car!.name
            return cell
            
        } else if indexPath.row == 6 { //Publish BtnCell
            cellIdentifier = "buttonCell"
            
        } else {
            cellIdentifier = "counterCell"
            let cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SteperCell
            cell.delegate = self
            if indexPath.row == 2 {
                cell.lblTitle.text = "Number of Seat"
                cell.txtField.text = "\(travel.travelSeat.value)"
                cell.steperForType = TravelPreferenceType.NumberOfSeat
                cell.txtField.userInteractionEnabled = false
                
            } else if indexPath.row == 3 {
                cell.lblTitle.text = "Price per Passenger"
                let currencySymbol = travel.currency?.symbol ?? ""
                cell.txtField.text =  currencySymbol + "\(travel.passengerPrice.value)"
                cell.steperForType = TravelPreferenceType.PassengerPrice
                cell.txtField.userInteractionEnabled = true
                
            } else if indexPath.row == 4 {
                cell.lblTitle.text = "Price per Car"
                let currencySymbol = travel.currency?.symbol ?? ""
                cell.txtField.text = currencySymbol + "\(travel.carPice.value)"
                cell.steperForType = TravelPreferenceType.CarPrice
                cell.txtField.userInteractionEnabled = true
                
            } else  {
                cell.lblTitle.text = "Number of luggage"
                cell.txtField.text = "\(travel.travelLuggage.value)"
                cell.steperForType = TravelPreferenceType.NumberOfLuggage
                cell.txtField.userInteractionEnabled = false
            }
            cell.btnIncreaseCount.indexPath = indexPath
            cell.btnDecreaseCount.indexPath = indexPath
            cell.txtField.indexpath = indexPath
            return cell
        }
        let cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        return cell!
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
            addTravelAPICall()
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
                cell.txtField.text = "\(travel.travelSeat.value)"
                counter = travel.travelSeat
                break
            case .CarPrice:
                let value = sender.tag == 1 ? (travel.carPice.value - 1) : (travel.carPice.value + 1)
                travel.carPice.value = value <= travel.carPice.min ? travel.passengerPrice.min : value
                let currencySymbol = travel.currency?.symbol ?? ""
                cell.txtField.text = currencySymbol + "\(travel.carPice.value)"
                counter = travel.carPice
                break
            case .PassengerPrice:
                let value = sender.tag == 1 ? (travel.passengerPrice.value - 1) : (travel.passengerPrice.value + 1)
                travel.passengerPrice.value = value <= travel.passengerPrice.min ? travel.passengerPrice.min : value
                let currencySymbol = travel.currency?.symbol ?? ""
                cell.txtField.text = currencySymbol + "\(travel.passengerPrice.value)"
                counter = travel.passengerPrice
                break
            case .NumberOfLuggage:
                travel.travelLuggage.value = sender.tag == 1 ? (travel.travelLuggage.value - 1) : (travel.travelLuggage.value + 1)
                travel.travelLuggage.value = valueFromCounterRange(travel.travelLuggage)
                cell.txtField.text = "\(travel.travelLuggage.value)"
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
                cell.txtField.text = travel.carPice.value.ToString()
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
                cell.txtField.text = "\(travel.travelSeat.value)"
                counter = travel.travelSeat
                break
            case .CarPrice:
                let value = sender.text?.integerValue ?? 0
                travel.carPice.value = value
                cell.txtField.text = "\(travel.carPice.value)"
                counter = travel.carPice
                break
            case .PassengerPrice:
                let value = sender.text?.integerValue ?? 0
                travel.passengerPrice.value = value
                cell.txtField.text =  "\(travel.passengerPrice.value)"
                counter = travel.passengerPrice
                break
            case .NumberOfLuggage:
                let value = sender.text?.integerValue ?? travel.travelLuggage.min
                travel.travelLuggage.value = value
                travel.travelLuggage.value = valueFromCounterRange(travel.travelLuggage)
                cell.txtField.text = "\(travel.travelLuggage.value)"
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
            cell.txtField.text = currencySymbol + travel.carPice.value.ToString()
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
        let cListVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
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
            showToastErrorMessage("", message: "Please select currency for ride price.")
            return false
        }
        guard let _ = travel.car else {
            //select car message
            showToastErrorMessage("", message: "Please select a car for ride.")
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
        var parameters = [String : AnyObject]()
        let fromLocation = ["Latitude" : travel.locationFrom!.lat.ToString(),
                            "Longitude" : travel.locationFrom!.long.ToString(),
                            "Address" : travel.locationFrom!.address]
        let toLocation = ["Latitude" : travel.locationTo!.lat.ToString(),
                          "Longitude" : travel.locationTo!.long.ToString(),
                          "Address" : travel.locationTo!.address]
        
        parameters["LocationFrom"]      = fromLocation
        parameters["LocationTo"]        = toLocation
        parameters["DepartureDate"]     = travel.departureDate
        parameters["DepartureHour"]     = travel.departureHour
        parameters["DepartureMinute"]   = travel.departureMinute
        parameters["Tracking"]          = travel.trackingEnable
        parameters["LadiesOnly"]        = travel.ladiesOnly
        parameters["Seats"]             = travel.travelSeat.value.ToString()
        parameters["Luggages"]          = travel.travelLuggage.value.ToString()
        parameters["PassengerPrice"]    = travel.passengerPrice.value.ToString()
        parameters["CarPrice"]          = travel.carPice.value.ToString()
        parameters["CarID"]             = travel.car!.id
        parameters["DriverID"]          = me.Id
        parameters["DepartureFlexibility"] = "15"
        parameters["CurrencyID"]        = travel.currency!.Id
        parameters["Details"]           = ""
        if travel.isRegularTravel {
            parameters["RepeatType"]    = travel.repeatType.ToString()
            parameters["RepeatEndDate"] = travel.repeatEndDate
        } else {
            parameters["RepeatType"]    = NSNull()
            parameters["RepeatEndDate"] = NSNull()
        }
        
        if travel.isRoundTravel {
            parameters["RoundDate"]     = travel.roundDate
            parameters["RoundHour"]     = travel.roundHour
            parameters["RoundMinute"]   = travel.roundMinute
        } else {
            parameters["RoundDate"]     = NSNull()
            parameters["RoundHour"]     = NSNull()
            parameters["RoundMinute"]   = NSNull()
        }

        if let stop1 = travel.locationStop1 {
            let LocationStop1 = ["Latitude" : stop1.lat.ToString(),
                                 "Longitude": stop1.long.ToString(),
                                 "Address"  : stop1.address]
            parameters["LocationStop1"] = LocationStop1
        } else {
            parameters["LocationStop1"] = NSNull()
        }

        if let stop2 = travel.locationStop2 {
            let LocationStop2 = ["Latitude" : stop2.lat.ToString(),
                                 "Longitude": stop2.long.ToString(),
                                 "Address"  : stop2.address]
            parameters["LocationStop2"] = LocationStop2
        }  else {
            parameters["LocationStop2"] = NSNull()
        }

        if let stop3 = travel.locationStop3 {
            let LocationStop3 = ["Latitude" : stop3.lat.ToString(),
                                 "Longitude": stop3.long.ToString(),
                                 "Address"  : stop3.address]
            parameters["LocationStop3"] = LocationStop3
        }  else {
            parameters["LocationStop3"] = NSNull()
        }
       
        //Api call
        wsCall.addTravel(parameters) { (response, flag) in
            if response.isSuccess {
                let travelInfo = response.json!["Object"] as! [String :  AnyObject]
                self.travel.updateInfo(travelInfo)
                showToastMessage("", message: "Your travel successfully added.")
                _defaultCenter.postNotificationName(kTravelAddedNotificationKey, object: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            } else {
                showToastErrorMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
        }
    }
}

