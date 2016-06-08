//
//  UserTypeSelectVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 06/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class UserTypeSelectVC: ParentVC {

    @IBOutlet var btnNeedARide: UIButton!
    @IBOutlet var btnHaveACar : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonsUI()
       
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
    
    func setButtonsUI() {
        btnNeedARide.layer.cornerRadius = btnNeedARide.frame.size.height / 2
        btnNeedARide.clipsToBounds = true
       
        btnHaveACar.layer.cornerRadius = btnHaveACar.frame.size.height / 2
        btnHaveACar.clipsToBounds = true
        btnHaveACar.layer.borderColor = UIColor.lightGrayColor().CGColor
        btnHaveACar.layer.borderWidth = 1
    }

}

//MARK: IBActions
extension UserTypeSelectVC {

    @IBAction func clickedAtINeedRideBtn(sender: UIButton) {
        self.performSegueWithIdentifier("SBSegue_NeedARide", sender: nil)
    }

    @IBAction func clickedAtIHaveCarBtn(sender: UIButton) {
        self.performSegueWithIdentifier("SBSegue_haveACar", sender: nil)
    }
}
