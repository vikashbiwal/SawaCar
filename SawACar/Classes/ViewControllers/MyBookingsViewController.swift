//
//  MyBookingsViewController.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 05/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class MyBookingsViewController: ParentVC {

    var bookings = [Booking]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initEmptyDataView()
        if me.userMode == .Driver {
            self.refreshControl = self.tableView.addRefreshControl(self, selector: #selector(self.getBookingsAPICallForDriver))
            self.getBookingsAPICallForDriver()
        } else {
            self.refreshControl = self.tableView.addRefreshControl(self, selector: #selector(self.getBookingsAPICallsForPassanger))
            self.getBookingsAPICallsForPassanger()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Show view with message when bookings are not available for user.
    func showNoDataView() {
        if bookings.isEmpty {
            let fr = CGRect(x: 0, y: 20, width: ScreenSize.SCREEN_WIDTH, height: 40)
            var message  = ""
            if me.userMode == .Driver {
                message = "No bookings are made on your travels.".localizedString()
            } else {
                message = "No bookings are available.".localizedString()
            }
            self.emptyDataView.showInView(self.tableView, message: message, frame: fr)
        }
    }

}

//MARK: IBAction
extension MyBookingsViewController {

    @IBAction func cancelBookingBtnClicked(sender: UIButton) {
        let booking = bookings[sender.tag]
        me.userMode == .Driver ? self.rejectBookingAPICall(booking) : self.cancelBookingAPICall(booking)
    }
    
    @IBAction func acceptBookingBtnClicked(sender: UIButton) {
        let booking = bookings[sender.tag]
        self.approveBookingAPICall(booking)
    }
}

//MARK: TableViewDataSource
extension MyBookingsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bookingCell") as! TravelBookingCell
        let booking = bookings[indexPath.row]
        cell.setInfo(forBooking: booking)
        cell.btnAccept.tag = indexPath.row
        cell.btnReject.tag = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 190 * _widthRatio
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}

//MARK: API calls
extension MyBookingsViewController {
    
    //Get passenger's bookings
    func getBookingsAPICallsForPassanger() {
        if !refreshControl.refreshing {
            self.showCentralGraySpinner()
        }
        wsCall.getBookings(forPassanger: me.Id) { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    if let bookingArray = json["Object"] as? [[String : AnyObject]] {
                        self.bookings.removeAll()
                        for item in bookingArray {
                            let booking = Booking(item)
                            self.bookings.append(booking)
                        }
                        self.tableView.reloadData()
                    }
                }
                
            } else {
                //error
            }
            self.hideCentralGraySpinner()
            self.refreshControl.endRefreshing()
            self.showNoDataView()
        }
    }
    
    //Get bookings for driver on thier travels
    func getBookingsAPICallForDriver()  {
        if !refreshControl.refreshing {
            self.showCentralGraySpinner()
        }
        wsCall.getBookings(forDriver: me.Id) { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    if let bookingArray = json["Object"] as? [[String : AnyObject]] {
                        self.bookings.removeAll()
                        for item in bookingArray {
                            let booking = Booking(item)
                            self.bookings.append(booking)
                        }
                        self.tableView.reloadData()
                    }
                }
                
            } else {
                //error
            }
            self.hideCentralGraySpinner()
            self.refreshControl.endRefreshing()
            self.showNoDataView()
        }
    }
    
    
    //Cancel booking
    func cancelBookingAPICall(booking: Booking) {
        let alert = UIAlertController(title: "SawaCar", message: "Are you sure you want to cancel your booking?", preferredStyle: .Alert)
        let noAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .Destructive) {(alert) in
            self.showCentralGraySpinner()
            booking.cancelAPICall {[weak self] (response, flag) in
                self?.hideCentralGraySpinner()
                if response.isSuccess {
                    if let json = response.json {
                        if let object = json["Object"] as? [String : AnyObject] {
                            booking.resetInfo(object)
                        }
                    }
                    showToastMessage("", message: "Booking cancelled successfully.")
                    self?.tableView.reloadData()
                    
                } else {
                    showToastMessage("", message: response.message)
                }
            }
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //Approve booking
    func approveBookingAPICall(booking: Booking) {
        let alert = UIAlertController(title: "SawaCar", message: "Are you sure you want to accept booking from '\(booking.userName)' on your Travel \(booking.travelId)?", preferredStyle: .Alert)
        let noAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Destructive) {(alert) in
            self.showCentralGraySpinner()
            booking.approveAPICall {[weak self] (response, flag) in
                self?.hideCentralGraySpinner()
                if response.isSuccess {
                    if let json = response.json {
                        if let object = json["Object"] as? [String : AnyObject] {
                           booking.resetInfo(object)
                        }
                    }
                    showToastMessage("", message: "Booking approved successfully.")
                    self?.tableView.reloadData()

                } else {
                    showToastMessage("", message: response.message)
                }
            }
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //Reject booking
    func rejectBookingAPICall(booking: Booking) {
        let alert = UIAlertController(title: "SawaCar", message: "Are you sure you want to reject booking from '\(booking.userName)' on your Travel \(booking.travelId)?", preferredStyle: .Alert)
        let noAction = UIAlertAction(title: "No", style: .Default, handler: nil)
       
        let yesAction = UIAlertAction(title: "Yes", style: .Destructive) {(alert) in
            self.showCentralGraySpinner()
            booking.rejectAPICall {[weak self] (response, flag) in
                self?.hideCentralGraySpinner()
                if response.isSuccess {
                    if let json = response.json {
                        if let object = json["Object"] as? [String : AnyObject] {
                            booking.resetInfo(object)
                        }
                    }
                    showToastMessage("", message: "Booking rejected successfully.")
                    self?.tableView.reloadData()
                    
                } else {
                    showToastMessage("", message: response.message)
                }
                
            }
        }
    
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}


//Cells

class TravelBookingCell: TVGenericeCell {
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblTravelCode: UILabel!
    @IBOutlet var lblLocationFrom: UILabel!
    @IBOutlet var lblLocationTo: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var cardView : UIView?  //View that contain Travel info.
    @IBOutlet var btnAccept: UIButton!
    @IBOutlet var btnReject: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView?.layer.cornerRadius = 5 * _widthRatio
        cardView?.layer.borderColor = UIColor.scTravelCardColor().CGColor
        cardView?.layer.borderWidth = 1.0

    }
    
    //Set booking info 
    func setInfo(forBooking booking: Booking) {
        lblDate.text = dateFormator.stringFromDate(booking.date, format: "dd MMM")
        lblTime.text = dateFormator.stringFromDate(booking.date, format: "hh:mm a")
        lblTravelCode.text = "Travel".localizedString() + " " + booking.travelId
        //lblLocationFrom.text = booking.locationFrom
        //lblLocationTo.text = booking.locationTo
        lblUserName.text = booking.userName
        imgView.setImageWithURL(NSURL(string: booking.userPhoto)!, placeholderImage: _userPlaceholderImage)
        cardView?.layer.borderColor = booking.status.color().CGColor
        
        if booking.status == .Pending {
            btnAccept.hidden = booking.userId == me.Id
            btnReject.hidden = false
        } else {
            btnAccept.hidden = true
            btnReject.hidden = true
        }

    }
    
}
