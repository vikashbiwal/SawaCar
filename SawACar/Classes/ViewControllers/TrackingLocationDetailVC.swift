
//
//  TrackingLocationDetailVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 15/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import  GoogleMaps

class TrackingLocationDetailVC: ParentVC {

    @IBOutlet var gMapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRoutesFromGoogleApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TrackingLocationDetailVC {
    
    func getRoutesFromGoogleApi() {
        var routesLocations = [GLocation]()
       
        let distanceGoogleAPIKey = "AIzaSyAC40wXatoqq5unQPkx5t5RwmFr1pxNHR8"
        let fromAddress = "Maninagar"
        let toAddress = "Shyamal"
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?"
        let paramtersURL = "origin=\(fromAddress)&destination=\(toAddress)&key=\(distanceGoogleAPIKey)"
        let characterSet = NSCharacterSet.URLPathAllowedCharacterSet()
        let queryURLString = urlString + paramtersURL.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!
        
        let operation = LocationOperation(strUrl: queryURLString) { (response) in
            if let response = response as? [String : AnyObject] {
                if let routes = response["routes"] as? [[String : AnyObject]] {
                    if let firstRoute = routes.first {
                        if let legs = firstRoute["legs"] as? [[String : AnyObject]] {
                            if let firstLeg = legs.first {
                                if let steps = firstLeg["steps"] as? [[String : AnyObject]] {
                                    for step in steps {
                                        if let startLocation = step["start_location"] as? [String : AnyObject] {
                                            let location = GLocation(fromGoogleRoute: startLocation)
                                            routesLocations.append(location)
                                        }
                                        
                                        if let endLocation = step["end_location"] as? [String : AnyObject] {
                                            let location = GLocation(fromGoogleRoute: endLocation)
                                            routesLocations.append(location)
                                        }

                                    }
                                }
                            }
                        }
                    }
                }
                
                print(routesLocations)
                dispatch_async(dispatch_get_main_queue(), { 
                    self.drawRouteOnGoogleMap(forLocations: routesLocations)
                })
            }
        }
        let operationQueue = NSOperationQueue()
        operationQueue.addOperation(operation)
    }
    
    func drawRouteOnGoogleMap(forLocations locations: [GLocation]) {
//        let cameraPositionCoordinates = CLLocationCoordinate2D(latitude: travelRequest.fromLocation!.lat, longitude: travelRequest.fromLocation!.long)
//        let cameraPosition = GMSCameraPosition.cameraWithTarget(cameraPositionCoordinates, zoom: 8)
//        gMapView.animateToCameraPosition(cameraPosition)
        
        let path = GMSMutablePath()
       
        for location in locations {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(location.lat, location.long)
            marker.groundAnchor = CGPointMake(0.5, 0.5)
            //marker.map = gMapView
            path.addCoordinate(marker.position)
        }
        
        
        
        
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 2.0
        rectangle.strokeColor = UIColor.greenColor()
        rectangle.map = gMapView
    }
    
    //MARK: MapView - Marker pin and path line setup.
    

}
