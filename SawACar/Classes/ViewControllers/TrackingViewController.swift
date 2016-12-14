//
//  TrackingViewController.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 14/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class TrackingViewController: ParentVC {

    @IBOutlet var lblScrollLine: UILabel!
    @IBOutlet var lblScrollLeadingSpace: NSLayoutConstraint!
    @IBOutlet var menuContainerView: UIView!
   
    enum TrackingMenuType: Int {
        case Me, MyTrips, MyContacts
    }
    
    var selectedMenuType = TrackingMenuType.Me
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set UI and Other info for current selected menu
    func setUIForCurrentMenu() {
        
    }
}

//MARK: IBActions
extension TrackingViewController {
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        let positionX = lblScrollLine.frame.size.width * CGFloat(sender.tag)
        
        UIView.animateWithDuration(0.3, animations: {
            self.lblScrollLeadingSpace.constant = positionX
            self.menuContainerView.layoutIfNeeded()
        })
        selectedMenuType = TrackingMenuType(rawValue: sender.tag)!
        self.tableView.reloadData()
    }
}

extension TrackingViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedMenuType == .Me {
            return 2
        } else if selectedMenuType == .MyTrips {
            return 5
            
        } else  { //if selectedMenuType == .MyContacts
            return 10
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if selectedMenuType == .Me {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("followMeCell")  as! TVGenericeCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("codeGenerateCell")  as! TVGenericeCell
                return cell
            }
            
        } else if selectedMenuType == .MyTrips {
            let cell = tableView.dequeueReusableCellWithIdentifier("tripCell")  as! TVGenericeCell
            return cell
            
        } else  { //if selectedMenuType == .MyContacts
            let cell = tableView.dequeueReusableCellWithIdentifier("contactCell")  as! TVGenericeCell
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedMenuType == .Me {
            return indexPath.row == 0 ? 60 : 169
            
        } else if selectedMenuType == .MyTrips {
            return 150
            
        } else  { //if selectedMenuType == .MyContacts
            return 120
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}
