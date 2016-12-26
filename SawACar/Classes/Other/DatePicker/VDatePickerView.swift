//
//  VDatePickerView.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 25/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

//
enum DatePickerForType {
    case departureDate, departureTime
    case regularTravelDate, regularTravelTime
    case roundTravelDate, roundTravelTime
    case date
}

class VDatePickerView: ConstrainedView {

    //MARK: DatePicker Outlets
    @IBOutlet var datePickerBottomConstraint : NSLayoutConstraint!
    @IBOutlet var datePicker: UIDatePicker!

    var dateSelectionBlock : (Date, DatePickerForType)-> Void = {_ in} //block call when user select date from datepicker
    var dateMode: UIDatePickerMode = UIDatePickerMode.date
    var minDate: Date?
    var maxDate: Date?
    var currentDate: Date?
    
    var datePickerForType: DatePickerForType = .date
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: _screenSize.height, width: _screenSize.width, height: _screenSize.height)
        self.layoutIfNeeded()
    }

    //Show datepicker
    func show() {
        datePicker.datePickerMode = dateMode
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        if let currentDate = currentDate {
            datePicker.date = currentDate
        }
        self.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.datePickerBottomConstraint.constant = -240 * _widthRatio
        
        var fr = self.frame
        fr.origin.y = 0
        self.frame = fr
        self.layoutIfNeeded()
       
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.datePickerBottomConstraint.constant = 10 * _widthRatio
            self.layoutIfNeeded()
        }, completion: { (res) in
        }) 
    }
    
    //hideDate Picker
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.datePickerBottomConstraint.constant = -240 * _widthRatio
            self.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.layoutIfNeeded()
        }, completion: { (res) in
            var fr = self.frame
            fr.origin.y = _screenSize.height
            self.frame = fr
            self.layoutIfNeeded()
        }) 
    }
    
    //datePicker button actions
    @IBAction func datePickerDoneBtnClicked(_ sender: UIButton) {
        dateSelectionBlock(datePicker.date, datePickerForType)
        self.hide()
    }
    
    @IBAction func datePickerCancelBtnClicked(_ sender: UIButton) {
        self.hide()
    }
    

}
