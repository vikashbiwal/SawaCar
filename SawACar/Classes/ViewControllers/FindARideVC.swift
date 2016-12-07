//
//  FindARideVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 01/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class RideSearchObject {
    var locationFrom: String!
    var locationTo: String!
    var alert: Alert?
}

class FindARideVC: ParentVC {

    @IBOutlet var inputView1: UIView!
    @IBOutlet var inputView2: UIView!
    @IBOutlet var roundedView: UIView!
    @IBOutlet var txtFrom: UITextField!
    @IBOutlet var txtTo: UITextField!
    var searchDataObject = RideSearchObject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRoundCircleUI()
        self.view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
    }
    
    //Reset a new travel object when travel created successfully.
    func resetTravelObj() {
        searchDataObject = RideSearchObject()
        txtTo.text = "To".localizedString()
        txtFrom.text = "From".localizedString()
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "findRideToResultSegue" {
            let resultVC = segue.destinationViewController as! FindRideResultVC
            resultVC.searchDataObject = searchDataObject
        }
    }

}

//MARK: IBActions
extension FindARideVC {
    @IBAction func fromBtnDidClicked(sender: UIButton) {
        goForPickLocation(.From)
    }
    
    @IBAction func toBtnDidClicked(sender: UIButton) {
        goForPickLocation(.To)
    }
    
    @IBAction func goBtnClicked(sender: UIButton) {
        if self.validateLoction() {
            self.performSegueWithIdentifier("findRideToResultSegue", sender: nil)
        }
    }
    
    
}

extension FindARideVC {
    func goForPickLocation(type: LocationSelectionForType)  {
        let loctionPicker = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_MapViewcontroller") as! MapViewController
        loctionPicker.completionBlcok = {(place) in
            if let place = place {
                if type == .From {
                    self.txtFrom.text = place.address
                    self.searchDataObject.locationFrom = place.address
                } else {
                    self.txtTo.text = place.address
                    self.searchDataObject.locationTo = place.address
                }
            }
        }
        self.presentViewController(loctionPicker, animated: true, completion: nil)
    }
    
    //Fuction valiation
    func validateLoction()-> Bool {
        guard let _ = searchDataObject.locationFrom else {
            showToastErrorMessage("", message: "kFromLocationRequired".localizedString())
            return false
        }
        guard let _ = searchDataObject.locationTo else {
            showToastErrorMessage("", message: "kToLocationRequired".localizedString())
            return false
        }
        return true
    }
}
