//
//  WMParentTBC.swift
//  Wake-A-Mate
//
//  Created by Yudiz Solutions Pvt. Ltd. on 27/08/15.
//  Copyright (c) 2015 Yudiz Solutions Pvt. Ltd. All rights reserved.
//vdfsdafsda

import UIKit

class TabbarViewController: UITabBarController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        self.setViewControllersInTabbar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Tab button action
   
    //Set viewcontroller as per user mode.
    func setViewControllersInTabbar() {
        let profileVC   = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_ProfileVC")
        let nav0 = self.viewControllers![0] as! UINavigationController
        let nav1 = self.viewControllers![1] as! UINavigationController
        let nav2 = self.viewControllers![2] as! UINavigationController
        let nav3 = self.viewControllers![3] as! UINavigationController
        let nav4 = self.viewControllers![4] as! UINavigationController
       
        if me.userMode == .driver {
            let myOffersVC  = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_BookingToMyTravelVC")
            let myRidesVC   = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_MyOffersVC")
            let bookingsVC  = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_MyRidesVC")
            let offerRideVC = _driverStoryboard.instantiateViewController(withIdentifier: "SBID_DOfferRideVC")
            nav0.viewControllers = [profileVC]
            nav1.viewControllers = [myOffersVC]
            nav2.viewControllers = [myRidesVC]
            nav3.viewControllers = [bookingsVC]
            nav4.viewControllers = [offerRideVC] //the last view controller will be changed as per slider menu selected item
            self.selectedIndex   = 4 //Offer a ride screen is opened by default.
            
        } else { //Passenger
            let requestRideVC   = _driverStoryboard.instantiateViewController(withIdentifier: _PRequestRideVCID)
            let myBookingsVC    = _driverStoryboard.instantiateViewController(withIdentifier: _PBookingsVCID)
            let offerMeVc       = _driverStoryboard.instantiateViewController(withIdentifier: _POffersMeVCID)
            let myRequestsVc    = _driverStoryboard.instantiateViewController(withIdentifier: _PMyRequestsVCID)
            nav0.viewControllers = [profileVC]
            nav1.viewControllers = [myBookingsVC]
            nav2.viewControllers = [offerMeVc]
            nav3.viewControllers = [myRequestsVc]
            nav4.viewControllers = [requestRideVC] //the last view controller will be changed as per slider menu selected item
            self.selectedIndex = 4 //Request a ride screen is opened by default.
        }
        

    }
    
  }
