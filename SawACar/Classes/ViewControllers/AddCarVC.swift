//
//  AddCarVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 23/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

private let extraGrayColor = UIColor.colorWithRGB(r: 103, g: 103, b: 103)
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
    @IBOutlet var btnInsurance: UIButton!
    @IBOutlet var imgVCar: UIImageView!
    
    var completionBlock: (Car)-> Void = {_ in}
    var isLoading = false
    var yearPicker: VPickerView!
    var car = Car()
    var isEditMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeYearPicker()
        setAccessoryViewForTextField()
        setCarInfo()
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
            self.lblProYear.textColor = extraGrayColor
            self.car.productionYear = value

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
    
    func setCarInfo() {
        if isEditMode {
            imgVCar.setImageWithURL(NSURL(string: car.photo)!)
            lblCompanyName.text = car.company?.name
            txtModel.text = car.model
            txtDetail.text = car.details
            btnInsurance.selected = car.insurance
            lblSeatCount.text = car.seatCounter.value.ToString()
            lblColor.text = car.color?.name
            lblProYear.text = car.productionYear
          
            lblCompanyName.textColor = extraGrayColor
            lblColor.textColor = extraGrayColor
            lblSeatCount.textColor = extraGrayColor
            lblProYear.textColor = extraGrayColor
            lblDetailPlaceHolder.hidden = !car.details.isEmpty
        }
    }
}

//MARK: IBActions
extension AddCarVC {
    
    @IBAction func saveBtnClicked(sender: UIButton) {
        let process = validateAddCarProcess()
        if process.isValid {
            isEditMode ? self.updateCarAPICall() : self.addCarAPICall()
        } else {
            showToastMessage("", message: process.message)
        }
    }
    
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
        lblSeatCount.textColor = extraGrayColor
    }
    
    @IBAction func yearPickerbtnClicked(sender: UIButton) {
        self.view.addSubview(yearPicker)
        yearPicker.showWithAnnimation()
    }
    
    @IBAction func txtFieldDidChangeText(sender: UITextField) {
       
        if sender === txtModel {
            car.model = sender.text
        } else if sender === txtDetail {
            car.details = sender.text
        }
    }
    
    @IBAction func carImageBtnClicked(sender: UIButton) {
        showActionForImagePick()
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

//MARK: ImagePicker action for profile image setup
extension AddCarVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Show ActionSheet to Choose image for profile picture
    func showActionForImagePick() {
        self.view.endEditing(true)
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cancelAction  = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let cameraActiton = UIAlertAction(title: "Take a Photo", style: .Default) { (action) in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Choose from Gallery", style: .Default) { (action) in
            self.openGallery()
        }
        sheet.addAction(cameraActiton)
        sheet.addAction(galleryAction)
        sheet.addAction(cancelAction)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    func openCamera()  {
        let iPicker = UIImagePickerController()
        iPicker.delegate = self
        iPicker.sourceType = .Camera
        iPicker.allowsEditing = true
        self.presentViewController(iPicker, animated: true, completion: nil)
    }
    
    
    func openGallery()  {
        let iPicker = UIImagePickerController()
        iPicker.delegate = self
        iPicker.sourceType = .PhotoLibrary
        iPicker.allowsEditing = true
        self.presentViewController(iPicker, animated: true, completion: nil)
        
    }

    //Image Picker delegate method
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imgVCar.image = image
        picker.dismissViewControllerAnimated(true , completion: nil)
    }
}

//MARK: Others
extension AddCarVC {
    //navigate to select Car Company
    func openCompanyListVC()  {
        let cListVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.CarCompany
        if let company = car.company {
            cListVC.preSelectedIDs = [company.Id]
        }
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                let company = item.obj as! Company
                self.lblCompanyName.text = company.name
                self.car.company = company
                self.lblCompanyName.textColor = extraGrayColor
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
    
    func openColorListVC()  {
        let cListVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_ListVC") as! ListViewController
        cListVC.listType = ListType.Color
        if let color = car.color {
            cListVC.preSelectedIDs = [color.Id]
        }

        cListVC.completionBlock = {(items) in
            if let item = items.first {
                let color = item.obj as! Color
                self.lblColor.text = color.name
                self.car.color = color
                self.lblColor.textColor = extraGrayColor
            }
        }
        self.navigationController?.pushViewController(cListVC, animated: true)
    }
    
    func validateAddCarProcess()-> (isValid: Bool, message: String) {
        guard let _ = car.company else {
            return (false, kCarCompanyRequired)
        }
        
        if car.model.isEmpty {
            return (false, kCarModelRequired)
        }
        
        if car.productionYear.isEmpty {
            return (false, kCarProductionYearRequired)
        }
        
        guard let _ = car.color else {
            return (false, kCarColorRequired)
        }
        
        if car.details.isEmpty {
            return (false, kCarDetailRequired)
        }
        
        return (true, "Success")
    }

}

//MARK: API Calls
extension AddCarVC {

    //MARK: Add Car API
    func addCarAPICall() {
        self.showCentralGraySpinner()
        let params = ["UserID" : me.Id,
                      "CompanyID" : car.company!.Id,
                      "Model" : car.model,
                      "ColorID" : car.color!.Id,
                      "Seats" : car.seatCounter.value.ToString(),
                      "Details" : car.details,
                      "ProductionYear" : car.productionYear,
                      "Insurance" : car.insurance,
                      "Photo" : "",
                      "PaletteNumber" : "GJ 1212"]
        
        wsCall.addCar(params as! [String : AnyObject]) { (response, flag) in
            if response.isSuccess {
                let carInfo = response.json!["Object"] as! [String : AnyObject]
                self.car.setInfo(carInfo)
                 self.addCarImageAPICall(self.car.id)
            } else {
                showToastMessage("", message: response.message!)
                self.hideCentralGraySpinner()
            }
        }
    }
    
    func addCarImageAPICall(carid: String) {
        let carImageData = imgVCar.image!.mediumQualityJPEGNSData
        wsCall.updateCarImage(carImageData, carId: carid) { (response, flag) in
            self.hideCentralGraySpinner()
            if response.isSuccess {
              let imageURL = response.json!["Object"] as! String
                self.car.photo = kWSDomainURL + imageURL
                showToastMessage("", message: "Car added succesfully.")
                self.completionBlock(self.car)
                self.parentBackAction(nil)
            } else  {
            }
        }
    }
    
    func updateCarAPICall() {
        self.showCentralGraySpinner()
        let params = ["CarID": car.id,
                      "UserID" : me.Id,
                      "CompanyID" : car.company!.Id,
                      "Model" : car.model,
                      "ColorID" : car.color!.Id,
                      "Seats" : car.seatCounter.value.ToString(),
                      "Details" : car.details,
                      "ProductionYear" : car.productionYear,
                      "Insurance" : car.insurance,
                      "Photo" : "",
                      "PaletteNumber" : "GJ 1212"]
        
        wsCall.updateCar(params as! [String : AnyObject]) { (response, flag) in
            if response.isSuccess {
                let carInfo = response.json!["Object"] as! [String : AnyObject]
                self.car.setInfo(carInfo)
                self.addCarImageAPICall(self.car.id)
            } else {
                self.hideCentralGraySpinner()
            }
        }
    }
}



//    //MARK: Show DatePicker
//    func openDatePicker(type: Int) {
//        if !isLoading {
//            isLoading = true
//            let datepickerVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_DatePickerVC") as! VDatePickerVC
//            datepickerVC.datePickerMode = UIDatePickerMode.Date
//
//            datepickerVC.completionBlock = {(date) in
//                if let dt = date {
//                    let year = dateFormator.stringFromDate(dt, format: "yyyy")
//                    self.lblProYear.text = year
//                }
//                self.isLoading = false
//            }
//            datepickerVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
//            self.presentViewController(datepickerVC, animated: true, completion: nil)
//        }
//    }
