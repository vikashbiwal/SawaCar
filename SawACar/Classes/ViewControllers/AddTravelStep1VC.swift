//
//  AddTravelStep1VC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class AddTravelStep1VC: ParentVC {

 
    var isLoading = false
    var travel: Travel!
    var dateSelectedForIndex = 0
    
    var datePickerView: VDatePickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadDatePickerView()
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SBID_AddTravelToPublish" {
            let vc = segue.destination as! AddTravelStep2VC
            vc.travel = self.travel
        }
    }
}

//MARK: Tableview datasource and delegate
extension AddTravelStep1VC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier = ""
        if indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "locationCell") as! TVGenericeCell
            cell.lblTitle.text = travel.locationFrom!.name + " >> " + travel.locationTo!.name
            return cell
            
        } else if indexPath.row == 1 {
            cellIdentifier = "stopoverCell"
            let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! StopoverCell
            let stopers = [travel.locationStop1, travel.locationStop2, travel.locationStop3]
            cell.setStoppersInfo(stopers)
            return cell
            
        } else if indexPath.row == 2 {
            cellIdentifier = "rideDateTimeCell"
            let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TravelDateTimeCell
            cell.setDepartureInfoFor(travel)

            return cell
            
        } else if indexPath.row == 3 {
            cellIdentifier = "regularTravelCell"
            let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TravelDateTimeCell
            cell.setRegularTravelInfo(travel)
            return cell
            
        } else if indexPath.row == 4 {
            cellIdentifier = "roundTravelCell"
            let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TravelDateTimeCell
            cell.setRoundTravelInfo(travel)
            return cell
            
        } else {
            cellIdentifier = "buttonCell"
            let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
            return cell
            
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 75 * _widthRatio
        } else if indexPath.row == 1 {
            return 0 //190 * _widthRatio
        } else if indexPath.row == 2 {
            return 90 * _widthRatio
        } else if indexPath.row == 3 {
            return 0 //(travel.isRegularTravel ? 145 : 65) * _widthRatio

        } else if indexPath.row == 4 {
            return (travel.isRoundTravel ? 145 : 65) * _widthRatio

        }  else {
            return 80 * _widthRatio
        }
    }
}

//MARK: IBActions and TableViewCell's actions
extension AddTravelStep1VC {
    @IBAction func stopoversBtnClicked(_ sender: UIButton) {
        goForPickLocation(sender.tag)
    }
    
    @IBAction func stopoverDeleteBtnClicked(_ sender: UIButton ) {
        if sender.tag == 1 {
            travel.locationStop1 = nil
        } else if sender.tag == 2 {
            travel.locationStop2 = nil
        } else { //sender.tag == 3
            travel.locationStop3 = nil
        }
        tableView.reloadData()
    }
    
    @IBAction func travelDateTimeBtnClicked(_ sender: UIButton) {
        dateSelectedForIndex = sender.tag
        var type : DatePickerForType
        
        switch sender.tag {
        case 1:
            type = .regularTravelDate
        case 2:
            type = .roundTravelDate
        case 3:
            type = .roundTravelTime
        case 4:
            type = .departureDate
        case 5:
            type = .departureTime
        default:
            type = .date
        }
        
        showDatePickerView(forType: type)
    }
    
    @IBAction func repeatTypeBtnClicked(_ sender: UIButton) {
        showRepeatTypeList()
    }
    
    @IBAction func regularTravelToggleBtnClicked(_ sender: UIButton) {
        travel.isRegularTravel = !travel.isRegularTravel
        sender.isSelected = !sender.isSelected
        self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
    }
    
    @IBAction func roundTravelToggleBtnclicked(_ sender: UIButton) {
        travel.isRoundTravel = !travel.isRoundTravel
        sender.isSelected = !sender.isSelected
        self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
    }
    
    @IBAction func continueBtnClicked(_ sender: UIButton) {
        if validateTravel() {
            self.performSegue(withIdentifier: "SBID_AddTravelToPublish", sender: nil)
        }
    }
}

//MARK: Other Important Methods
extension AddTravelStep1VC {
    //MARK: Navigation for Pick stopover Locations
    func goForPickLocation(_ forStoper: Int)  {
        let loctionPicker = _generalStoryboard.instantiateViewController(withIdentifier: "SBID_MapViewcontroller") as! MapViewController
        loctionPicker.completionBlcok = {(place) in
            if let place = place {
                if forStoper == 1 {
                    self.travel.locationStop1 = place
                    
                } else if forStoper == 2 {
                    self.travel.locationStop2 = place
                    
                } else {
                    self.travel.locationStop3 = place
                }
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
        }
        self.present(loctionPicker, animated: true, completion: nil)
    }
    
    
    //MARK: Repeat Type selector function
    func showRepeatTypeList() {
        let sheet = UIAlertController(title: "Repeat_Type".localizedString(), message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "cancel".localizedString(), style: .cancel, handler: nil)
        
        let dayTypeAction = UIAlertAction(title: "Day".localizedString(), style: .default) { (action) in
            let cell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? TravelDateTimeCell
            cell?.lblDate.text = "Day".localizedString()
            self.travel.repeatType = 1
        }
        let monthTypeAction = UIAlertAction(title: "Month".localizedString(), style: .default) { (action) in
            let cell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? TravelDateTimeCell
            cell?.lblDate.text = "Month".localizedString()
            self.travel.repeatType = 2
        }
        
        sheet.addAction(dayTypeAction)
        sheet.addAction(monthTypeAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    func validateTravel()-> Bool {
        if travel.isRegularTravel {
            if travel.repeatEndDate.isEmpty  {
                //select car message
                showToastErrorMessage("", message: "kRepeateEndDateRequired".localizedString())
                return false
            }
        }
        if travel.isRoundTravel {
            if travel.roundDate.isEmpty  {
                showToastErrorMessage("", message: "kRoundTravelDepartureDateRequired".localizedString())
                return false
            }
            if travel.roundHour.isEmpty  {
                showToastErrorMessage("", message: "kRoundTravelDepartureTimeRequired".localizedString())
                return false
            }
        }
        
        if travel.departureDate.isEmpty {
            showToastErrorMessage("", message: "kTravelDepartureDateRequired".localizedString())
            return false
        }

        if travel.departureHour.isEmpty {
            showToastErrorMessage("", message: "kTravelDepartureTimeRequired".localizedString())
            return false
        }

        return true
    }

}

//MARK: DatePicker Methods
extension AddTravelStep1VC {
   
    //load picker view from nib file
    func loadDatePickerView() {
        let nibViews = Bundle.main.loadNibNamed("VDatePickerView", owner: nil, options: nil)!
        self.datePickerView = nibViews[0] as! VDatePickerView
        self.datePickerSelectionBlockSetup()
        self.view.addSubview(datePickerView)
    }

    func showDatePickerView(forType type: DatePickerForType) {
        print(dateSelectedForIndex)
        //if [1, 2, 4].contains(dateSelectedForIndex)
        if [DatePickerForType.departureDate, DatePickerForType.regularTravelDate, DatePickerForType.roundTravelDate].contains(type) {
            datePickerView.minDate = Date()
            datePickerView.dateMode = UIDatePickerMode.date
            
        }  else if [DatePickerForType.departureTime, DatePickerForType.roundTravelTime].contains(type) {//Departure Time
            datePickerView.dateMode = UIDatePickerMode.time
            
        }
        
        datePickerView.datePickerForType = type
        datePickerView.show()
    }
    
    //func for setup datePicker date selection callback block
    func datePickerSelectionBlockSetup() {
        datePickerView.dateSelectionBlock = {[weak self](dt, forType) in
            if let selff = self {
                if forType == .regularTravelDate {//Repeat End date
                    let cell = selff.tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? TravelDateTimeCell
                    cell?.lblTime.text = dateFormator.stringFromDate(dt, style: DateFormatter.Style.medium)
                    selff.travel.repeatEndDate = dateFormator.stringFromDate(dt, format: "dd/MM/yyyy")
                    
                } else if forType == .roundTravelDate {//Departure Date
                    let cell = selff.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? TravelDateTimeCell
                    cell?.lblDate.text = dateFormator.stringFromDate(dt, style: DateFormatter.Style.medium)
                    selff.travel.roundDate = dateFormator.stringFromDate(dt, format: "dd/MM/yyyy")
                    
                } else if forType == .roundTravelTime {//Departure Time
                    let cell = selff.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? TravelDateTimeCell
                    let timeString = dateFormator.stringFromDate(dt, format: "HH:mm")//24hourFormat
                    let timeArr = timeString.components(separatedBy: ":")
                    
                    cell?.lblTime.text = dateFormator.stringFromDate(dt, format: "hh:mm a")
                    selff.travel.roundHour = timeArr[0]
                    selff.travel.roundMinute = timeArr[1]
                    
                } else if forType == .departureDate {//Ride Date
                    let cell = selff.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TravelDateTimeCell
                    cell?.lblDate.text = dateFormator.stringFromDate(dt, style: DateFormatter.Style.medium)
                    selff.travel.departureDate = dateFormator.stringFromDate(dt, format: "dd/MM/yyyy")
                    
                } else if forType == .departureTime {//Ride Time
                    let cell = selff.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? TravelDateTimeCell
                    let timeString = dateFormator.stringFromDate(dt, format: "HH:mm")//24hourFormat
                    let timeArr = timeString.components(separatedBy: ":")
                    
                    cell?.lblTime.text = dateFormator.stringFromDate(dt, format: "hh:mm a")
                    selff.travel.departureHour = timeArr[0]
                    selff.travel.departureMinute = timeArr[1]
                    
                }
            }
        }
    }

}

