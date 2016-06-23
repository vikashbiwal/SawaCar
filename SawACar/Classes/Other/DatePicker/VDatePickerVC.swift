//
//  GDatePicker.swift
//  GreetingCards
//
//  Created by Vikash Kumar on 25/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//
import UIKit

class VDatePickerVC: ParentVC {
    @IBOutlet  var lbl_pickerText: UILabel!
    @IBOutlet  var datePicker: UIDatePicker!
    @IBOutlet  var datePickerBottomSpace: NSLayoutConstraint!
    
    var minDate: NSDate?
    var maxDate: NSDate?
    var datePickerMode = UIDatePickerMode.Date
    
    lazy var completionBlock: (NSDate?)->Void = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerBottomSpace.constant = -(256 * _widthRatio)
        self.view.alpha = 0
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.datePickerMode = datePickerMode
    }
    override func viewWillAppear(animated: Bool) {
        UIView.animateWithDuration(0.3) {
            self.datePickerBottomSpace.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.2) {
            self.view.alpha = 1
        }
    }
    
    //MARK: Show and Hide action
    func showWithAnnimation() {
        UIView.animateWithDuration(0.3) {
            self.datePickerBottomSpace.constant = 0
            self.view.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    func hideWithAnimation() {
        UIView.animateWithDuration(0.3, animations: {
            self.datePickerBottomSpace.constant = -(256 *  _widthRatio)
            self.view.alpha = 0
            self.view.layoutIfNeeded()
        }) { (res) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //MARK : IBActions
    @IBAction func btnDone(sender: AnyObject) {
        completionBlock(datePicker.date)
        hideWithAnimation()
    }
    
    @IBAction func btnCancel(sender: AnyObject) {
        completionBlock(nil)
        hideWithAnimation()
    }
}