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
        self.tabBar.hidden = true
        // dicUser = _userDefault.valueForKey("UserData") as! NSDictionary
        let profileVC = _generalStoryboard.instantiateViewControllerWithIdentifier("SBID_ProfileVC")
        self.viewControllers?.insert(profileVC, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Tab button action
   
    
  }
