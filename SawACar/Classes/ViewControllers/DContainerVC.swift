//
//  DContainerVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 06/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

let shutterMaxXValue: CGFloat = 290.0

//ViewController's StorybaordId for set in Tabbar's Viewcontrollers.
//Driver's Screens
let _DOfferRideVCID   = "SBID_DOfferRideVC"
let _DBookingsVCID    = "SBID_BookingToMyTravelVC"
let _DMyOffersVCID    = "SBID_MyOffersVC"
let _DMyRidesVCID     = "SBID_MyRidesVC"
let _DMyCarsVCID      = "SBID_CarListVC"

//Passenger's Screens
let _PRequestRideVCID = "SBID_PRequestRideVC"
let _PBookingsVCID    = "SBID_MyBookingVC"
let _POffersMeVCID    = "SBID_OffersToMeVC"
let _PMyRequestsVCID  = "SBID_MyRequestsVC"

//Common Screens
let _InboxVCID        = "SBID_InboxVC"
let _TodayWorkVCID    = "SBID_TodayWorkVC"
let _TrackingVCID     = "SBID_TrackingVC"
let _AlertVCID        = "SBID_AlertVC"
let _RatingsVCID      = "SBID_RatingVC"
let _MoreInfoVCID     = "SBID_MoreInfoVC"
let _ProfileVCID      = "SBID_ProfileVC"

class DContainerVC: ParentVC {
    
    @IBOutlet var containerViewLeadignSpace: NSLayoutConstraint!
    @IBOutlet var menuContainerLeadingSpace: NSLayoutConstraint!
    @IBOutlet var containerView : UIView!
    @IBOutlet var imgVProfile   : UIImageView!
    @IBOutlet var btnProfile    : UIButton!
    @IBOutlet var lblName       : UILabel!
    @IBOutlet var lblEmail      : UILabel!
    @IBOutlet var lblUserMode   : UILabel!
    
    var tabbarController    : TabbarViewController!
    var transparentControl  : VBlurViewLight!
    var Menus               = [Menu]()
    var isShutterOpened     = false
    var tabbarConstantVCIDs = [String] () //ViewControllers with these ids are fixed in tabbar controller.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true
        menuContainerLeadingSpace.constant = -100
        
        setTabbarConstantVCIDs()
        initializeShutterActionBlock()
        setUserInfo()
        findTabbar()
        setSliderMenus()
        setShutterBlurView()
        _defaultCenter.addObserver(self, selector: #selector(DContainerVC.setUserInfo), name: NSNotification.Name(rawValue: kProfileUpdateNotificationKey), object: nil)
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
    
    //set shutter blur view when slider open
    func setShutterBlurView() {
        transparentControl = VBlurViewLight(frame: self.view.bounds)
        let button = UIButton(frame: self.view.bounds)
        button.addTarget(self, action: #selector(self.shutterAction(_:)), for: .touchUpInside)
        transparentControl.addSubview(button)
        transparentControl.alpha = 0
    }

    //set constant vc in tabbar which not changebale
    func setTabbarConstantVCIDs() {
        if me.userMode == .driver {
            tabbarConstantVCIDs = [_ProfileVCID, _DBookingsVCID, _DMyOffersVCID, _DMyRidesVCID]
        } else {
            tabbarConstantVCIDs = [_ProfileVCID, _PBookingsVCID, _POffersMeVCID, _PMyRequestsVCID]
        }
    }
    //func for set all slider menu items for driver and passenger
    func setSliderMenus() {
        if me.userMode == .driver {
            Menus = [Menu(title: "home".localizedString(),                 imgName: "ic_home", selected: true, id: _DOfferRideVCID),
                     Menu(title: "booking_to_my_travel".localizedString(), imgName: "ic_booking_to_my_trip", id: _DBookingsVCID),
                     Menu(title: "my_offers".localizedString(),            imgName: "ic_myoffer",     id: _DMyOffersVCID),
                     Menu(title: "my_ride".localizedString(),              imgName: "ic_my_rides",    id: _DMyRidesVCID),
                     Menu(title: "my_cars".localizedString(),              imgName: "ic_my_rides",    id: _DMyCarsVCID),

                     Menu(title: "inbox".localizedString(),                imgName: "ic_inbox",       id: _InboxVCID),
                     Menu(title: "today_work".localizedString(),           imgName: "ic_today_work",  id: _TodayWorkVCID),
                     Menu(title: "tracking".localizedString(),             imgName: "ic_tracking",    id: _TrackingVCID),
                     Menu(title: "alert".localizedString(),                imgName: "ic_alert",       id: _AlertVCID),
                     Menu(title: "rating".localizedString(),               imgName: "ic_rating",      id: _RatingsVCID),
                     Menu(title: "more_info".localizedString(),            imgName: "ic_more_info",   id: _MoreInfoVCID),
                     Menu(title: "logout".localizedString(),               imgName: "ic_logout")]
            lblUserMode.text = "Change to passenger mode".localizedString()

        } else { // me.userMode == .Passenger
            Menus = [Menu(title: "home".localizedString(),                 imgName: "ic_home", selected: true, id: _PRequestRideVCID),
                     Menu(title: "my_booking".localizedString(),           imgName: "ic_booking_to_my_trip", id: _PBookingsVCID),
                     Menu(title: "offers_to_me".localizedString(),         imgName: "ic_myoffer",     id: _POffersMeVCID),
                     Menu(title: "my_request".localizedString(),           imgName: "ic_my_rides",    id: _PMyRequestsVCID),
                     Menu(title: "inbox".localizedString(),                imgName: "ic_inbox",       id: _InboxVCID),
                     Menu(title: "today_work".localizedString(),           imgName: "ic_today_work",  id: _TodayWorkVCID),
                     Menu(title: "tracking".localizedString(),             imgName: "ic_tracking",    id: _TrackingVCID),
                     Menu(title: "alert".localizedString(),                imgName: "ic_alert",       id: _AlertVCID),
                     Menu(title: "rating".localizedString(),               imgName: "ic_rating",      id: _RatingsVCID),
                     Menu(title: "more_info".localizedString(),            imgName: "ic_more_info",   id: _MoreInfoVCID),
                     Menu(title: "logout".localizedString(),               imgName: "ic_logout")]
            lblUserMode.text = "change_to_driver_mode".localizedString()
        }
        
    }
    
    //Set unselected all
    func resetSelectedMenu()  {
        Menus.forEach { (menu) in
            menu.selected = false
        }
    }
    
    
    //MARK:
    //Set user info to view on slider top view
    func setUserInfo()  {
        let userModeIconName = me.userMode == .driver ?  "ic_need_a_ride_small" : "ic_have_car_small" 
        imgVProfile.image = UIImage(named: userModeIconName)
        
        let profileUrl = URL(string: me.photo)
        btnProfile.setImageFor(UIControlState(), with: profileUrl!, placeholderImage: me.placeholderImage)
        lblName.text = me.fullname
        lblEmail.text = me.email
    }
    
    //Change User Mode Driver to Passenger and via versa.
    func changeUserMode() {
        if me.userMode == .driver {
            me.userMode = .passenger
            _userDefault.setValue(UserMode.passenger.rawValue, forKey: UserModeKey)
        } else {
            me.userMode = .driver
            _userDefault.setValue(UserMode.driver.rawValue, forKey: UserModeKey)

        }
        tabbarController.setViewControllersInTabbar()
        setTabbarConstantVCIDs()
        setSliderMenus()
        setUserInfo()
        tableView.reloadData()
        shutterActioinBlock()
    }
    
    func setCurrentVCInTabbar(_ vc: UIViewController) {
        let nav = tabbarController.viewControllers![4] as! UINavigationController
        nav.viewControllers = [vc]
        tabbarController.selectedIndex = 4
    }
}

//MARK: Slider Shutter setup and action
extension DContainerVC {
    //Shutter block initialization
    func initializeShutterActionBlock() {
        shutterActioinBlock = {[unowned self] in
            self.openCloseShutter()
        }
    }
    
    //Shutter Actions
    func openCloseShutter() {
        self.view.layoutIfNeeded()
        var x: CGFloat = 0
        var mx: CGFloat = 0 //for menu container x
        if isShutterOpened {
            isShutterOpened = false
            x = 0
            mx = -100
        } else {
            isShutterOpened = true
            x = shutterMaxXValue * _widthRatio
            mx = 0
            tabbarController.view.addSubview(transparentControl)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerViewLeadignSpace.constant = x
            self.menuContainerLeadingSpace.constant = mx
            self.transparentControl.alpha = self.isShutterOpened ? 1 : 0
            self.view.layoutIfNeeded()
        }, completion: { (res) in
            if !self.isShutterOpened {
                self.transparentControl.removeFromSuperview()
            }
        }) 
    }
}

//MARK: IBActions
extension DContainerVC {
   
    @IBAction func userModeChangeBtnClicked(_ sender: UIButton) {
        let sheet = UIAlertController(title: nil , message: "kChagneModeConfirmMsg".localizedString(), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel".localizedString(), style: .cancel, handler: nil)
        let OkAction = UIAlertAction(title: "yes".localizedString(), style: .default, handler: {(action) in
            self.changeUserMode()
        })
        sheet.addAction(cancelAction)
        sheet.addAction(OkAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    //Navigate to Profile view screen.
    @IBAction func userProfileBtnClicked(_ sender: UIButton) {
        tabbarController.selectedIndex = 0
        resetSelectedMenu()
        shutterActioinBlock()
        tableView.reloadData()
    }
}

//MARK: Tableview Datasource and delegate
extension DContainerVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier = "cell"
        if [4, 6].contains(indexPath.row) {
            identifier = "sectionLastCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! TVGenericeCell
        let menu = Menus[indexPath.row]
        cell.lblTitle.text = menu.title
        cell.imgView.image = UIImage(named: menu.imgName)
        cell.backgroundColor = menu.selected ? UIColor.scSliderSelectedMenuColor() : UIColor.scSliderMenuColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 * _widthRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menu = Menus[indexPath.row]
        if tabbarConstantVCIDs.contains(menu.Id) { //this section is used for constant viewcontrollers in tabbar
            if !menu.selected {
                tabbarController.selectedIndex = indexPath.row
                resetSelectedMenu()
                menu.selected = true
                tableView.reloadData()
            }
        } else if indexPath.row == (Menus.count - 1) {
            self.logoutAction()
            
        } else { //this section is used to change viewcontroller in last tab of tabbarcontroller.
            if !menu.selected {
                resetSelectedMenu()
                menu.selected = true
                tableView.reloadData()
                let VC = _driverStoryboard.instantiateViewController(withIdentifier: menu.Id)
                if VC is CarListVC {
                    let vc = VC as! CarListVC
                    vc.isComeFromSliderMenu = true //used for change back btn action
                }
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
        let sheet = UIAlertController(title: nil , message: "kLogoutConfirmMsg".localizedString(), preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel".localizedString(), style: .cancel, handler: nil)
        let OkAction = UIAlertAction(title: "log_out".localizedString(), style: .destructive, handler: {(action) in
            me = nil
            _userDefault.removeObject(forKey: kLoggedInUserKey)
           _ = self.navigationController?.popToRootViewController(animated: true)
        })
        sheet.addAction(cancelAction)
        sheet.addAction(OkAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
}
