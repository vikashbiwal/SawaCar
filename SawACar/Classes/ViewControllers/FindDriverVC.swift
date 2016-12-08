//
//  FindDriverVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class SearchDriverParameter {
    var countryId: String = ""
    var accountTypeId: String = ""
    var languageId: String = ""
}

class FindDriverVC: ParentVC {

    @IBOutlet var inputView1: UIView!
    @IBOutlet var inputView2: UIView!
    @IBOutlet var inputView3: UIView!
    @IBOutlet var roundedView: UIView!
    @IBOutlet var txtCountry: UITextField!
    @IBOutlet var txtAccountType: UITextField!
    @IBOutlet var txtLanguage: UITextField!
    
    let searchParams = SearchDriverParameter()
    
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

//MARK: IBActions
extension FindDriverVC {
    
    @IBAction func countryBtnClicked(sender: UIButton) {
        self.navigationToCountryList()
    }
    
    @IBAction func accoutyTypeBtnClicked(sender: UIButton) {
        self.navigationToAccountTypeList()
    }
    
    @IBAction func languageBtnClicked(sender: UIButton) {
        self.navigationToLanguageList()
    }
    
    @IBAction func nextBtnClicked(sender: UIButton) {
        self.performSegueWithIdentifier("DriverSearchResultSegue", sender: nil)
    }
    
}

//MARK: Navigations
extension FindDriverVC {
    
    //prepare segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DriverSearchResultSegue" {
            let resultVC = segue.destinationViewController as! DriverSearchResultVC
            resultVC.searchParamObj = searchParams
        }
    }
    
    //Navigate to country list screen
    func navigationToCountryList()  {
        let cListVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_CountryListVC") as! CountryListVC
        cListVC.selectedCountryId = searchParams.countryId
        cListVC.titleString = "Countries".localizedString()
        cListVC.completionBlock = {(country) in
            self.txtCountry.text = country.name
            self.searchParams.countryId = country.Id
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
    
    //Navigate to accountType list screen for selecting travel type
    func navigationToAccountTypeList() {
        let cListVC = _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.AccountType
        cListVC.preSelectedIDs = [searchParams.accountTypeId]
        
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                let tType = item.obj as! AccountType
                self.txtAccountType.text = tType.name
                self.searchParams.accountTypeId = tType.Id
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
    
    //Navigate to languages list screen for selecting travel type
    func navigationToLanguageList() {
        let cListVC = _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.Language
        cListVC.preSelectedIDs = [searchParams.languageId]
        
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                let tType = item 
                self.txtLanguage.text = tType.name
                self.searchParams.languageId = tType.Id
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }


}
