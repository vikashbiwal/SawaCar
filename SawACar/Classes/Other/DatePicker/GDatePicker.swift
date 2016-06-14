//
//  GDatePicker.swift
//  GreetingCards
//
//  Created by Vikash Kumar on 25/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//
import UIKit

class GDatePicker: UIView {
    @IBOutlet weak var lbl_pickerText: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    var completionBlock: (NSDate?)->Void = {_ in}
    
    override func awakeFromNib() {
        let frame = CGRect(x: 0, y: 0, width: _screenSize.width, height: _screenSize.height);
        self.frame = frame
    }
    // MARK : ok , Done BUtton Methods
    @IBAction func btnDone(sender: AnyObject) {
        completionBlock(datePicker.date)
        self.removeFromSuperview()
    }
    @IBAction func btnCancel(sender: AnyObject) {
        completionBlock(nil)
        self.removeFromSuperview()
    }
}