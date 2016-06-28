//
//  AddCarVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 23/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class AddCarVC: ParentVC {

    @IBOutlet var lblCompanyName: UILabel!
    @IBOutlet var lblInsurance: UILabel!
    @IBOutlet var lblSeatCount: UILabel!
    @IBOutlet var lblProYear: UILabel!
    @IBOutlet var lblColor: UILabel!
    @IBOutlet var txtModel: UITextField!
    @IBOutlet var txtDetail: UITextView!
    @IBOutlet var lblDetailPlaceHolder: UILabel!
    @IBOutlet var btnSeatCounterMinus: UIButton!
    @IBOutlet var btnSeatCounterPlus: UIButton!
    
    var isLoading = false
    var yearPicker: VPickerView!
    var car = Car()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeYearPicker()
        setAccessoryViewForTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        //Add Keybaord observeration
        _defaultCenter.addObserver(self, selector: #selector(AddCarVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        _defaultCenter.addObserver(self, selector: #selector(AddCarVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        _defaultCenter.removeObserver(self)
    }

    func initializeYearPicker() {
        let views = NSBundle.mainBundle().loadNibNamed("VPickerView", owner: nil, options: nil)
        yearPicker = views[0] as! VPickerView
        yearPicker.actionBlock = {[unowned self](action, value, idx) in
            self.lblProYear.text = value
        }
        var years = [String]()
        for year in (1970...2016).reverse() {
            years.append("\(year)")
        }
        yearPicker.Items = years
    }
    
    func setAccessoryViewForTextField()  {
        let customViews = NSBundle.mainBundle().loadNibNamed("CustomViews", owner: nil, options: nil)
        let av = customViews[0] as! VKeyboardAccessoryView
        txtDetail.inputAccessoryView = av
        txtModel.inputAccessoryView = av
        av.actionBlock = {(action) in
            self.txtModel.resignFirstResponder()
            self.txtDetail.resignFirstResponder()
        }

    }
}

//MARK: IBActions
extension AddCarVC {
    @IBAction func carCompanyBtnClicked(sender: UIButton) {
        openCompanyListVC()
    }
    
    @IBAction func carColorBtnClicked(sender: UIButton) {
        openColorListVC()
    }

    @IBAction func insuranceCheckBoxBtnClicked(sender: UIButton) {
        sender.selected = !sender.selected
        car.insurance = sender.selected
    }
    
    @IBAction func seatCounterBtnClicked(sender: UIButton) {
        car.seatCounter.value += sender.tag == 1 ?  -1 :  1
        let counter = car.seatCounter
        if counter.value <= counter.min {
            btnSeatCounterMinus.enabled = false
            car.seatCounter.value = counter.min
        } else if counter.value >= counter.max {
            car.seatCounter.value = counter.max
            btnSeatCounterPlus.enabled = false
        } else {
            btnSeatCounterPlus.enabled = true
            btnSeatCounterMinus.enabled = true
            car.seatCounter.value = counter.value
        }
        
        lblSeatCount.text = "\(car.seatCounter.value)"
    }
    
    @IBAction func yearPickerbtnClicked(sender: UIButton) {
        self.view.addSubview(yearPicker)
        yearPicker.showWithAnnimation()
    }
    
    @IBAction func txtFieldDidChangeText(sender: UITextField) {
        car.details = sender.text
    }
    
}

//MARK: UITextView Delegate
extension AddCarVC: UITextViewDelegate {

    func textViewDidChange(textView: UITextView) {
        if textView.text.characters.isEmpty {
         lblDetailPlaceHolder.hidden = false
        } else {
            lblDetailPlaceHolder.hidden = true
        }
        car.details = textView.text
    }

}

//MARK: Notifications
extension AddCarVC {
    //Keyboard Notifications
    func keyboardWillShow(nf: NSNotification)  {
        if let kbInfo = nf.userInfo {
            let kbFrame = (kbInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kbFrame.size.height, 0)
        }
    }
    
    func keyboardWillHide(nf: NSNotification)  {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
}

//MARK: Others
extension AddCarVC {
    //navigate to select Car Company
    func openCompanyListVC()  {
        let cListVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.CarCompany
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                let company = item.obj as! Company
                self.lblCompanyName.text = company.name
                self.car.company = company
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
    
    func openColorListVC()  {
        let cListVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.Color
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                let color = item.obj as! Color
                self.lblColor.text = color.name
                self.car.color = color
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }

    //MARK: Show DatePicker
    func openDatePicker(type: Int) {
        if !isLoading {
            isLoading = true
            let datepickerVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_DatePickerVC") as! VDatePickerVC
            datepickerVC.datePickerMode = UIDatePickerMode.Date
            
            datepickerVC.completionBlock = {(date) in
                if let dt = date {
                    self.lblProYear.text =  dateFormator.stringFromDate(dt, format: "yyyy")
                }
                self.isLoading = false
            }
            datepickerVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            self.presentViewController(datepickerVC, animated: true, completion: nil)
        }
    }

}