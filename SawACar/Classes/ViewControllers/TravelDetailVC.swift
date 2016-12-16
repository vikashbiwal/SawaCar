//
//  TravelDetailVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 18/07/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import GoogleMaps

class TravelDetailVC: ParentVC, GoogleMapRoutePath {

    @IBOutlet var gMapView: GMSMapView!
    @IBOutlet var mapViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var btnEditTrailingConstraint: NSLayoutConstraint!
    
    var mapView: GMSMapView {get{return gMapView} set{}}

    @IBOutlet var bookBtnView: UIView!
    
    var tableViewDragging = false
    var shareView: ShareView!
    
    var travel: Travel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initShareView()
        self.prepareUI()
        self.setMarkerAndPathOnMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //prepare any initial UI
    func prepareUI() {
        bookBtnView.hidden = travel.driver.id == me.Id
        tableView.contentInset = UIEdgeInsets(top: mapViewHeightConstraint.constant , left: 0, bottom: 50, right: 0)
        btnEditTrailingConstraint.constant = travel.driver.id == me.Id ? 0 : -55
    }
    
    //MARK: Navigations
    
    //Navigate for edit travel
    func navigateForEditTravel() {
        let traveVC =  _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_AddTravelStep1") as! AddTravelStep1VC
        traveVC.travel = travel.copy() as! Travel
        traveVC.travel.inEditMode = true
        self.navigationController?.pushViewController(traveVC, animated: true)
    }
    
}

//MARK: IBActions
extension TravelDetailVC {
    //Edit btn action
    @IBAction func editBtnClicked(sender: UIButton) {
        self.navigateForEditTravel()
    }
    
    //Share button action
    @IBAction func shareBtnClicked(sender: UIButton) {
        self.openShareView()
    }
    
    //Book ride button clicked
    @IBAction func bookRideButtonClicked(sender: UIButton) {
        self.bookTravel()
    }
}

//MARK: Others
extension TravelDetailVC {
    
    //Set Pin marker on map view.
    func setMarkerAndPathOnMap() {
        let cameraPositionCoordinates = CLLocationCoordinate2D(latitude: travel.locationFrom!.lat, longitude: travel.locationFrom!.long)
        let cameraPosition = GMSCameraPosition.cameraWithTarget(cameraPositionCoordinates, zoom: 8)
        gMapView.animateToCameraPosition(cameraPosition)
        
        let origin = CLLocationCoordinate2D(latitude: travel.locationFrom!.lat, longitude: travel.locationFrom!.long)
        let destination = CLLocationCoordinate2D(latitude: travel.locationTo!.lat, longitude: travel.locationTo!.long)
        self.getRoutesFromGoogleApi(origin, destination)
    }
    
    //open share view for share the travel
    func openShareView() {
        self.shareView.showInView(self.view)
    }
    
    //BookTravel
    func bookTravel() {
        //let alert = UIAlertController(title: "", message: <#T##String?#>, preferredStyle: <#T##UIAlertControllerStyle#>)
        travel.bookTravel(forSeats: 2) { (response, flag) in
            
        }

    }
}

//MARK: TableView DataSource and Delegate
extension TravelDetailVC : UITableViewDataSource, UITableViewDelegate {
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("travelInfoCell") as! TVTravelCell
            cell.lblTravelDate.text = dateFormator.dateString(travel.departureDate, fromFomat: "dd/MM/yyyy HH:mm:ss", toFromat: "MMM dd, yyyy")//ride.departureDate
            cell.lblTravelTime.text = dateFormator.dateString(travel.departureTime, fromFomat: "HH:mm", toFromat: "hh:mm a")
            cell.lblCarName.text = travel.car?.name
            cell.lblLocationFrom.text = travel.locationFrom?.name
            cell.lblLocationTo.text = travel.locationTo?.name
            cell.lblSeatNumber.text = travel.travelSeat.value.ToString() + " Seats"
            cell.lblCarPrice.text = travel.currency!.symbol + " " + travel.passengerPrice.value.ToString()

            return cell
        } else if indexPath.row == 1  {
            let cell = tableView.dequeueReusableCellWithIdentifier("myRulesCell") as! TVDriverRulesCell
            cell.lblTitle.text = (travel.driver.id == me.Id ? "My Rules" : "Driver Rules" ).localizedString()
            cell.driverRules = travel.driver.rules
            cell.collView.reloadData()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("passengersCell") as! TVTravelPassengersCell
            cell.passengers = travel.bookings
            cell.collectionView.reloadData()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 180 * _widthRatio
        } else if indexPath.row == 1 {
            return 110 * _widthRatio
        } else  if indexPath.row == 2 {
            return 100 * _widthRatio
        } else {
            return 0
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if tableViewDragging {
            let offset = scrollView.contentOffset
            mapViewHeightConstraint.constant = -offset.y
            //self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("starting dragging")
        tableViewDragging = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        tableViewDragging = false
    }

}

//MARK: Share view setup
extension TravelDetailVC {
    func initShareView() {
        let views  = NSBundle.mainBundle().loadNibNamed("ShareView", owner: nil, options: nil)
        shareView  = views![0] as! ShareView
        shareView.actionBlock = {[weak self] (action) in
            if action == .Share {
                if let selfVc = self {
                    let strShare = "From " + selfVc.travel.locationFrom!.name + " to " + selfVc.travel.locationTo!.name + " a travel has been created by " + me.fullname
                    let activityVC = UIActivityViewController(activityItems: [strShare], applicationActivities: nil)
                    activityVC.completionWithItemsHandler = {(str, isSuccess, obj, error) in
                        selfVc.shareView.hide()
                    }
                    selfVc.presentViewController(activityVC, animated: true, completion: nil)
                }
            } else if action  == .Cancel { //plz do not call hide func here it automatically hide the view.
                //self?.shareView.hide()
            }
        }
    }
    
}
