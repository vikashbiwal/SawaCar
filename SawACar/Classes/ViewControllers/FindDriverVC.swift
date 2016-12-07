//
//  FindDriverVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class FindDriverVC: ParentVC {

    @IBOutlet var inputView1: UIView!
    @IBOutlet var inputView2: UIView!
    @IBOutlet var inputView3: UIView!
    @IBOutlet var roundedView: UIView!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtAccountType: UITextField!
    @IBOutlet var txtLanguage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRoundCircleUI()
        // Do any additional setup after loading the view.
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
        
        inputView3.layer.borderWidth = 1.0
        inputView3.layer.borderColor = UIColor.whiteColor().CGColor
        inputView3.layer.cornerRadius = 3.0
        inputView3.clipsToBounds  = true
        
    }

}

extension FindDriverVC {
    

}

extension FindDriverVC {
    //Navigate to country list screen
    func navigationToCountryList()  {
        let cListVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_CountryListVC") as! CountryListVC
        //cListVC.selectedCountryId = rideRequestObj.countryId
        cListVC.titleString = "Countries".localizedString()
        cListVC.completionBlock = {(country) in
            self.txtCountry.text = country.name
            //self.rideRequestObj.countryId = country.Id
            //self.rideRequestObj.countryName = country.name
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
    
    //Navigate to travel list screen for selecting travel type
    func navigationToTravelTypeList() {
        let cListVC = _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.AccountType
        //cListVC.preSelectedIDs = [rideRequestObj.travelTypeId]
        
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                let tType = item.obj as! TravelType
                self.txtAccountType.text = tType.name
                //self.rideRequestObj.travelTypeId = tType.Id
                //self.rideRequestObj.travelTypeName = tType.name
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }

}
