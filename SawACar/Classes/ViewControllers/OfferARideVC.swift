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
        notificationSetup()
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
        _defaultCenter.addObserver(self, selector: #selector(OfferARideVC.resetTravelObj), name: NSNotification.Name(rawValue: kTravelAddedNotificationKey), object: nil)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SBSegue_toAddTravel" {
            let addTravelVC = segue.destination as! AddTravelStep1VC
            addTravelVC.travel  = self.travel
        }
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
        travel = Travel()
        txtTo.text = "To".localizedString()
        txtFrom.text = "From".localizedString()
    }
}

//MARK: IBActions
extension OfferARideVC {
    @IBAction func fromBtnDidClicked(_ sender: UIButton) {
        goForPickLocation(.from)
    }
    
    @IBAction func toBtnDidClicked(_ sender: UIButton) {
        goForPickLocation(.to)
    }
    
    @IBAction func gotoAddTravelBtnClicked(_ sender: UIButton) {
        if self.validateLoction() {
            self.performSegue(withIdentifier: "SBSegue_toAddTravel", sender: nil)
        }
    }
    

}

extension OfferARideVC {
    func goForPickLocation(_ type: LocationSelectionForType)  {
        let loctionPicker = _generalStoryboard.instantiateViewController(withIdentifier: "SBID_MapViewcontroller") as! MapViewController
        loctionPicker.completionBlcok = {(place) in
            if let place = place {
                if type == .from {
                    self.txtFrom.text = place.name
                    self.travel.locationFrom = place
                } else {
                    self.txtTo.text = place.name
                    self.travel.locationTo = place
                }
            }
        }
        self.present(loctionPicker, animated: true, completion: nil)
    }
    
    //Fuction valiation 
    func validateLoction()-> Bool {
        guard let _ = travel.locationFrom else {
            showToastErrorMessage("", message: "kFromLocationRequired".localizedString())
            return false
        }
        guard let _ = travel.locationTo else {
            showToastErrorMessage("", message: "kToLocationRequired".localizedString())
            return false
        }
        return true
    }
}
