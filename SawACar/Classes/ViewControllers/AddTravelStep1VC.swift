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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SBID_AddTravelToPublish" {
            let vc = segue.destinationViewController as! AddTravelStep2VC
            vc.travel = self.travel
        }
    }
}

//MARK: Tableview datasource and delegate
extension AddTravelStep1VC: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = ""
        if indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCellWithIdentifier("locationCell") as! TVGenericeCell
            cell.lblTitle.text = travel.locationFrom!.name + " >> " + travel.locationTo!.name
            return cell
        } else if indexPath.row == 1 {
            cellIdentifier = "stopoverCell"
        } else if indexPath.row == 2 {
            cellIdentifier = "regularTravelCell"
        } else if indexPath.row == 3 {
            cellIdentifier = "roundTravelCell"
        } else if indexPath.row == 4 {
            cellIdentifier = "weekDayCell"
        } else if indexPath.row == 5 {
            cellIdentifier = "rideDateTimeCell"
        } else {
            cellIdentifier = "buttonCell"
        }
        let cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 75 * _widthRatio
        } else if indexPath.row == 1 {
            return 190 * _widthRatio
        } else if indexPath.row == 2 {
            return 145 * _widthRatio
        } else if indexPath.row == 3 {
            return 145 * _widthRatio
        } else if indexPath.row == 4 {
            return 100 * _widthRatio
        } else if indexPath.row == 5 {
            return 90 * _widthRatio
        } else {
            return 80 * _widthRatio
        }
    }
}

//MARK: IBActions and TableViewCell's actions
extension AddTravelStep1VC {
    @IBAction func stopoversBtnClicked(sender: UIButton) {
        goForPickLocation(sender.tag)
    }
    
    @IBAction func travelDateTimeBtnClicked(sender: UIButton) {
        openDatePicker(sender.tag)
    }
    
    @IBAction func repeatTypeBtnClicked(sender: UIButton) {
        showRepeatTypeList()
    }
    
    @IBAction func continueBtnClicked(sender: UIButton) {
        self.performSegueWithIdentifier("SBID_AddTravelToPublish", sender: nil)
    }
}

//MARK: Other Important Methods
extension AddTravelStep1VC {
    //MARK: Navigation for Pick stopover Locations
    func goForPickLocation(forStoper: Int)  {
        let loctionPicker = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_MapViewcontroller") as! MapViewController
        loctionPicker.completionBlcok = {(place) in
            if let place = place {
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? StopoverCell
                if forStoper == 1 {
                    cell?.lblStop1.text = place.name
                    self.travel.locationStop1 = place
                } else if forStoper == 2 {
                    cell?.lblStop2.text = place.name
                    self.travel.locationStop2 = place
                } else {
                    cell?.lblStop3.text = place.name
                    self.travel.locationStop3 = place
                }
            }
        }
        self.presentViewController(loctionPicker, animated: true, completion: nil)
    }
    
    //MARK: Show DatePicker
    func openDatePicker(type: Int) {
        if !isLoading {
            isLoading = true
            let datepickerVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_DatePickerVC") as! VDatePickerVC
            if [1, 2, 4].contains(type) {//Repeat End date, Departure, Ride Date
                datepickerVC.minDate = NSDate()
            }  else if type == 3 {//Departure Time
                datepickerVC.datePickerMode = UIDatePickerMode.Time
            }  else if type == 5 {//Ride Time
                datepickerVC.datePickerMode = UIDatePickerMode.Time
            }

            datepickerVC.completionBlock = {(date) in
                if let dt = date {
                    if type == 1 {//Repeat End date
                        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as? TravelDateTimeCell
                        cell?.lblTime.text = dateFormator.stringFromDate(dt, style: NSDateFormatterStyle.MediumStyle)
                        self.travel.repeatEndDate = dateFormator.stringFromDate(dt, format: "dd/MM/yyyy")
                    } else if type == 2 {//Departure Date
                        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as? TravelDateTimeCell
                        cell?.lblDate.text = dateFormator.stringFromDate(dt, style: NSDateFormatterStyle.MediumStyle)
                        self.travel.roundDate = dateFormator.stringFromDate(dt, format: "dd/MM/yyyy")
                        
                    } else if type == 3 {//Departure Time
                        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as? TravelDateTimeCell
                        let timeString = dateFormator.stringFromDate(dt, format: "HH:mm")//24hourFormat
                        let timeArr = timeString.componentsSeparatedByString(":")
                        
                        cell?.lblTime.text = dateFormator.stringFromDate(dt, format: "hh:mm a")
                        self.travel.roundHour = timeArr[0]
                        self.travel.roundMinute = timeArr[1]
                        
                    } else if type == 4 {//Ride Date
                        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 0)) as? TravelDateTimeCell
                        cell?.lblDate.text = dateFormator.stringFromDate(dt, style: NSDateFormatterStyle.MediumStyle)
                        self.travel.departureDate = dateFormator.stringFromDate(dt, format: "dd/MM/yyyy")

                    } else if type == 5 {//Ride Time
                        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 0)) as? TravelDateTimeCell
                        let timeString = dateFormator.stringFromDate(dt, format: "HH:mm")//24hourFormat
                        let timeArr = timeString.componentsSeparatedByString(":")
                        
                        cell?.lblTime.text = dateFormator.stringFromDate(dt, format: "hh:mm a")
                        self.travel.departureHour = timeArr[0]
                        self.travel.departureMinute = timeArr[1]

                    }
                }
                self.isLoading = false
            }
            datepickerVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            self.presentViewController(datepickerVC, animated: true, completion: nil)
        }
    }
    
    //MARK: Repeat Type selector function
    func showRepeatTypeList() {
        let sheet = UIAlertController(title: "Repeat Type", message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let dayTypeAction = UIAlertAction(title: "Day", style: .Default) { (action) in
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as? TravelDateTimeCell
            cell?.lblDate.text = "Day"
            self.travel.repeatType = 1
        }
        let monthTypeAction = UIAlertAction(title: "Month", style: .Default) { (action) in
            let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 0)) as? TravelDateTimeCell
            cell?.lblDate.text = "Month"
            self.travel.repeatType = 2
        }
        
        sheet.addAction(dayTypeAction)
        sheet.addAction(monthTypeAction)
        sheet.addAction(cancelAction)
        self.presentViewController(sheet, animated: true, completion: nil)
        
    }
}

//MARK: AddTravel Model Class

