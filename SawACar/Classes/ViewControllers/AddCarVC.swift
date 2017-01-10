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
    @IBOutlet var lblVehicleType: UILabel!
    @IBOutlet var lblInsurance: UILabel!
    @IBOutlet var lblSeatCount: UILabel!
    @IBOutlet var lblProYear: UILabel!
    @IBOutlet var lblColor: UILabel!
    @IBOutlet var txtModel: UITextField!
    @IBOutlet var txtPlateNumber: UITextField!
    @IBOutlet var txtDetail: UITextView!
    @IBOutlet var lblDetailPlaceHolder: UILabel!
    @IBOutlet var btnSeatCounterMinus: UIButton!
    @IBOutlet var btnSeatCounterPlus: UIButton!
    @IBOutlet var btnInsurance: UIButton!
    @IBOutlet var imgVCar: UIImageView!
   
    var completionBlock: (Vehicle)-> Void = {_ in}
    var isLoading = false
    var yearPicker: VPickerView!
    var car = Vehicle()
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

    override func viewWillAppear(_ animated: Bool) {
        //Add Keybaord observeration
        _defaultCenter.addObserver(self, selector: #selector(AddCarVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        _defaultCenter.addObserver(self, selector: #selector(AddCarVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        _defaultCenter.removeObserver(self)
    }

    func initializeYearPicker() {
        let views = Bundle.main.loadNibNamed("VPickerView", owner: nil, options: nil)
        yearPicker = views![0] as! VPickerView
        yearPicker.actionBlock = {[unowned self](action, value, idx) in
            self.lblProYear.text = value
            self.lblProYear.textColor = extraGrayColor
            self.car.productionYear = value

        }
        var years = [String]()
        let str = dateFormator.stringFromDate(Date(), format: "yyyy")
        for year in (1970...str.integerValue!).reversed() {
            years.append("\(year)")
        }
        yearPicker.Items = years
    }
    
    func setAccessoryViewForTextField()  {
        let customViews = Bundle.main.loadNibNamed("CustomViews", owner: nil, options: nil)
        let av = customViews![0] as! VKeyboardAccessoryView
        txtDetail.inputAccessoryView = av
        txtModel.inputAccessoryView = av
        txtPlateNumber.inputAccessoryView = av
        av.actionBlock = {(action) in
            self.txtModel.resignFirstResponder()
            self.txtDetail.resignFirstResponder()
            self.txtPlateNumber.resignFirstResponder()
        }
    }
    
    func setCarInfo() {
        if isEditMode {
            imgVCar.setImageWith(URL(string: car.photo)!)
            lblCompanyName.text = car.company?.name
            txtModel.text = car.model
            txtDetail.text = car.details
            txtPlateNumber.text = car.plateNumber
            
            btnInsurance.isSelected = car.insurance
            lblSeatCount.text = car.seatCounter.value.ToString()
            lblColor.text = car.color?.name
            lblProYear.text = car.productionYear
          
            lblCompanyName.textColor = extraGrayColor
            lblColor.textColor = extraGrayColor
            lblSeatCount.textColor = extraGrayColor
            lblProYear.textColor = extraGrayColor
            lblDetailPlaceHolder.isHidden = !car.details.isEmpty
            
        }
    }
}

//MARK: IBActions
extension AddCarVC {
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        let process = car.validateAddCarProcess()
        if process.isValid {
            isEditMode ? self.updateCarAPICall() : self.addCarAPICall()
        } else {
            showToastErrorMessage("", message: process.message)
        }
    }
    
    @IBAction func carCompanyBtnClicked(_ sender: UIButton) {
        openCompanyListVC()
    }
    
    @IBAction func vehicleTypeBtnClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func carColorBtnClicked(_ sender: UIButton) {
        openColorListVC()
    }

    @IBAction func insuranceCheckBoxBtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        car.insurance = sender.isSelected
    }
    
    @IBAction func seatCounterBtnClicked(_ sender: UIButton) {
        car.seatCounter.value += sender.tag == 1 ?  -1 :  1
        let counter = car.seatCounter
        if counter.value <= counter.min {
            btnSeatCounterMinus.isEnabled = false
            car.seatCounter.value = counter.min
        } else if counter.value >= counter.max {
            car.seatCounter.value = counter.max
            btnSeatCounterPlus.isEnabled = false
        } else {
            btnSeatCounterPlus.isEnabled = true
            btnSeatCounterMinus.isEnabled = true
            car.seatCounter.value = counter.value
        }
        
        lblSeatCount.text = car.seatCounter.value.ToString()
        lblSeatCount.textColor = extraGrayColor
    }
    
    @IBAction func yearPickerbtnClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.view.addSubview(yearPicker)
        yearPicker.showWithAnnimation()
    }
    
    @IBAction func txtFieldDidChangeText(_ sender: UITextField) {
        if sender === txtModel {
            car.model = sender.text!
        } else if sender === txtDetail {
            car.details = sender.text!
        } else if sender === txtPlateNumber {
            car.plateNumber = sender.text!
        }
    }
    
    @IBAction func carImageBtnClicked(_ sender: UIButton) {
        showActionForImagePick()
    }
    
}

//MARK: UITextView Delegate
extension AddCarVC: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.isEmpty {
         lblDetailPlaceHolder.isHidden = false
        } else {
            lblDetailPlaceHolder.isHidden = true
        }
        car.details = textView.text
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        UIView.animate(withDuration: 0.3, animations: { 
            self.tableView.contentOffset = CGPoint(x: 0, y: 200)
        }) 
        return true
    }

}

//MARK: Notifications
extension AddCarVC {
    //Keyboard Notifications
    func keyboardWillShow(_ nf: Notification)  {
        if let kbInfo = nf.userInfo {
            let kbFrame = (kbInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kbFrame.size.height, 0)
        }
    }
    
    func keyboardWillHide(_ nf: Notification)  {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
}

//MARK: ImagePicker action for profile image setup
extension AddCarVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Show ActionSheet to Choose image for profile picture
    func showActionForImagePick() {
        self.view.endEditing(true)
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction  = UIAlertAction(title: "cancel".localizedString(), style: .cancel, handler: nil)
        let cameraActiton = UIAlertAction(title: "take_a_photo".localizedString(), style: .default) { (action) in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "choose_from_gallery".localizedString(), style: .default) { (action) in
            self.openGallery()
        }
        sheet.addAction(cameraActiton)
        sheet.addAction(galleryAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    func openCamera()  {
        let iPicker = UIImagePickerController()
        iPicker.delegate = self
        iPicker.sourceType = .camera
        iPicker.allowsEditing = true
        self.present(iPicker, animated: true, completion: nil)
    }
    
    
    func openGallery()  {
        let iPicker = UIImagePickerController()
        iPicker.delegate = self
        iPicker.sourceType = .photoLibrary
        iPicker.allowsEditing = true
        self.present(iPicker, animated: true, completion: nil)
        
    }

    //Image Picker delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imgVCar.image = image
        picker.dismiss(animated: true , completion: nil)
    }
}

//MARK: Others
extension AddCarVC {
    //navigate to select Car Company
    func openCompanyListVC()  {
        //let cListVC = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_ListVC") as! ListViewController
        let cListVC = VListViewController.loadFromNib()
        cListVC.keyForId = "ID"
        cListVC.keyForTitle = "Name"
        cListVC.apiName = APIName.GetCarCompanies
        
        if let company = car.company {
            cListVC.preSelectedIDs = [company.Id]
        }
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                if let obj = item.obj as? [String : Any] {
                    let company = Company(obj)
                    self.lblCompanyName.text = company.name
                    self.car.company = company
                    self.lblCompanyName.textColor = extraGrayColor
                }
            }
        }
        
        self.present(cListVC, animated: true, completion: nil)
    }
    
    func openColorListVC()  {
        let cListVC = VListViewController.loadFromNib()
        cListVC.keyForId = "ID"
        cListVC.keyForTitle = "Name"
        cListVC.apiName = APIName.GetColors
        if let color = car.color {
            cListVC.preSelectedIDs = [color.Id]
        }

        cListVC.completionBlock = {(items) in
            if let item = items.first {
                if let obj = item.obj as? [String : Any] {
                    let color = Color(obj)
                    self.lblColor.text = color.name
                    self.car.color = color
                    self.lblColor.textColor = extraGrayColor
                }
            }
        }
        self.present(cListVC, animated: true, completion: nil)
    }
    
    func openVehicleTypeListVC()  {
        let cListVC = VListViewController.loadFromNib()
        cListVC.keyForId = "ID"
        cListVC.keyForTitle = "Name"
        cListVC.apiName = APIName.GetCarType
        if let color = car.color {
            cListVC.preSelectedIDs = [color.Id]
        }
        
        cListVC.completionBlock = {(items) in
            if let item = items.first {
                if let obj = item.obj as? [String : Any] {
                    let vehicleType = VehicleType(obj)
                    self.lblVehicleType.text = vehicleType.name
                    self.car.vehicleType = vehicleType
                    self.lblVehicleType.textColor = extraGrayColor
                }
            }
        }
        self.present(cListVC, animated: true, completion: nil)
    }

}

//MARK: API Calls
extension AddCarVC {

    //MARK: Add Car API
    func addCarAPICall() {
        self.showCentralGraySpinner()
        let params = ["VichelCompanyID" : car.company!.Id,
                      "Model" : car.model,
                      "ColorID" : car.color!.Id,
                      "SeatsNumber" : car.seatCounter.value.ToString(),
                      "Details" : car.details,
                      "ProductionYear" : car.productionYear,
                      "Insurance" : car.insurance ? "true" : "false",
                      "PaletteNumber" : car.plateNumber] 
        
        wsCall.addCar(params) { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    let carInfo = json["Object"] as! [String : Any]
                    self.car.setInfo(carInfo)
                    self.addCarImageAPICall(self.car.id)
                }
            } else {
                showToastErrorMessage("", message: response.message)
                self.hideCentralGraySpinner()
            }
        }
    }
    
    func addCarImageAPICall(_ carid: String) {
        let carImageData = imgVCar.image!.mediumQualityJPEGNSData
        wsCall.updateCarImage(carImageData, carId: carid) { (response, flag) in
            self.hideCentralGraySpinner()
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    let imageURL = json["Object"] as! String
                    self.car.photo = kWSDomainURL + imageURL
                    showToastMessage("", message: "Car_Add_Success".localizedString())
                    self.completionBlock(self.car)
                    self.parentBackAction(nil)
                }
            } else  {
            }
        }
    }
    
    func updateCarAPICall() {
        self.showCentralGraySpinner()
        let params = ["CarID" : car.id,
                      "VichelCompanyID" : car.company!.Id,
                      "Model" : car.model,
                      "ColorID" : car.color!.Id,
                      "SeatsNumber" : car.seatCounter.value.ToString(),
                      "Details" : car.details,
                      "ProductionYear" : car.productionYear,
                      "Insurance" : car.insurance ? "true" : "false",
                      "PaletteNumber" : car.plateNumber]
        
        wsCall.updateCar(params) { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    let carInfo = json["Object"] as! [String : Any]
                    self.car.setInfo(carInfo)
                    self.addCarImageAPICall(self.car.id)
                }
            } else {
                self.hideCentralGraySpinner()
            }
        }
    }
}


