//
//  LocationPickerViewController.swift
//  LoactionPicker
//
//  Created by Yudiz Solutions Pvt.Ltd. on 08/02/16.
//  Copyright © 2016 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

import UIKit

class GLocation: Address {
    var id: Int = 0
    var lat: Double = 0.0
    var long: Double = 0.0
    var address: String = ""
    var countryName: String = ""
    var countryCode: String = ""

    override init() {
        //
    }
    
    init(_ info : [String : Any]) {
        super.init()
        id = RConverter.integer(info["LocationID"])
        lat = RConverter.double(info["Latitude"])
        long = RConverter.double(info["Longitude"])
        name = RConverter.string(info["Address"])
        address = name
    }
    
    //used for create location from google route api. 
    init(fromGoogleRoute info : [String : Any]) {
        lat = RConverter.double(info["lat"])
        long = RConverter.double(info["lng"])
    }
}

class Address {
    var name: String!
    var refCode: String!

    init () {
    
    }
    
    func initWithData(_ data: [String : Any]){
        name = data["description"] as? String
        refCode = data["reference"] as? String
    }
}

class addressCell: UITableViewCell {
    @IBOutlet var lblName: UILabel!
    override func awakeFromNib() {

    }
}

enum LoadingType:Int{
    case noneType = 0
    case loading
    case noResult
    case netWorkErr
}

class LocationPickerViewController: ParentVC, UITableViewDelegate, UITableViewDataSource {

    //MARK: - IBOutlet
    @IBOutlet var tfSerach: UITextField!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblPlaceHolder: UILabel!
    
    //MARK: - Action Method
    @IBAction func cancelBtnTap(_ sender: UIButton){
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: - Variable
    var isLoading: Bool = false
    var isNoResult: Bool = false
    var sessionDataTask: URLSessionDataTask!
    var arrData :[Address] = []
    var loadType : LoadingType!
    var selectedAddress = GLocation()
    var selectionBlock: ((_ add: GLocation) -> Void)!
    var locationOperation : VPOperation?
    var operationQueue: OperationQueue!
    
    //MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
         operationQueue = OperationQueue()
        UITextField.appearance().tintColor = UIColor.white
        loadType = .noneType
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.tableFooterView = UIView()
        tfSerach.addTarget(self, action: #selector(LocationPickerViewController.searchTextDidChange(_:)), for: .editingChanged)
        
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: tfSerach.frame.size.height))
        imgView.image = UIImage(named: "searchIcon.png")
        imgView.contentMode = .center
        tfSerach.leftView = imgView
        //tfSerach.leftViewMode = .Always
        
        let btnClear = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: tfSerach.frame.size.height))
        btnClear.setImage(UIImage(named: "cancelIcon.png"), for: UIControlState())
        btnClear.addTarget(self, action: #selector(LocationPickerViewController.textFieldClear(_:)), for: .touchUpInside)
        tfSerach.rightView = btnClear
        tfSerach.rightViewMode = .always
        
        
        _ = [NSFontAttributeName : UIFont(name: "Avenir", size: 15)!,
            NSForegroundColorAttributeName : UIColor.white]
        //let attriStr = NSAttributedString(string: "Search Address",attributes:attrDic)
        //tfSerach.attributedPlaceholder = attriStr
        tfSerach.font = UIFont(name: "Avenir", size: 15)
        tfSerach.frame = CGRect(x: 50, y: 0, width: 320, height: 320)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tfSerach.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        UITextField.appearance().tintColor = UIColor.blue
       _defaultCenter.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    //MARK:- search and textfield
    func textFieldClear(_ sender: UIButton){
        tfSerach.text = ""
        self.searchTextDidChange(tfSerach)
    }
    
    func searchTextDidChange(_ textField: UITextField){
        if sessionDataTask != nil{
            sessionDataTask.cancel()
        }
        locationOperation?.cancel()

        self.arrData = []
        loadType = .loading
        self.tblView.reloadData()
        
        let str = textField.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.letters)
        if str!.characters.count > 0{
            googelApiCallForSearchPlace(str!)
        }else{
            self.loadType = .noneType
            self.arrData = [] 
            self.tblView.reloadData()
        }
    }
    
    
    //MARK: - Tableview datasource and delegate
    func numberOfRowsInSection(_ section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if indexPath.row == 0{
            cell.selectionStyle = .none
            if loadType == LoadingType.loading{
                cell.textLabel?.text = "Loading..."
            }else if loadType == LoadingType.noResult{
                cell.textLabel?.text = "No result found"
            }else{
                cell.textLabel?.text = "Please try again"
            }
        }else{
            cell.selectionStyle = .default
            cell.textLabel?.text = arrData[indexPath.row - 1].name
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "Avenir-Book", size: 15.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            if loadType == LoadingType.noneType {
                return 0.0
            }else{
                return 44.0
            }
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 0.0
        }else{
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            getLatLongWithPlaceRefCode(arrData[indexPath.row - 1].refCode)
            tblView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! addressCell
        view.lblName.text = "Search result"
        return view
    }
    
    //MARK: Google api call.  Developer : Vikash Kumar
    func googelApiCallForSearchPlace(_ name: String) {
        let path = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(name)&sensor=false&key=\(googleKey)"
        locationOperation = VPOperation(strUrl: path) { (response) in
            if let json = response {
                self.arrData = []
                if json["status"] as! String == "OK" {
                    
                    if let data = json["predictions"] as? [String : Any]{
                        let add = Address()
                        add.initWithData(data)
                        print(data)
                        self.arrData.append(add)
                    } else if let dataArr = json["predictions"] as? [[String : Any]] {
                        for data in dataArr{
                            let add = Address()
                            add.initWithData(data)
                            self.arrData.append(add)
                        }
                        print(dataArr)
                    }
                    self.loadType = .noneType
                }else if json["status"] as! String == "ZERO_RESULTS"{
                    self.loadType = .noResult
                }
                
            }else{
                //if flag != -999{
                self.loadType = .netWorkErr
                //}
            }
            DispatchQueue.main.async(execute: {
                self.tblView.reloadData()
            });
            
        }
        operationQueue.addOperation(locationOperation!)
    }
    
    func getLatLongWithPlaceRefCode(_ refCode: String) {
        let path = "https://maps.googleapis.com/maps/api/place/details/json?reference=\(refCode)&sensor=false&key=\(googleKey)&language=en"
        locationOperation = VPOperation(strUrl: path) { (response) in
            if let json = response {
                print("location Info :: \(response)")
                if json["status"] as! String == "OK" {
                    if let data = json["result"] as? [String : Any] {
                        self.selectedAddress.address = data["formatted_address"] as! String
                        if let address_components = data["address_components"] as? [[String : Any]] {
                            if address_components.count > 0 {
                                self.selectedAddress.name = (address_components[0] )["short_name"] as! String
                            }
                            for comp in address_components {
                                if let types = comp["types"] as? [String] {
                                    if types.contains("country") {
                                        self.selectedAddress.countryName = comp["long_name"] as! String
                                        self.selectedAddress.countryCode = comp["short_name"] as! String
                                    }
                                }
                            }
                        }
                        if let cordinate = data["geometry"] as? [String : Any] {
                            if let loc = cordinate["location"] as? [String : Any] {
                                self.selectedAddress.lat =  Double(loc["lat"] as! String)!
                                self.selectedAddress.long = Double(loc["lng"] as! String)!
                                
                                DispatchQueue.main.async(execute: {
                                    self.selectionBlock(self.selectedAddress)
                                    self.dismiss(animated: false, completion: nil)
                                });
                                
                            }
                        }
                    } else if let data = json["result"] as? [[String : Any]] {
                        self.selectedAddress.address = (data[0] as [String : Any])["formatted_address"] as! String
                        if let address_components = data[0]["address_components"] as?  [[String : Any]] {
                            if address_components.count > 0 {
                                self.selectedAddress.name = (address_components[0] )["short_name"] as! String
                            }
                            for comp in address_components {
                                if let types = comp["types"] as? [String] {
                                    if types.contains("country") {
                                        self.selectedAddress.countryName = comp["long_name"] as! String
                                        self.selectedAddress.countryCode = comp["short_name"] as! String
                                    }
                                }
                            }

                        }

                        if let cordinate = data[0]["geometry"] as? [String : Any] {
                            if let loc = cordinate["location"] as? [String : Any] {
                                self.selectedAddress.lat =  Double(loc["lat"] as! String)!
                                self.selectedAddress.long = Double(loc["lng"] as! String)!
                                
                                DispatchQueue.main.async(execute: {
                                    self.selectionBlock(self.selectedAddress)
                                    self.dismiss(animated: false, completion: nil)
                                });
                            }
                        }
                    }
                }
                
            }
        }
        operationQueue.addOperation(locationOperation!)
        
    }
}



