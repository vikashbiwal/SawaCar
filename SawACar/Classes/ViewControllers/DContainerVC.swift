//
//  DContainerVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 06/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

let shutterMaxXValue: CGFloat = 290.0

//Navigation controller's StorybaordId for set in Tabbar's Viewcontrollers.
let dHomeNavID           = "SBID_DOfferRideVC"
let dBookToMyTravelNavID = "SBID_BookingToMyTravelVC"
let dMyOfferNavID        = "SBID_MyOffersVC"
let dMyRideNavID         = "SBID_MyRidesVC"

let pHomeNavID      = "SBID_PRequestRideVC"
let pMyBookingNavID = "SBID_MyBookingVC"
let pOfferToMeNavID = "SBID_OffersToMeVC"
let pMyRequestNavID = "SBID_MyRequestsVC"

let InboxNavId      = "SBID_InboxVC"
let TodayWorkNavID  = "SBID_TodayWorkVC"
let TrakingNavID    = "SBID_TrackingVC"
let AlertNavID      = "SBID_AlertVC"
let RatingsNavID    = "SBID_RatingVC"
let MoreInfoNavID   = "SBID_MoreInfoVC"
let profileNavID    = "SBID_ProfileVC"

class DContainerVC: ParentVC {
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerViewLeadignSpace: NSLayoutConstraint!
  
    @IBOutlet var imgVProfile: UIImageView!
    @IBOutlet var btnProfile : UIButton!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail : UILabel!
    @IBOutlet var lblUserMode: UILabel!
    
    var tabbarController: TabbarViewController!
    var transparentControl: UIControl!
    var Menus = [Menu]()
    var isShutterOpened  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeShutterActionBlock()
        setUserInfo()
        findTabbar()
        setSliderMenus()
        
        transparentControl = UIControl(frame: self.view.bounds)
        transparentControl.addTarget(self, action: #selector(DContainerVC.shutterAction(_:)), forControlEvents: .TouchUpInside)
        transparentControl.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        transparentControl.alpha = 0
        _defaultCenter.addObserver(self, selector: #selector(DContainerVC.setUserInfo), name: kProfileUpdateNotificationKey, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        _defaultCenter.removeObserver(self)
    }
    
    func findTabbar() {
        self.childViewControllers.forEach { (controller) in
            if controller is TabbarViewController {
                tabbarController = controller as! TabbarViewController
            }
        }
    }
    
    func setSliderMenus() {
        if me.userMode == .Driver {
            Menus = [Menu(title: "Home",                 imgName: "ic_home", selected: true,        id: dHomeNavID),
                     Menu(title: "Inbox",                imgName: "ic_inbox",       id: InboxNavId),
                     Menu(title: "Booking to my travel", imgName: "ic_booking_to_my_trip", id: dBookToMyTravelNavID),
                     Menu(title: "My Offers",            imgName: "ic_myoffer",     id: dMyOfferNavID),
                     Menu(title: "My Ride",              imgName: "ic_my_rides",    id: dMyRideNavID),
                     Menu(title: "Today Work",           imgName: "ic_today_work",  id: TodayWorkNavID),
                     Menu(title: "Tracking",             imgName: "ic_tracking",    id: TrakingNavID),
                     Menu(title: "Alert",                imgName: "ic_alert",       id: AlertNavID),
                     Menu(title: "Rating",               imgName: "ic_rating",      id: RatingsNavID),
                     Menu(title: "More Info",            imgName: "ic_more_info",   id: MoreInfoNavID),
                     Menu(title: "Logout",               imgName: "ic_logout")]
            lblUserMode.text = "Change to passenger mode"

        } else { // me.userMode == .Passenger
            Menus = [Menu(title: "Home",                 imgName: "ic_home", selected: true,       id: pHomeNavID),
                     Menu(title: "Inbox",                imgName: "ic_inbox",       id: InboxNavId),
                     Menu(title: "My Booking",           imgName: "ic_booking_to_my_trip", id: pMyBookingNavID),
                     Menu(title: "Offers To Me",         imgName: "ic_myoffer",     id: pOfferToMeNavID),
                     Menu(title: "My Request",           imgName: "ic_my_rides",    id: pMyRequestNavID),
                     Menu(title: "Today Work",           imgName: "ic_today_work",  id: TodayWorkNavID),
                     Menu(title: "Tracking",             imgName: "ic_tracking",    id: TrakingNavID),
                     Menu(title: "Alert",                imgName: "ic_alert",       id: AlertNavID),
                     Menu(title: "Rating",               imgName: "ic_rating",      id: RatingsNavID),
                     Menu(title: "More Info",            imgName: "ic_more_info",   id: MoreInfoNavID),
                     Menu(title: "Logout",               imgName: "ic_logout")]
            lblUserMode.text = "Change to driver mode"
        }
        
    }
    
    //Set unselected all
    func resetSelectedMenu()  {
        Menus.forEach { (menu) in
            menu.selected = false
        }
    }
    
    //MARK: Shutter Actions and block initialization
    func initializeShutterActionBlock() {
        shutterActioinBlock = {[unowned self] in
            self.openCloseShutter()
        }
    }
    
    func openCloseShutter() {
        self.view.layoutIfNeeded()
        var x: CGFloat = 0
        if isShutterOpened {
            isShutterOpened = false
            x = 0
        } else {
            isShutterOpened = true
            x = shutterMaxXValue * _widthRatio
            tabbarController.view.addSubview(transparentControl)
        }
        
        UIView.animateWithDuration(0.3, animations: {
            self.containerViewLeadignSpace.constant = x
            self.transparentControl.alpha = self.isShutterOpened ? 1 : 0
            self.view.layoutIfNeeded()
        }) { (res) in
            if !self.isShutterOpened {
                self.transparentControl.removeFromSuperview()
            }
        }
    }
    
    //MARK:
    //Set user info to view on slider top view
    func setUserInfo()  {
        let profileUrl = NSURL(string: me.photo)
        imgVProfile.setImageWithURL(profileUrl!, placeholderImage: me.placeholderImage)
        btnProfile.setImageForState(.Normal, withURL: profileUrl!, placeholderImage: me.placeholderImage)
        lblName.text = me.fullname
        lblEmail.text = me.email
    }
    
    //Change User Mode Driver to Passenger and via versa.
    func changeUserMode() {
        var homeVCID = ""
        if me.userMode == .Driver {
            me.userMode = .Passenger
            homeVCID = pHomeNavID
            _userDefault.setValue(UserMode.Passenger.rawValue, forKey: UserModeKey)
        } else {
            me.userMode = .Driver
            homeVCID = dHomeNavID
            _userDefault.setValue(UserMode.Driver.rawValue, forKey: UserModeKey)

        }
        let homeVC = _driverStoryboard.instantiateViewControllerWithIdentifier(homeVCID)
        setCurrentVCInTabbar(homeVC)
        setSliderMenus()
        tableView.reloadData()
        shutterActioinBlock()
    }
    
    func setCurrentVCInTabbar(vc: UIViewController) {
        let nav = tabbarController.viewControllers![0] as! UINavigationController
        nav.viewControllers = [vc]
    }
}

//MARK: IBActions
extension DContainerVC {
    @IBAction func userModeChangeBtnClicked(sender: UIButton) {
        let sheet = UIAlertController(title: nil , message: kChagneModeConfirmMsg, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let OkAction = UIAlertAction(title: "Yes", style: .Default, handler: {(action) in
            self.changeUserMode()
        })
        sheet.addAction(cancelAction)
        sheet.addAction(OkAction)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
    //Navigate to Profile view screen.
    @IBAction func userProfileBtnClicked(sender: UIButton) {
        let profileVC = _driverStoryboard.instantiateViewControllerWithIdentifier(profileNavID)
        setCurrentVCInTabbar(profileVC)
        resetSelectedMenu()
        shutterActioinBlock()
        tableView.reloadData()
    }
}

//MARK: Tableview Datasource and delegate
extension DContainerVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = "cell"
        if [3, 5].contains(indexPath.row) {
            identifier = "sectionLastCell"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! TVGenericeCell
        let menu = Menus[indexPath.row]
        cell.lblTitle.text = menu.title
        cell.imgView.image = UIImage(named: menu.imgName)
        cell.backgroundColor = menu.selected ? UIColor.scSliderSelectedMenuColor() : UIColor.scSliderMenuColor()
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50 * _widthRatio
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == (Menus.count - 1) {
            self.logoutAction()
        } else {
            let menu = Menus[indexPath.row]
            if !menu.selected {
                resetSelectedMenu()
                menu.selected = true
                tableView.reloadData()
                let VC = _driverStoryboard.instantiateViewControllerWithIdentifier(menu.Id)
                setCurrentVCInTabbar(VC)
            }
        }
        shutterActioinBlock()
    }
}

//MARK: Other
extension DContainerVC {
    //Logout action
    func logoutAction() {
        let sheet = UIAlertController(title: nil , message: kLogoutConfirmMsg, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let OkAction = UIAlertAction(title: "Ok", style: .Default, handler: {(action) in
            me = nil
            _userDefault.removeObjectForKey(kLoggedInUserKey)
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
        sheet.addAction(cancelAction)
        sheet.addAction(OkAction)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
    
}
