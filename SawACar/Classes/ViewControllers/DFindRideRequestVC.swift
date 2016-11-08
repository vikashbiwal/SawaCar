//
//  DFindRideRequestVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class DFindRideRequestVC: ParentVC {

    @IBOutlet var inputView1: UIView!
    @IBOutlet var inputView2: UIView!
    @IBOutlet var roundedView: UIView!
    @IBOutlet var txtFrom: UITextField!
    @IBOutlet var txtTo: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRoundCircleUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Func for circle view with location input
    func setRoundCircleUI()  {
        inputView1.layer.borderWidth = 1.0
        inputView1.layer.borderColor = UIColor.whiteColor().CGColor
        inputView1.layer.cornerRadius = 3.0
        inputView1.clipsToBounds  = true
        
        inputView2.layer.borderWidth = 1.0
        inputView2.layer.borderColor = UIColor.whiteColor().CGColor
        inputView2.layer.cornerRadius = 3.0
        inputView2.clipsToBounds  = true
        
    }
    

}

//MARK: IBActions
extension DFindRideRequestVC {
    @IBAction func fromBtnDidClicked(sender: UIButton) {
        goForPickLocation(.From)
    }
    
    @IBAction func toBtnDidClicked(sender: UIButton) {
        goForPickLocation(.To)
    }
    
    @IBAction func gotoAddTravelBtnClicked(sender: UIButton) {
        if self.validateLoction() {
            self.performSegueWithIdentifier("FindRequestToResultVC", sender: nil)
        }
    }
    
    
}


extension DFindRideRequestVC {
    func goForPickLocation(type: LocationSelectionForType)  {
        let loctionPicker = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_MapViewcontroller") as! MapViewController
        loctionPicker.completionBlcok = {(place) in
            if let place = place {
                if type == .From {
                    self.txtFrom.text = place.name
                } else {
                    self.txtTo.text = place.name
                }
            }
        }
        self.presentViewController(loctionPicker, animated: true, completion: nil)
    }
    
    //Fuction valiation
    func validateLoction()-> Bool {
//        guard let _ = travel.locationFrom else {
//            showToastErrorMessage("", message: kFromLocationRequired)
//            return false
//        }
//        guard let _ = travel.locationTo else {
//            showToastErrorMessage("", message: kToLocationRequired)
//            return false
//        }
        return true
    }
}
