//
//  RequestARideVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 24/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class RequestARideVC: ParentVC {

    @IBOutlet var inputView1: UIView!
    @IBOutlet var inputView2: UIView!
    @IBOutlet var roundedView: UIView!
    @IBOutlet var txtFrom: UITextField!
    @IBOutlet var txtTo: UITextField!
    var tRequest = TravelRequest()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRoundCircleUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "requestRideStep1Tostep2Segue" {
            let nextVc = segue.destination as! RequestARideStep2VC
            nextVc.tRequest = self.tRequest
        }
    }
}

//MARK: IBActions
extension RequestARideVC {
    @IBAction func fromBtnDidClicked(_ sender: UIButton) {
        navigateToLocationPicker(.from)
    }
    
    @IBAction func toBtnDidClicked(_ sender: UIButton) {
        navigateToLocationPicker(.to)
    }
    
    @IBAction func goNextBtnClicked(_ sender: UIButton) {

        if self.validateLoction() {
            self.performSegue(withIdentifier: "requestRideStep1Tostep2Segue", sender: nil)
        }
    } 
    
    @IBAction func searchRideBtnClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toFindARideVCSegue", sender: nil)
    }
    
    @IBAction func searchDriverBtnClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "FindDriverSegue", sender: nil)
    }
}

//MARK: Others
extension RequestARideVC {
    func navigateToLocationPicker(_ type: LocationSelectionForType)  {
        let loctionPicker = _generalStoryboard.instantiateViewController(withIdentifier: "SBID_MapViewcontroller") as! MapViewController
        loctionPicker.completionBlcok = {(place) in
            if let place = place {
                if type == .from {
                    self.txtFrom.text = place.name
                    self.tRequest.fromLocation = place
                } else {
                    self.txtTo.text = place.name
                    self.tRequest.toLocation = place
                }
            }
        }
        self.present(loctionPicker, animated: true, completion: nil)
    }
    
    //Fuction valiation
    func validateLoction()-> Bool {
        guard let _ = tRequest.fromLocation else {
            showToastErrorMessage("", message: "kFromLocationRequired".localizedString())
            return false
        }
        guard let _ = tRequest.toLocation else {
            showToastErrorMessage("", message: "kToLocationRequired".localizedString())
            return false
        }
        return true
    }
}
