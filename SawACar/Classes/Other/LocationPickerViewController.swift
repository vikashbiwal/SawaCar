//
//  LocationPickerViewController.swift
//  LoactionPicker
//
//  Created by Yudiz Solutions Pvt.Ltd. on 08/02/16.
//  Copyright © 2016 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

import UIKit

class FullAddress: Address {
    var lat: Double = 0.0
    var long: Double = 0.0
    var address: String = ""
}

class Address {
    var name: String!
    var refCode: String!
   
    func initWithData(data: NSDictionary!){
        name = data.getStringValue("description")
        refCode = data.getStringValue("reference")
    }
}

class addressCell: UITableViewCell {
    @IBOutlet var lblName: UILabel!
    override func awakeFromNib() {

    }
}

enum LoadingType:Int{
    case NoneType = 0
    case Loading
    case NoResult
    case NetWorkErr
}

class LocationPickerViewController: ParentVC,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    //MARK: - IBOutlet
    @IBOutlet var tfSerach: UITextField!
    @IBOutlet var tblView: UITableView!
    
    //MARK: - Action Method
    @IBAction func cancelBtnTap(sender: UIButton){
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //MARK: - Variable
    var isLoading: Bool = false
    var isNoResult: Bool = false
    var sessionDataTask: NSURLSessionDataTask!
    var arrData :[Address] = []
    var loadType : LoadingType!
    var selectedAddress = FullAddress()
    var selectionBlock: ((add: FullAddress) -> Void)!
    var locationOperation : LocationOperation?
    var operationQueue: NSOperationQueue!
    
    //MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
         operationQueue = NSOperationQueue()
        UITextField.appearance().tintColor = UIColor.whiteColor()
        loadType = .NoneType
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.tableFooterView = UIView()
        tfSerach.addTarget(self, action: #selector(LocationPickerViewController.searchTextDidChange(_:)), forControlEvents: .EditingChanged)
        
        
        let imgView = UIImageView(frame: CGRectMake(0, 0, 30, tfSerach.frame.size.height))
        imgView.image = UIImage(named: "searchIcon.png")
        imgView.contentMode = .Center
        tfSerach.leftView = imgView
        tfSerach.leftViewMode = .Always
        
        let btnClear = UIButton(frame: CGRectMake(0, 0, 30, tfSerach.frame.size.height))
        btnClear.setImage(UIImage(named: "cancelIcon.png"), forState: .Normal)
        btnClear.addTarget(self, action: #selector(LocationPickerViewController.textFieldClear(_:)), forControlEvents: .TouchUpInside)
        tfSerach.rightView = btnClear
        tfSerach.rightViewMode = .Always
        
        
        let attrDic : [String : AnyObject] = [NSFontAttributeName : UIFont(name: "Avenir", size: 15)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()]
        let attriStr = NSAttributedString(string: "Search Text",attributes:attrDic)
        tfSerach.attributedPlaceholder = attriStr
        tfSerach.font = UIFont(name: "Avenir", size: 15)
        tfSerach.frame = CGRectMake(50, 0, 320, 320)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tfSerach.becomeFirstResponder()
    }
    override func viewWillDisappear(animated: Bool) {
        UITextField.appearance().tintColor = UIColor.blueColor()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    //MARK:- search and textfield
    func textFieldClear(sender: UIButton){
        tfSerach.text = ""
        self.searchTextDidChange(tfSerach)
    }
    
    
    
    func searchTextDidChange(textField: UITextField){
        if sessionDataTask != nil{
            sessionDataTask.cancel()
        }
        locationOperation?.cancel()

        self.arrData = []
        loadType = .Loading
        self.tblView.reloadData()
        
        let str = textField.text?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.letterCharacterSet())
        if str!.characters.count > 0{
            googelApiCallForSearchPlace(str!)
        }else{
            self.loadType = .NoneType
            self.arrData = [] 
            self.tblView.reloadData()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        tfSerach.resignFirstResponder()
        return true
    }
    
    
    //MARK: - Tableview datasource and delegate
    func numberOfRowsInSection(section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        if indexPath.row == 0{
            cell.selectionStyle = .None
            if loadType == LoadingType.Loading{
                cell.textLabel?.text = "Loading..."
            }else if loadType == LoadingType.NoResult{
                cell.textLabel?.text = "No result found"
            }else{
                cell.textLabel?.text = "Please try again"
            }
        }else{
            cell.selectionStyle = .Default
            cell.textLabel?.text = arrData[indexPath.row - 1].name
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "Avenir-Book", size: 15.0)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            if loadType == LoadingType.NoneType {
                return 0.0
            }else{
                return 44.0
            }
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 0.0
        }else{
            return 44.0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row != 0 {
            getLatLongWithPlaceRefCode(arrData[indexPath.row - 1].refCode)
            tblView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCellWithIdentifier("headerCell") as! addressCell
        view.lblName.text = "Search result"
        return view
    }
    
    //MARK: Google api call.  Developer : Vikash Kumar
    func googelApiCallForSearchPlace(name: String) {
        let path = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(name)&sensor=false&key=\(googleKey)"
        locationOperation = LocationOperation(strUrl: path) { (response) in
            if let json = response {
                self.arrData = []
                if json["status"] as! String == "OK" {
                    
                    if let data = json["predictions"] as? NSDictionary{
                        let add = Address()
                        add.initWithData(data)
                        self.arrData.append(add)
                    }else if let dataArr = json["predictions"] as? NSArray{
                        for data in dataArr{
                            let add = Address()
                            add.initWithData(data as! NSDictionary)
                            self.arrData.append(add)
                        }
                    }
                    self.loadType = .NoneType
                }else if json["status"] as! String == "ZERO_RESULTS"{
                    self.loadType = .NoResult
                }
                
            }else{
                //if flag != -999{
                self.loadType = .NetWorkErr
                //}
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tblView.reloadData()
            });
            
        }
        operationQueue.addOperation(locationOperation!)
    }
    
    func getLatLongWithPlaceRefCode(refCode: String) {
        let path = "https://maps.googleapis.com/maps/api/place/details/json?reference=\(refCode)&sensor=false&key=\(googleKey)"
        locationOperation = LocationOperation(strUrl: path) { (response) in
            if let json = response {
                if json["status"] as! String == "OK" {
                    if let data = json["result"] as? NSDictionary {
                        self.selectedAddress.address = data.getStringValue("formatted_address")
                        if let address_components = data["address_components"] as? NSArray {
                            if address_components.count > 0 {
                                self.selectedAddress.name = (address_components[0] as! NSDictionary )["short_name"] as! String
                            }
                        }
                        if let cordinate = data["geometry"] as? NSDictionary{
                            if let loc = cordinate["location"] as? NSDictionary{
                                self.selectedAddress.lat =  loc.getDoubleValue("lat")
                                self.selectedAddress.long = loc.getDoubleValue("lng")
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.selectionBlock(add: self.selectedAddress)
                                    self.dismissViewControllerAnimated(false, completion: nil)
                                });
                                
                            }
                        }
                    } else if let data = json["result"] as? NSArray {
                        self.selectedAddress.address = data[0].getStringValue("formatted_address")
                        if let address_components = data[0]["address_components"] as? NSArray {
                            if address_components.count > 0 {
                                self.selectedAddress.name = (address_components[0] as! NSDictionary )["short_name"] as! String
                            }
                        }

                        if let cordinate = data[0]["geometry"] as? NSDictionary {
                            if let loc = cordinate["location"] as? NSDictionary {
                                self.selectedAddress.lat =  loc.getDoubleValue("lat")
                                self.selectedAddress.long = loc.getDoubleValue("lng")
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.selectionBlock(add: self.selectedAddress)
                                    self.dismissViewControllerAnimated(false, completion: nil)
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


extension NSDictionary{
    func getDoubleValue(key: String) -> Double{
        if let any: AnyObject = self[key]{
            if let number = any as? NSNumber{
                return number.doubleValue
            }else if let str = any as? NSString{
                return str.doubleValue
            }
        }
        return 0
    }
    
    func getStringValue(key: String) -> String{
        if let any: AnyObject = self[key]{
            if let number = any as? NSNumber{
                return number.stringValue
            }else if let str = any as? String{
                return str
            }
        }
        return ""
    }
}

//Operation for call location related API : 
//Added by vikash
class LocationOperation: NSOperation {
    var url : NSURL!
    var block: ((NSDictionary) -> Void)?
    
    init(strUrl: String, block:(NSDictionary?) -> Void) {
     self.url = NSURL(string: strUrl)
        self.block = block
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        let data = NSData(contentsOfURL: url)
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
        if self.cancelled {
            return
        }
        block?(json as! NSDictionary)
    }
}
