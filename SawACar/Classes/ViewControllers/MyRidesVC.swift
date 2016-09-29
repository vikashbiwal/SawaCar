//
//  MyRidesVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 31/08/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import Firebase

class MyRidesVC: ParentVC {

    var myRides = [Travel]()
    var refreshControl : UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = self.tableView.addRefreshControl(self, selector: #selector(MyRidesVC.getMyRides))
        initEmptyDataView()
        showEmptyDataView(kMyRidesNotAvailable)
        getMyRides()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toRideDetailsSegue" {
            let rideDetailVC = segue.destinationViewController as! TravelDetailVC
            rideDetailVC.travel = sender as! Travel
        }
    }
}

//MARK: TableView DataSource and Delegate
extension MyRidesVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRides.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("travelCell") as! TVTravelCell
        let ride = myRides[indexPath.row]
        cell.lblTravelDate.text = dateFormator.dateString(ride.departureDate, fromFomat: "dd/MM/yyyy hh:mm:ss", toFromat: "dd MMM")//ride.departureDate
        cell.lblTravelTime.text = dateFormator.dateString(ride.departureTime, fromFomat: "HH:mm", toFromat: "hh:mm a")
        cell.lblCarName.text = ride.car?.name
        cell.lblLocationFrom.text = ride.locationFrom?.name
        cell.lblLocationTo.text = ride.locationTo?.name
        cell.lblSeatNumber.text = ride.travelSeat.value.ToString() + " Seats"
        cell.lblSeatsLeft.text = ride.seatLeft.ToString() + " Left"
        cell.lblDriverName.text = ride.driver.name
        cell.lblCarPrice.text = ride.currency!.symbol + " " + ride.passengerPrice.value.ToString()
        cell.ratingView.value = CGFloat(ride.driver.rating)
        cell.imgvDriver.setImageWithURL(NSURL(string: ride.driver.photoURl)!, placeholderImage: _userPlaceholderImage)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200 * _widthRatio
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let ride = myRides[indexPath.row]
        self.performSegueWithIdentifier("toRideDetailsSegue", sender: ride)
    }
}

//MARK: API Calls
extension MyRidesVC {
    func getMyRides() {
        if !refreshControl.refreshing {
            showCentralGraySpinner()
        }
     let userid = me.Id
        wsCall.getTravels(userid) { (response, flag) in
            if response.isSuccess {
            
                let arrRides = response.json!["Object"] as! [[String : AnyObject]]
                if self.refreshControl.refreshing {
                    self.myRides.removeAll()
                }
                for json in arrRides {
                    let ride = Travel(json)
                    self.myRides.append(ride)
                }
                
                self.myRides.isEmpty ? self.showEmptyDataView(kMyRidesNotAvailable) : self.emptyDataView.hide()
                self.tableView.reloadData()
            } else {
                showToastErrorMessage("", message: response.message!)
            }
            self.refreshControl.endRefreshing()
            self.hideCentralGraySpinner()
        }
    }
}