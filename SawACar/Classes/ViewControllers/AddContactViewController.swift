//
//  AddContactViewController.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 15/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class AddContactViewController: ParentVC {

    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var txtTrackingCode: UITextField!
    @IBOutlet var btnDialCode: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Get dial code
    func getCountryInfoFromCurrentLocale() {
        if let countryCode = getCountryCodeFromCurrentLocale() {
            //TODO - Need to update button's title with current country's dial code.
            //We don't have any api to get coutnry info by country code.
            //I (Vikash) already informed to Bushra to develope the required api.
            
        }
        
    }
    
    //MARK: Navigation
    
    func navigateToCountryList() {
        let cListVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_CountryListVC") as! CountryListVC
        //cListVC.selectedCountryId =
        cListVC.titleString = "countries".localizedString()
        
        cListVC.completionBlock = {(country) in
            self.btnDialCode.setTitle("+" + country.dialCode, forState: .Normal)
        }
        self.navigationController?.pushViewController(cListVC, animated: true)

    }
}

extension AddContactViewController {
    
    @IBAction func countryCodeButtonTapped(sender: UIButton) {
        self.navigateToCountryList()
    }
    
    @IBAction func saveBtnTapped(sender: UIButton) {
        //TODO
    }
}
