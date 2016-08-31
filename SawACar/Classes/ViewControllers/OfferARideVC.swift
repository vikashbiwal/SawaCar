//
//  OfferARideVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 06/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class OfferARideVC: ParentVC {
    
    @IBOutlet var inputView1: UIView!
    @IBOutlet var inputView2: UIView!
    @IBOutlet var roundedView: UIView!
    @IBOutlet var txtFrom: UITextField!
    @IBOutlet var txtTo: UITextField!
    
    var travel = Travel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRoundCircleUI()
        
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit{
        _defaultCenter.removeObserver(self)
    }
    
    func notificationSetup() {
        _defaultCenter.addObserver(self, selector: #selector(OfferARideVC.resetTravelObj), name: kTravelAddedNotificationKey, object: nil)
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SBSegue_toAddTravel" {
            let addTravelVC = segue.destinationViewController as! AddTravelStep1VC
            addTravelVC.travel  = self.travel
        }
    }

    func setRoundCircleUI()  {
        inputView1.layer.borderWidth = 1.0
        inputView1.layer.borderColor = UIColor.whiteColor().CGColor
        inputView1.layer.cornerRadius = 3.0
        inputView1.clipsToBounds  = true
        
        inputView2.layer.borderWidth = 1.0
        inputView2.layer.borderColor = UIColor.whiteColor().CGColor
        inputView2.layer.cornerRadius = 3.0
        inputView2.clipsToBounds  = true
       
        roundedView.layer.cornerRadius = (260 * _widthRatio) / 2
        roundedView.clipsToBounds = true
    }
    
    //Reset a new travel object when travel created successfully.
    func resetTravelObj() {
        travel = Travel()
        txtTo.text = "To"
        txtFrom.text = "From"
    }
}

//MARK: IBActions
extension OfferARideVC {
    @IBAction func fromBtnDidClicked(sender: UIButton) {
        goForPickLocation(.From)
    }
    
    @IBAction func toBtnDidClicked(sender: UIButton) {
        goForPickLocation(.To)
    }
    
    @IBAction func gotoAddTravelBtnClicked(sender: UIButton) {
        if self.validateLoction() {
            self.performSegueWithIdentifier("SBSegue_toAddTravel", sender: nil)
        }
    }
    

}

extension OfferARideVC {
    func goForPickLocation(type: LocationSelectionForType)  {
        let loctionPicker = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_MapViewcontroller") as! MapViewController
        loctionPicker.completionBlcok = {(place) in
            if let place = place {
                if type == .From {
                    self.txtFrom.text = place.name
                    self.travel.locationFrom = place
                } else {
                    self.txtTo.text = place.name
                    self.travel.locationTo = place
                }
            }
        }
        self.presentViewController(loctionPicker, animated: true, completion: nil)
    }
    
    //Fuction valiation 
    func validateLoction()-> Bool {
        guard let _ = travel.locationFrom else {
            showToastErrorMessage("", message: kFromLocationRequired)
            return false
        }
        guard let _ = travel.locationTo else {
            showToastErrorMessage("", message: kToLocationRequired)
            return false
        }
        return true
    }
}
