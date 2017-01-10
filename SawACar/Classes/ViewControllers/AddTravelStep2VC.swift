//
//  AddTravelStep2VC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 21/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit


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

    override func viewWillAppear(_ animated: Bool) {
        //Add Keybaord observeration
        _defaultCenter.addObserver(self, selector: #selector(AddTravelStep2VC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        _defaultCenter.addObserver(self, selector: #selector(AddTravelStep2VC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _defaultCenter.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SBSegue_ToCarList" {
            let vc = segue.destination as! CarListVC
            vc.selectedCar = travel.car
            vc.completionBlock = {(car) in
                self.travel.car = car
                let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? StopoverCell
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
        let views  = Bundle.main.loadNibNamed("ShareView", owner: nil, options: nil)
        shareView  = views![0] as! ShareView
        shareView.actionBlock = {[weak self] (action) in
            if action == .share {
                if let selfVc = self {
                    let strShare = "From " + selfVc.travel.locationFrom!.name + " to " + selfVc.travel.locationTo!.name + " a travel has been created by " + me.fullname
                    let activityVC = UIActivityViewController(activityItems: [strShare], applicationActivities: nil)
                    activityVC.completionWithItemsHandler = {(str, isSuccess, obj, error) in
                        _ = selfVc.navigationController?.popToRootViewController(animated: true)
                        selfVc.shareView.hide()
                    }
                    selfVc.present(activityVC, animated: true, completion: nil)
                }
            } else if action  == .cancel {//plz do not call hide func here it automatically hide the view.
               _ =  self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    
}

//MARK: Notifications
extension AddTravelStep2VC {
    //Keyboard Notifications
    func keyboardWillShow(_ nf: Notification)  {
        if let kbInfo = nf.userInfo {
            let kbFrame = (kbInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kbFrame.size.height, 0)
        }
    }
    
    func keyboardWillHide(_ nf: Notification)  {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
}

//MARK: Tableview datasource and delegate
extension AddTravelStep2VC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier = ""
        if indexPath.row == 0 {
            cellIdentifier = "switchCell"
            let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TravelSwitchCell
            cell.switchBtn1.isOn = travel.ladiesOnly
            cell.switchBtn1.type = TravelPreferenceType.onlyWomen
            cell.switchBtn2.isOn = travel.trackingEnable
            cell.switchBtn2.type = TravelPreferenceType.tracking
            return cell
            
        } else if indexPath.row == 1 {
            cellIdentifier = "CurrencyCarCell"
            let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! StopoverCell
            cell.lblStop1.text = travel.currency == nil ? "Currency".localizedString() : travel.currency!.name + "(\(travel.currency!.code))"
            cell.lblStop2.text = travel.car == nil ? "Car".localizedString() : travel.car!.name
            return cell
            
        } else if indexPath.row == 6 { //Publish BtnCell
            cellIdentifier = "buttonCell"
            let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TVGenericeCell
            let title = travel.inEditMode ? "SAVE".localizedString() : "PUBLISH".localizedString()
            cell.button!.setTitle(title, for: UIControlState())
            return cell
            
        } else {
            cellIdentifier = "counterCell"
            let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SteperCell
            cell.delegate = self
            if indexPath.row == 2 {
                cell.lblTitle.text = "Number_of_Seat".localizedString()
                cell.txtField.text = travel.travelSeat.value.ToString()
                cell.steperForType = TravelPreferenceType.numberOfSeat
                cell.txtField.isUserInteractionEnabled = false
                
            } else if indexPath.row == 3 {
                cell.lblTitle.text = "Price_Passenger".localizedString()
                let currencySymbol = travel.currency?.symbol ?? ""
                cell.txtField.text =  currencySymbol + "\(travel.passengerPrice.value)"
                cell.steperForType = TravelPreferenceType.passengerPrice
                cell.txtField.isUserInteractionEnabled = true
                
            } else if indexPath.row == 4 {
                cell.lblTitle.text = "Price_Car".localizedString()
                let currencySymbol = travel.currency?.symbol ?? ""
                cell.txtField.text = currencySymbol + travel.carPrice.value.ToString()
                cell.steperForType = TravelPreferenceType.carPrice
                cell.txtField.isUserInteractionEnabled = true
                
            } else  {
                cell.lblTitle.text = "Number_of_luggage".localizedString()
                cell.txtField.text = travel.travelLuggage.value.ToString()
                cell.steperForType = TravelPreferenceType.numberOfLuggage
                cell.txtField.isUserInteractionEnabled = false
            }
            cell.btnIncreaseCount.indexPath = indexPath
            cell.btnDecreaseCount.indexPath = indexPath
            cell.txtField.indexpath = indexPath
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    @IBAction func travelPublishBtnClicked(_ sender: UIButton) {
        if validateTravel() {
            travel.inEditMode ? updateTravelAPICall() : addTravelAPICall()
        }
    }
    
    @IBAction func currencyBtnClicked(_ sender: UIButton) {
        openCurrencyListVC()
    }
    
    @IBAction func carBtnClicked(_ sender: UIButton ) {
        self.performSegue(withIdentifier: "SBSegue_ToCarList", sender: nil)
    }
    
    //Steper cell's counter btn (for seat, price, luggage) clicked
    @IBAction func counterBtnClicked(_ sender: IndexPathButton) {
        var counter: VCounterRange!
        if let cell = tableView.cellForRow(at: sender.indexPath as IndexPath) as? SteperCell {
            let type = cell.steperForType
            switch type {
            case .numberOfSeat:
                travel.travelSeat.value = sender.tag == 1 ? (travel.travelSeat.value - 1) : (travel.travelSeat.value + 1)
                travel.travelSeat.value = valueFromCounterRange(travel.travelSeat)
                cell.txtField.text = travel.travelSeat.value.ToString()
                counter = travel.travelSeat
                break
            case .carPrice:
                let value = sender.tag == 1 ? (travel.carPrice.value - 1) : (travel.carPrice.value + 1)
                travel.carPrice.value = value <= travel.carPrice.min ? travel.passengerPrice.min : value
                let currencySymbol = travel.currency?.symbol ?? ""
                cell.txtField.text = currencySymbol + travel.carPrice.value.ToString()
                counter = travel.carPrice
                break
            case .passengerPrice:
                let value = sender.tag == 1 ? (travel.passengerPrice.value - 1) : (travel.passengerPrice.value + 1)
                travel.passengerPrice.value = value <= travel.passengerPrice.min ? travel.passengerPrice.min : value
                let currencySymbol = travel.currency?.symbol ?? ""
                cell.txtField.text = currencySymbol + travel.passengerPrice.value.ToString()
                counter = travel.passengerPrice
                break
            case .numberOfLuggage:
                travel.travelLuggage.value = sender.tag == 1 ? (travel.travelLuggage.value - 1) : (travel.travelLuggage.value + 1)
                travel.travelLuggage.value = valueFromCounterRange(travel.travelLuggage)
                cell.txtField.text = travel.travelLuggage.value.ToString()
                counter = travel.travelLuggage
                break
            default:
                break
            }
            
            if type == .numberOfSeat || type == .numberOfLuggage {
                if counter.value > counter.min {
                    cell.btnDecreaseCount.isEnabled = true
                } else {
                    cell.btnDecreaseCount.isEnabled = false
                }
                if counter.value >= counter.max {
                    cell.btnIncreaseCount.isEnabled = false
                } else {
                    cell.btnIncreaseCount.isEnabled = true
                }
            }  else {
                if counter.value > counter.min {
                    cell.btnDecreaseCount.isEnabled = true
                } else {
                    cell.btnDecreaseCount.isEnabled = false
                }
            }
        }
    }
    
    //Steper cell textfield did begin editing
    @IBAction func steperTextFieldDidBeginEditing(_ sender: IndexPathTextField) {
        if let cell = tableView.cellForRow(at: sender.indexpath as IndexPath) as? SteperCell {
            let type = cell.steperForType
            switch type {
            case .numberOfSeat:
                cell.txtField.text = travel.travelSeat.value.ToString()
                break
            case .carPrice:
                cell.txtField.text = travel.carPrice.value.ToString()
                break
            case .passengerPrice:
                cell.txtField.text = travel.passengerPrice.value.ToString()
                break
            case .numberOfLuggage:
                cell.txtField.text = travel.travelLuggage.value.ToString()
                break
            default:
                break
            }
            
        }
    }
 
    //Steper cell's textfield didChange editing
    @IBAction func steperTextfieldDidChangedEditing(_ sender: IndexPathTextField) {
        if let cell = tableView.cellForRow(at: sender.indexpath as IndexPath) as? SteperCell {
            let type = cell.steperForType
            var counter: (min: Int, value: Int, max: Int)!
            
            switch type {
            case .numberOfSeat:
                let value = sender.text?.integerValue ?? travel.travelSeat.min
                travel.travelSeat.value = value
                travel.travelSeat.value = valueFromCounterRange(travel.travelSeat)
                cell.txtField.text = travel.travelSeat.value.ToString()
                counter = travel.travelSeat
                break
            case .carPrice:
                let value = sender.text?.integerValue ?? 0
                travel.carPrice.value = value
                cell.txtField.text = travel.carPrice.value.ToString()
                counter = travel.carPrice
                break
            case .passengerPrice:
                let value = sender.text?.integerValue ?? 0
                travel.passengerPrice.value = value
                cell.txtField.text =  travel.passengerPrice.value.ToString()
                counter = travel.passengerPrice
                break
            case .numberOfLuggage:
                let value = sender.text?.integerValue ?? travel.travelLuggage.min
                travel.travelLuggage.value = value
                travel.travelLuggage.value = valueFromCounterRange(travel.travelLuggage)
                cell.txtField.text = travel.travelLuggage.value.ToString()
                counter = travel.travelLuggage
                break
            default:
                break
            }
            
            if type == .numberOfSeat || type == .numberOfLuggage {
                if counter.value >= counter.min {
                    cell.btnDecreaseCount.isEnabled = true
                } else {
                    cell.btnDecreaseCount.isEnabled = false
                }
                
                if counter.value >= counter.max {
                    cell.btnIncreaseCount.isEnabled = false
                } else {
                    cell.btnIncreaseCount.isEnabled = true
                }
            } else {
                if counter.value > counter.min {
                    cell.btnDecreaseCount.isEnabled = true
                } else {
                    cell.btnDecreaseCount.isEnabled = false
                }
            }
        }
    }
    
    //Function call when keyboard (opened for Steper Cell's textField) will hide
    //This function call from Steper cell
    func steperTextFieldCompleteEditing(_ type: TravelPreferenceType, cell: SteperCell) {
        switch type {
        case .numberOfSeat:
            cell.txtField.text = travel.travelSeat.value.ToString()
            break
        case .carPrice:
            let currencySymbol = travel.currency?.symbol ?? ""
            cell.txtField.text = currencySymbol + travel.carPrice.value.ToString()
            break
        case .passengerPrice:
            let currencySymbol = travel.currency?.symbol ?? ""
            cell.txtField.text =  currencySymbol + travel.passengerPrice.value.ToString()
            break
        case .numberOfLuggage:
            cell.txtField.text = travel.travelLuggage.value.ToString()
            break
        default:
            break
        }
    }
    
    @IBAction func switchBtnValueChanged(_ sender: TravelSwitch) {
        let type = sender.type
        if type == TravelPreferenceType.onlyWomen {
            travel.ladiesOnly = sender.isOn
        } else if type == TravelPreferenceType.tracking {
            travel.trackingEnable = sender.isOn
        }
    }
}

//Other Important functions
extension AddTravelStep2VC {
    //navigate to select currency
    func openCurrencyListVC()  {
//        let cListVC = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_ListVC") as! ListViewController
//        cListVC.listType = ListType.currency
        
        let cListVC = VListViewController.loadFromNib()
        cListVC.keyForId = "CurrencyID"
        cListVC.keyForTitle = "Currency"
        cListVC.apiName = APIName.GetActiveCurrency
        
        if let currency = travel.currency {
            cListVC.preSelectedIDs = [currency.Id]
        }
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                if let obj = item.obj as? [String : Any] {
                    let currency = Currency(obj)
                    let indexPath = IndexPath(row: 1, section: 0)
                    let cell = self.tableView.cellForRow(at: indexPath) as? StopoverCell
                    cell?.lblStop1.text = currency.name + " (\(currency.code))"
                    self.travel.currency = currency
                    self.tableView.reloadData()
                }
            }
        }
        self.present(cListVC, animated: true, completion: nil)
    }
    
    //counter value with min, max, and current value
    func valueFromCounterRange(_ counter: VCounterRange)-> Int {
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
                _defaultCenter.post(name: Notification.Name(rawValue: kTravelAddedNotificationKey), object: nil)
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
                if let _ = self {
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
        
        wsCall.getCarOfUser { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String :Any] {
                    let carsObject = json["Object"] as! [[String : Any]]
                    for item in carsObject {
                        self.travel.car = Vehicle(item)
                        self.tableView.reloadData()
                        break
                    }
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

