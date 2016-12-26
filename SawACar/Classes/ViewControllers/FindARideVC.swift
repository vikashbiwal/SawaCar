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
        inputView1.layer.borderColor = UIColor.white.cgColor
        inputView1.layer.cornerRadius = 3.0
        inputView1.clipsToBounds  = true
        
        inputView2.layer.borderWidth = 1.0
        inputView2.layer.borderColor = UIColor.white.cgColor
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findRideToResultSegue" {
            let resultVC = segue.destination as! FindRideResultVC
            resultVC.searchDataObject = searchDataObject
        }
    }

}

//MARK: IBActions
extension FindARideVC {
    @IBAction func fromBtnDidClicked(_ sender: UIButton) {
        goForPickLocation(.from)
    }
    
    @IBAction func toBtnDidClicked(_ sender: UIButton) {
        goForPickLocation(.to)
    }
    
    @IBAction func goBtnClicked(_ sender: UIButton) {
        if self.validateLoction() {
            self.performSegue(withIdentifier: "findRideToResultSegue", sender: nil)
        }
    }
    
    
}

extension FindARideVC {
    func goForPickLocation(_ type: LocationSelectionForType)  {
        let loctionPicker = _generalStoryboard.instantiateViewController(withIdentifier: "SBID_MapViewcontroller") as! MapViewController
        loctionPicker.completionBlcok = {(place) in
            if let place = place {
                if type == .from {
                    self.txtFrom.text = place.address
                    self.searchDataObject.locationFrom = place.address
                } else {
                    self.txtTo.text = place.address
                    self.searchDataObject.locationTo = place.address
                }
            }
        }
        self.present(loctionPicker, animated: true, completion: nil)
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
