//
//  GDatePicker.swift
//  GreetingCards
//
//  Created by Vikash Kumar on 25/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//
import UIKit

class GDatePicker: ConstrainedView {
    @IBOutlet  var lbl_pickerText: UILabel!
    @IBOutlet  var datePicker: UIDatePicker!
    @IBOutlet  var datePickerBottomSpace: NSLayoutConstraint!
    lazy var completionBlock: (NSDate?)->Void = {_ in}
    weak var showingInView: UIView?
    
    override func awakeFromNib() {
        let frame = CGRect(x: 0, y: 0, width: _screenSize.width, height: _screenSize.height);
        self.frame = frame
        datePickerBottomSpace.constant = -(256 *  _widthRatio)
        super.awakeFromNib()
        self.layoutIfNeeded()
        
    }
    
    //MARK: Setting Min and Max date
    func setMinDate(date: NSDate)  {
        datePicker.minimumDate = date
    }
    
    func setMaxDate(date: NSDate)  {
        datePicker.maximumDate = date
    }
    
    //MARK: Show and Hide action
    func showWithAnnimation(inView: UIView) {
        showingInView = inView
        inView.addSubview(self)
        UIView.animateWithDuration(0.3) { 
            self.datePickerBottomSpace.constant = 0
            self.alpha = 1
            inView.layoutIfNeeded()
        }
    }
    
    func hideWithAnimation() {
        UIView.animateWithDuration(0.3, animations: {
            self.datePickerBottomSpace.constant = -(256 *  _widthRatio)
            self.alpha = 0
            self.showingInView?.layoutIfNeeded()
        }) { (res) in
            self.removeFromSuperview()
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