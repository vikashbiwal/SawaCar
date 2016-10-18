//
//  MapViewController.swift
//  LoactionPicker
//
//  Created by Yudiz Solutions Pvt.Ltd. on 08/02/16.
//  Copyright © 2016 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class MapViewController: ParentVC, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var gMapview: GMSMapView!
    @IBOutlet var searchField: UISearchBar!
    
    var completionBlcok: ((add: GLocation?) -> Void)!
    var selectedPlace : GLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGoogleMapView()
        // Do any additional setup after loading the view.
    }

    //SetGoogle mapView
    func setGoogleMapView() {
        gMapview.myLocationEnabled = true
       // self.view = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBActions
    @IBAction func btnSearchAddTap(sender: UIButton){
        self.performSegueWithIdentifier("locationPickerSegue", sender: nil)
    }
    
    @IBAction func doneBtnClicked(sender: UIButton) {
        completionBlcok(add: selectedPlace)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - MapView
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "locationPickerSegue" {
        
            let searchCon = segue.destinationViewController as! LocationPickerViewController
            searchCon.selectionBlock = {[unowned self] (loc) -> () in
                self.searchField.text = loc.address
                self.selectedPlace = loc
                self.mapView.removeAnnotations(self.mapView.annotations)
                var coord = CLLocationCoordinate2D()
                coord.latitude = loc.lat
                coord.longitude = loc.long
               
                self.gMapview.clear()
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
                marker.title = loc.address
                marker.map = self.gMapview
                let camera = GMSCameraPosition.cameraWithLatitude(coord.latitude, longitude: coord.longitude, zoom: 6.0)
                self.gMapview.animateToCameraPosition(camera)
            }
        }
    }
    

}
