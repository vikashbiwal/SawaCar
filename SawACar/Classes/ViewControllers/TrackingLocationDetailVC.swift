
//
//  TrackingLocationDetailVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 15/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import  GoogleMaps


class TrackingLocationDetailVC: ParentVC, GoogleMapRoutePath  {

    @IBOutlet var  gMapView: GMSMapView!
    var mapView: GMSMapView {get{return gMapView} set{}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let origin = CLLocationCoordinate2D(latitude: 23.0225, longitude: 72.5714)
        let destination = CLLocationCoordinate2D(latitude: 19.0760, longitude: 72.8777)
        
        self.getRoutesFromGoogleApi(origin, destination)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}



