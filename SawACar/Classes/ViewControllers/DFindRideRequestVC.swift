//
//  DFindRideRequestVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

//Ride request object for creating parameters for find ride request api call
class RideRequestSearchObject {
    var countryId: String = ""
    var countryName: String = ""
    var travelTypeId: String = ""
    var travelTypeName: String = ""
    var alert: Alert?
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
        inputView1.layer.borderColor = UIColor.white.cgColor
        inputView1.layer.cornerRadius = 3.0
        inputView1.clipsToBounds  = true
        
        inputView2.layer.borderWidth = 1.0
        inputView2.layer.borderColor = UIColor.white.cgColor
        inputView2.layer.cornerRadius = 3.0
        inputView2.clipsToBounds  = true
        
    }
    

}

//MARK: IBActions
extension DFindRideRequestVC {
    @IBAction func countryBtnDidClicked(_ sender: UIButton) {
        navigationToCountryList()
    }
    
    @IBAction func travelTypeBtnDidClicked(_ sender: UIButton) {
        navigationToTravelTypeList()
    }
    
    @IBAction func gotoAddTravelBtnClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "FindRequestToResultVC", sender: nil)
    }
    
    
}

//MARK: Navigation
extension DFindRideRequestVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindRequestToResultVC" {
            let nextVC = segue.destination as! DRideRequestsListVC
            nextVC.requestSearchObj = rideRequestObj
        }
    }
    
    //Navigate to country list screen
    func navigationToCountryList()  {
        let cListVC = _generalStoryboard.instantiateViewController(withIdentifier: "SBID_CountryListVC") as! CountryListVC
        cListVC.selectedCountryId = rideRequestObj.countryId
        cListVC.titleString = "Countries".localizedString()
        cListVC.completionBlock = {(country) in
            self.txtCountry.text = country.name
            self.rideRequestObj.countryId = country.Id
            self.rideRequestObj.countryName = country.name
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
    
    //Navigate to travel list screen for selecting travel type
    func navigationToTravelTypeList() {
        let cListVC = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.travelType
        cListVC.preSelectedIDs = [rideRequestObj.travelTypeId]
        
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                let tType = item.obj as! TravelType
                self.txtTravelType.text = tType.name
                self.rideRequestObj.travelTypeId = tType.Id
                self.rideRequestObj.travelTypeName = tType.name
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
    
}
