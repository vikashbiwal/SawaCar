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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRoundCircleUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    func setRoundCircleUI()  {
        inputView1.layer.borderWidth = 1.0
        inputView1.layer.borderColor = UIColor.whiteColor().CGColor
        inputView1.layer.cornerRadius = 3.0
        inputView1.clipsToBounds  = true
        
        inputView2.layer.borderWidth = 1.0
        inputView2.layer.borderColor = UIColor.whiteColor().CGColor
        inputView2.layer.cornerRadius = 3.0
        inputView2.clipsToBounds  = true
       
        roundedView.layer.cornerRadius = (260 * _widthRatio) / 2
        roundedView.clipsToBounds = true
    }
}

//MARK: IBActions
extension OfferARideVC {
    @IBAction func fromBtnDidClicked(sender: UIButton) {
        goForPickLocation(.From)
    }
    
    @IBAction func toBtnDidClicked(sender: UIButton) {
        goForPickLocation(.To)
    }
}

extension OfferARideVC {
    func goForPickLocation(type: LocationSelectionForType)  {
        let loctionPicker = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_MapViewcontroller") as! MapViewController
        loctionPicker.completionBlcok = {(place) in
            if let place = place {
                if type == .From {
                    self.txtFrom.text = place.address
                } else {
                    self.txtTo.text = place.address
                }
            }
        }
        self.presentViewController(loctionPicker, animated: true, completion: nil)
    }
}
