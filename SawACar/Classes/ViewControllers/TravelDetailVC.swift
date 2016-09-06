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
    
    var travel: Travel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMarkerAndPathOnMap()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: Others
extension TravelDetailVC {
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
            cell.Rules = travel.driver.rules
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("passengersCell") as! TVGenericeCell
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