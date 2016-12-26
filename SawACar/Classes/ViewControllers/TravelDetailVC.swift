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
    @IBOutlet var btnShareRide: UIButton!
    
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
        bookBtnView.isHidden = travel.driver.id == me.Id
        tableView.contentInset = UIEdgeInsets(top: mapViewHeightConstraint.constant , left: 0, bottom: 50, right: 0)
        btnEditTrailingConstraint.constant = travel.driver.id == me.Id ? 0 : -55
        
        let shareBtnSelector = travel.driver.id == me.Id ? #selector(self.shareBtnClicked(_:)) : #selector(self.ratingButtonClicked(_:))
        btnShareRide.addTarget(self, action: shareBtnSelector, for: .touchUpInside)
    }
    
    //MARK: Navigations
    
    //Navigate for edit travel
    func navigateForEditTravel() {
        let traveVC =  _driverStoryboard.instantiateViewController(withIdentifier: "SBID_AddTravelStep1") as! AddTravelStep1VC
        traveVC.travel = travel.copy() as! Travel
        traveVC.travel.inEditMode = true
        self.navigationController?.pushViewController(traveVC, animated: true)
    }
    
}

//MARK: IBActions
extension TravelDetailVC {
    //Edit btn action
    @IBAction func editBtnClicked(_ sender: UIButton) {
        self.navigateForEditTravel()
    }
    
    //Book ride button clicked
    @IBAction func bookRideButtonClicked(_ sender: UIButton) {
        self.bookTravel()
    }
    
    //Share button action
    @IBAction func shareBtnClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "travelToGiveRatingSegue", sender: nil)
        // self.openShareView()
    }
    
    @IBAction func ratingButtonClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "travelToGiveRatingSegue", sender: nil)
    }
}

//MARK: Others
extension TravelDetailVC {
    
    //Set Pin marker on map view.
    func setMarkerAndPathOnMap() {
        let cameraPositionCoordinates = CLLocationCoordinate2D(latitude: travel.locationFrom!.lat, longitude: travel.locationFrom!.long)
        let cameraPosition = GMSCameraPosition.camera(withTarget: cameraPositionCoordinates, zoom: 8)
        gMapView.animate(to: cameraPosition)
        
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
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "travelInfoCell") as! TVTravelCell
            cell.lblTravelDate.text = dateFormator.dateString(travel.departureDate, fromFomat: "dd/MM/yyyy HH:mm:ss", toFromat: "MMM dd, yyyy")//ride.departureDate
            cell.lblTravelTime.text = dateFormator.dateString(travel.departureTime, fromFomat: "HH:mm", toFromat: "hh:mm a")
            cell.lblCarName.text = travel.car?.name
            cell.lblLocationFrom.text = travel.locationFrom?.name
            cell.lblLocationTo.text = travel.locationTo?.name
            cell.lblSeatNumber.text = travel.travelSeat.value.ToString() + " Seats"
            cell.lblCarPrice.text = travel.currency!.symbol + " " + travel.passengerPrice.value.ToString()

            return cell
        } else if indexPath.row == 1  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myRulesCell") as! TVDriverRulesCell
            cell.lblTitle.text = (travel.driver.id == me.Id ? "My Rules" : "Driver Rules" ).localizedString()
            cell.driverRules = travel.driver.rules
            cell.collView.reloadData()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "passengersCell") as! TVTravelPassengersCell
            cell.passengers = travel.bookings
            cell.collectionView.reloadData()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableViewDragging {
            let offset = scrollView.contentOffset
            mapViewHeightConstraint.constant = -offset.y
            //self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("starting dragging")
        tableViewDragging = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tableViewDragging = false
    }

}

//MARK: Share view setup
extension TravelDetailVC {
    func initShareView() {
        let views  = Bundle.main.loadNibNamed("ShareView", owner: nil, options: nil)
        shareView  = views![0] as! ShareView
        shareView.actionBlock = {[weak self] (action) in
            if action == .share {
                if let selfVc = self {
                    let strShare = "From " + selfVc.travel.locationFrom!.name + " to " + selfVc.travel.locationTo!.name + " a travel has been created by " + me.fullname
                    let activityVC = UIActivityViewController(activityItems: [strShare], applicationActivities: nil)
                    activityVC.completionWithItemsHandler = {(str, isSuccess, obj, error) in
                        selfVc.shareView.hide()
                    }
                    selfVc.present(activityVC, animated: true, completion: nil)
                }
            } else if action  == .cancel { //plz do not call hide func here it automatically hide the view.
                //self?.shareView.hide()
            }
        }
    }
    
}
