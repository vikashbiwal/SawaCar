//
//  DFindRideRequestVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

//Ride request object for creating parameters for find ride request api call
struct RideRequestSearchObject {
    var countryId: String = ""
    var travelTypeId: String = ""
}

class DFindRideRequestVC: ParentVC {

    @IBOutlet var inputView1: UIView!
    @IBOutlet var inputView2: UIView!
    @IBOutlet var roundedView: UIView!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtTravelType: UITextField!

    var rideRequestObj = RideRequestSearchObject()
    
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
    @IBAction func countryBtnDidClicked(sender: UIButton) {
        openCountryList()
    }
    
    @IBAction func travelTypeBtnDidClicked(sender: UIButton) {
        
    }
    
    @IBAction func gotoAddTravelBtnClicked(sender: UIButton) {
        if self.validateLoction() {
            self.performSegueWithIdentifier("FindRequestToResultVC", sender: nil)
        }
    }
    
    
}


extension DFindRideRequestVC {

func openCountryList()  {
    let cListVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_CountryListVC") as! CountryListVC
    cListVC.selectedCountryId = rideRequestObj.countryId
    cListVC.titleString = "nationality".localizedString()
    cListVC.completionBlock = {(country) in
        self.txtCountry.text = country.name
        self.rideRequestObj.countryId = country.Id
    }
    self.navigationController?.pushViewController(cListVC, animated: true)
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
