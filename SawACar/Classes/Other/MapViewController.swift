//
//  MapViewController.swift
//  LoactionPicker
//
//  Created by Yudiz Solutions Pvt.Ltd. on 08/02/16.
//  Copyright © 2016 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: ParentVC, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var completionBlcok: ((add: GLocation?) -> Void)!
    var selectedPlace : GLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            searchCon.selectionBlock = {[unowned self] (add) -> () in
                self.selectedPlace = add
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                var loc = CLLocationCoordinate2D()
                loc.latitude = add.lat
                loc.longitude = add.long
                
                var span = MKCoordinateSpan()
                span.latitudeDelta = 0.05
                span.longitudeDelta = 0.05
                
                var myResion = MKCoordinateRegion()
                myResion.center = loc
                myResion.span = span
                
                self.mapView.setRegion(myResion, animated: true)
                
                let ano = MKPointAnnotation()
                ano.coordinate = loc
                ano.title = add.address
                self.mapView.addAnnotation(ano)
            }
        }
    }
    

}
