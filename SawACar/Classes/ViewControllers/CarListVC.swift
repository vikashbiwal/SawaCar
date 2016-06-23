//
//  CarListVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 23/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class CarListVC: ParentVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addCarBtnClicked(sender: UIButton) {
        self.performSegueWithIdentifier("SBSegue_ToAddCar", sender: nil)
    }
}
