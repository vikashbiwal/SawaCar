//
//  InteractiveNavigationViewController.swift
//  Manup
//
//  Created by Yudiz Solutions Pvt.Ltd. on 30/03/16.
//  Copyright © 2016 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

import UIKit

class InteractiveNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf: InteractiveNavigationController? = self
        self.interactivePopGestureRecognizer?.delegate = weakSelf!
        self.delegate = weakSelf!
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool{
        if self.viewControllers.count > 1{
            return true
        }else{
            return false
        }
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        // Add every non interactive view controller so controller dont go back automatically.
        // Currently ManUpTabBarController should not be back interactive
//        if viewController is ManUpTabBarController {
//            self.interactivePopGestureRecognizer!.enabled = false
//        }else{
//            self.interactivePopGestureRecognizer!.enabled = true
//        }
    }

}
