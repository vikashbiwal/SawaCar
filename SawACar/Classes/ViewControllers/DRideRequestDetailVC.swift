//
//  DRideRequestDetailVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 11/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import GoogleMaps

class DRideRequestDetailVC: ParentVC {

    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var txtComment: UITextView!
    @IBOutlet var lblCommentPlaceholder: UILabel!
    
    @IBOutlet var gMapView: GMSMapView!
    
    @IBOutlet var mapViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var chatBoxBottomConstraint: NSLayoutConstraint!
    @IBOutlet var chatTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var btnEditTrailingConstraint: NSLayoutConstraint!
    
    var travelRequest: TravelRequest!
    
    var tableViewDragging = false
    let kSectionForLocation = 0
    let kSectionForOffers = 1
    let kSectionForComments = 2
    let sections = [2, 1, 1]//number of rows in section
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        self.getTravelRequestDetailAPICall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        addObservations()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        _defaultCenter.removeObserver(self)
    }

    func prepareUI() {
        tableView.contentInset = UIEdgeInsets(top: 125 * _widthRatio, left: 0, bottom: 50, right: 0)
        self.lblTitle.text = "Request " + travelRequest.number
        btnEditTrailingConstraint.constant = travelRequest.passanger.id == me.Id ? 0 : -55
        self.setMarkerAndPathOnMap()
    }
    
    //Reset comment box UI
    func resetCommentBox(onMessageSent: Bool = false) {
        let commentText = txtComment.text.trimmedString()
        if onMessageSent || commentText.isEmpty  {
            chatTextViewHeightConstraint.constant = 35
            txtComment.text = ""
            lblCommentPlaceholder.hidden = false
        }
    }
}

//MARK: Notification setup and selectors
extension DRideRequestDetailVC {
    
    func addObservations() {
        //Add Keybaord observeration
        _defaultCenter.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        _defaultCenter.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Keyboard Notifications
    func keyboardWillShow(nf: NSNotification)  {
        let userinfo = nf.userInfo!
        if let keyboarFrame = (userinfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:keyboarFrame.size.height , right: 0)
            chatBoxBottomConstraint.constant = keyboarFrame.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(nf: NSNotification)  {
        //Reset comment textview
        chatBoxBottomConstraint.constant = 0
        self.resetCommentBox()
        self.view.layoutIfNeeded()
    }
}

//MARK: IBActions
extension DRideRequestDetailVC {
    
    //Add/Cancel Offer button action
    //This action will show a window to add an offer
    @IBAction func addOfferBtnClicked(sendeer: UIButton) {
        self.showAddOfferView()
    }
    
    //Accept offer button action
    @IBAction func acceptOfferBtnClicked(sender: UIButton) {
        let offer = travelRequest.offers[sender.tag]
        offer.acceptOffer(travelRequest.id) { (response, flag) in
            //TODO
        }
    }
    
    //Reject offer button action
    @IBAction func rejectOfferBtnClicked(sender: UIButton) {
        let offer = travelRequest.offers[sender.tag]
        offer.rejectOffer(travelRequest.id) { (response, flag) in
            //TODO
        }
    }

    //Action for calling to passanger
    @IBAction func callBtnClicked(sender: UIButton) {
        if !travelRequest.passanger.mobileNumber.isEmpty {
            let mobileNumber = travelRequest.passanger.mobileNumber
            if let url = NSURL(string: "tel://\(mobileNumber)") {
                UIApplication.sharedApplication().canOpenURL(url)
            }
        }
    }
    
    //This action navigate the driver at chat screen for chating with passanger
    @IBAction func chatBtnClicked(sender: UIButton) {
        //TODO
    }
    
    //Edit request button clicked
    @IBAction func editTravelBtnClicked(sender: UIButton) {//navigate to request a ride screen for edit the request.
        let requestRideVC = _driverStoryboard.instantiateViewControllerWithIdentifier("SBID_RequestARideVC") as! RequestARideStep2VC
        requestRideVC.tRequest = travelRequest
        requestRideVC.isEditRequestMode = true
        self.navigationController?.pushViewController(requestRideVC, animated: true)
    }
    
    //Comment send button clicked
    @IBAction func sendCommentBtnClicked(sender: UIButton) {
      //TODO - sent message api call
        self.resetCommentBox(true)
        txtComment.resignFirstResponder()
    }
}

//MARK: TextViewDelegate functions
extension DRideRequestDetailVC : UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        let text = textView.text
        lblCommentPlaceholder.hidden = !text.isEmpty
        let contentHieght = textView.contentSize.height
        chatTextViewHeightConstraint.constant =  contentHieght > 100  ? 100 : contentHieght
    }
    
}

// MARK: TableView Datasource and Delegate
extension DRideRequestDetailVC : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section]
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == kSectionForLocation  {
            return nil
            
        } else if section == kSectionForOffers {
            if  me.userMode == .Driver {
                return nil
                
            } else {//.Passanger
                let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TVGenericeCell
                let offersCount = travelRequest.offers.count
                cell.lblTitle.text = offersCount.ToString() + " " +  (offersCount > 1 ? "Offers" : "Offer").localizedString()
                return cell.contentView
            }
            
        } else { //section == kSectionForComments
            let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TVGenericeCell
            cell.lblTitle.text = "Comments".localizedString()
            return cell.contentView
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == kSectionForLocation {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("RideLocationInfoCell") as! TVRideRequestLocationCell
                cell.SetLocationInfo(travelRequest)
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("RidePriceInfoCell") as! TVGenericeCell
                cell.lblTitle.text = travelRequest.currency!.symbol + " " + travelRequest.suggestedPrice.ToString()
                return cell
                
            }
            
        } else if indexPath.section == kSectionForOffers {
            if me.userMode == .Driver {
                let cell = tableView.dequeueReusableCellWithIdentifier("offerInfoCell") as! TravelRequestOfferInfoCell
                let offersCount = travelRequest.offers.count
                cell.lblTitle.text = offersCount.ToString() + " " +  (offersCount > 1 ? "Offers" : "Offer").localizedString()
                cell.offers = travelRequest.offers
                cell.travelRequest = travelRequest
                cell.tableview.reloadData()
                let titleText = offerOfDriverIsExist(me.Id) ? "CancelYourOffer".localizedString() : "AddYourOffer".localizedString()
                cell.btnAddOffer.setTitle(titleText, forState: .Normal)
                cell.noOffersView.hidden = !travelRequest.offers.isEmpty
                return cell
                
            } else {//offerCellForPassanger
                let cell = tableView.dequeueReusableCellWithIdentifier("offerCellForPassanger") as! TravelRequestOfferInfoCell
                cell.offers = travelRequest.offers
                cell.travelRequest = travelRequest
                cell.tableview.reloadData()
                cell.noOffersView.hidden = !travelRequest.offers.isEmpty
                return cell
            }
            
        } else { //Section for Comments
            let cell = tableView.dequeueReusableCellWithIdentifier("commentContainerCell") as! CommnetsContainerCell
            cell.comments = [Comment(), Comment()]
            cell.tableView.reloadData()

            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == kSectionForOffers) && (me.userMode == .Passenger) {
           return 30
        } else if section == kSectionForComments {
            return 30
        } else {
            return CGFloat.min
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == kSectionForLocation {
            if indexPath.row == 0 {
                return 150 * _widthRatio
            } else {
                return 25 * _widthRatio
            }
        } else if indexPath.section == kSectionForOffers {
            return me.userMode == .Driver ?  250 * _widthRatio : 150 * _widthRatio
            
        } else if indexPath.section == kSectionForComments {
            return 130 * _widthRatio
            
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if tableViewDragging {
            let offset = scrollView.contentOffset
            mapViewHeightConstraint.constant = -offset.y
            //self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        tableViewDragging = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        tableViewDragging = false
    }
    
}

//MARK: others important stuff
extension DRideRequestDetailVC {
    
    //Func to show add offer popup view screen.
    func showAddOfferView() {
        let alert = UIAlertController(title: "AddYourOffer".localizedString(), message: nil, preferredStyle: .Alert)
        
        //Add a textfield for price
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Price".localizedString() + " (\(self.travelRequest.currency!.code))" //Currency code should be replace with request's currency code.
            textField.keyboardType  = UIKeyboardType.NumberPad
        }
        
        //Add a textfield for date
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Date".localizedString()
            //add datepicker as inputview for the textfield
            let datePicker = AlertTextDatePicker()
            datePicker.textfild = textField
            datePicker.minimumDate = NSDate()
            datePicker.datePickerMode = .Date
            textField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(self.datePickerDidChangeDate(_:)), forControlEvents: .ValueChanged)
        }

        let addAction = UIAlertAction(title: "Add".localizedString(), style: .Destructive) { (action) in
            let price = alert.textFields![0].text!
            let date  = alert.textFields![1].text!
            if !price.isEmpty && !date.isEmpty {
                self.travelRequest.addOffer(self.travelRequest.id, price: price, date: date, block: { (response, flag) in
                    
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localizedString(), style: .Default, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //datepicker's value change event.
    func datePickerDidChangeDate(sender: UIDatePicker) {
        if let dp = sender as? AlertTextDatePicker {
            let dateString = dateFormator.stringFromDate(dp.date, format: "dd/MM/yyyy")
            dp.textfild?.text = dateString
        }
    }
    
    //Func for checking that a user has added an offer on the request
    func offerOfDriverIsExist(driverId: String)-> Bool {
        let result =   travelRequest.offers.filter { (offer) -> Bool in
            return offer.userID == driverId
        }
        return !result.isEmpty
    }
    
    
    //MARK: MapView - Marker pin and path line setup.
    func setMarkerAndPathOnMap() {
        let cameraPositionCoordinates = CLLocationCoordinate2D(latitude: travelRequest.fromLocation!.lat, longitude: travelRequest.fromLocation!.long)
        let cameraPosition = GMSCameraPosition.cameraWithTarget(cameraPositionCoordinates, zoom: 8)
        gMapView.animateToCameraPosition(cameraPosition)
        
        let path = GMSMutablePath()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(travelRequest.fromLocation.lat, travelRequest.fromLocation.long)
        marker.groundAnchor = CGPointMake(0.5, 0.5)
        marker.title = travelRequest.fromLocation.name
        marker.map = gMapView
        path.addCoordinate(CLLocationCoordinate2DMake(travelRequest.fromLocation.lat, travelRequest.fromLocation.long))
        
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2DMake(travelRequest.toLocation.lat, travelRequest.toLocation.long)
        marker2.groundAnchor = CGPointMake(0.5, 0.5)
        marker2.title = travelRequest.toLocation.name
        marker2.map = gMapView
        path.addCoordinate(CLLocationCoordinate2DMake(travelRequest.toLocation.lat, travelRequest.toLocation.long))
        
        
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 2.0
        rectangle.strokeColor = UIColor.greenColor()
        rectangle.map = gMapView
    }
    

 }

//MARK: API Calls
extension DRideRequestDetailVC {
    
    func getTravelRequestDetailAPICall() {
        TravelRequest.getTravelRequestDetailAPICall(travelRequest.id) { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    if let trObject = json["Object"] as? [String : AnyObject] {
                        self.travelRequest.reset(withInfo: trObject)
                        //self.travelRequest = TravelRequest(trObject)
                        self.tableView.reloadData()
                    }
                }
            } else {
                
            }
        }
    }
    
}

//MARK: ==========================Tableview cells used for travel request detail============================
//MARK: TVRideRequestLocationCell - location infomation cell
class TVRideRequestLocationCell : TVGenericeCell {
   
    @IBOutlet var lblLocationFrom : UILabel!
    @IBOutlet var lblLocatonTo : UILabel!
    @IBOutlet var lblRideDate : UILabel!
    @IBOutlet var lblRideTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //set location info for travel request
    func SetLocationInfo(travelRequest: TravelRequest) {
        lblLocationFrom.text = travelRequest.fromLocation.address
        lblLocatonTo.text = travelRequest.toLocation.address
        lblRideDate.text = dateFormator.stringFromDate(travelRequest.departurDate()!, format: "MMM dd, yyyy")
        lblRideTime.text = dateFormator.dateString(travelRequest.departureTime, fromFomat: "HH:mm:ss", toFromat: "hh:mm a")
    }
    
}

//MARK: TravelRequestOfferInfoCell -  offer information cell
class TravelRequestOfferInfoCell: TVGenericeCell, UITableViewDataSource, UITableViewDelegate {
   
    @IBOutlet var tableview: UITableView!
    @IBOutlet var btnAddOffer: UIButton!
    @IBOutlet var noOffersView: UIView!
    
    var offers: [TravelRequestOffer] = []
    var travelRequest: TravelRequest!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableview.tableHeaderView = UIView()
    }

    //Offer sender list tableview delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return me.userMode == .Passenger ? 75 * _widthRatio : 50 * _widthRatio
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("offerCell") as! OfferCell
        let offer = offers[indexPath.row]
        cell.lblTitle.text = offer.userName
        cell.lblSubTitle.text = travelRequest.currency!.symbol + " " + offer.price
        cell.imgView.setImageWithURL(NSURL(string: offer.userPhoto)!, placeholderImage: _userPlaceholderImage)
       
        if me.userMode == .Passenger {
            cell.setOfferActionButton(offer)
            cell.btnAccept.tag = indexPath.row
            cell.btnReject.tag = indexPath.row
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

//MARK: CommnetsContainerCell - Comments container cell
class CommnetsContainerCell: TVGenericeCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var comments = [Comment]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //Comments tableview delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  65 * _widthRatio
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell") as! TVGenericeCell
        return cell
    }

}

//MARK: CommnetCell - Comment cell to present a chat message.
class CommnetCell: TVGenericeCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


//MARK: OfferCell
class OfferCell: TVGenericeCell {
    @IBOutlet var btnAccept: UIButton!
    @IBOutlet var btnReject: UIButton!
    @IBOutlet var lblStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //Set action button and status for an offer
    func setOfferActionButton(offer: TravelRequestOffer) {
 
        var actionHidden = false
        var statusText = ""
        var statusColor = UIColor.grayColor()
        
        switch offer.status {
        case .Pending:
            actionHidden = false
            statusText = ""
        case .Accepted:
            actionHidden = true
            statusText = "Accepted"
            statusColor = UIColor.greenColor()
        case .Cancel:
            actionHidden = true
            statusText = "Cancelled"
             statusColor = UIColor.blackColor()
        case .Declined:
            actionHidden = true
            statusText = "Rejected"
            statusColor = UIColor.redColor()
        default:
            actionHidden = true
        }
        
        lblStatus.text = statusText
        lblStatus.textColor = statusColor
        btnAccept.hidden = actionHidden
        btnReject.hidden = actionHidden
    }
    
}


//Used to handel alertview's textfield in datepicker's event
class AlertTextDatePicker: UIDatePicker {
    var textfild: UITextField?
}


