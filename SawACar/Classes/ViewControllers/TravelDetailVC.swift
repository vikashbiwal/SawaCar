//
//  TravelDetailVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 18/07/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import GoogleMaps

class TravelDetailVC: ParentVC {

    @IBOutlet var gMapView: GMSMapView!
    @IBOutlet var bookBtnView: UIView!
    
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
}

//MARK: Others
extension TravelDetailVC {
    
    //Set Pin marker on map.
    func setMarkerAndPathOnMap() {
        let cameraPositionCoordinates = CLLocationCoordinate2D(latitude: travel.locationFrom!.lat, longitude: travel.locationFrom!.long)
        let cameraPosition = GMSCameraPosition.cameraWithTarget(cameraPositionCoordinates, zoom: 8)
        gMapView.animateToCameraPosition(cameraPosition)
        
        let path = GMSMutablePath()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(travel.locationFrom!.lat, travel.locationFrom!.long)
        marker.groundAnchor = CGPointMake(0.5, 0.5)
        marker.title = travel.locationFrom?.name
        marker.map = gMapView
        path.addCoordinate(CLLocationCoordinate2DMake(travel.locationFrom!.lat, travel.locationFrom!.long))
        
        if let stop1 = travel.locationStop1 {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(stop1.lat, stop1.long)
            marker.groundAnchor = CGPointMake(0.5, 0.5)
            marker.title = stop1.name
            marker.map = gMapView
            path.addCoordinate(CLLocationCoordinate2DMake(stop1.lat, stop1.long))
        }
        
        if let stop2 = travel.locationStop2 {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(stop2.lat, stop2.long)
            marker.groundAnchor = CGPointMake(0.5, 0.5)
            marker.title = stop2.name
            marker.map = gMapView
            path.addCoordinate(CLLocationCoordinate2DMake(stop2.lat, stop2.long))
        }

        if let stop3 = travel.locationStop3 {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(stop3.lat, stop3.long)
            marker.groundAnchor = CGPointMake(0.5, 0.5)
            marker.title = stop3.name
            marker.map = gMapView
            path.addCoordinate(CLLocationCoordinate2DMake(stop3.lat, stop3.long))
        }
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2DMake(travel.locationTo!.lat, travel.locationTo!.long)
        marker2.groundAnchor = CGPointMake(0.5, 0.5)
        marker2.title = travel.locationTo?.name
        marker2.map = gMapView
        path.addCoordinate(CLLocationCoordinate2DMake(travel.locationTo!.lat, travel.locationTo!.long))

        
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 2.0
        rectangle.strokeColor = UIColor.greenColor()
        rectangle.map = gMapView
    }
    
    //open share view for share the travel
    func openShareView() {
        self.shareView.showInView(self.view)
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
            cell.driverRules = travel.driver.rules
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("passengersCell") as! TVTravelPassengersCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 158 * _widthRatio
        } else if indexPath.row == 1 {
            return 110 * _widthRatio
        } else  if indexPath.row == 2 {
            return 100 * _widthRatio
        } else {
            return 0
        }
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
