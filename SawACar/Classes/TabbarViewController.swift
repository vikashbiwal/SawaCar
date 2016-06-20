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
    
        var identifier: String!
        if me.userMode == .Driver {
            identifier = dHomeNavID
        } else {
            identifier = pHomeNavID
        }
        let vc = _driverStoryboard.instantiateViewControllerWithIdentifier(identifier)
        let nav = self.viewControllers![0] as! UINavigationController
        nav.viewControllers = [vc]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Tab button action
   
    
  }
