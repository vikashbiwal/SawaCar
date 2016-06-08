//
//  DContainerVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 06/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

let shutterMaxXValue: CGFloat = 290.0

class DContainerVC: ParentVC {
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerViewLeadignSpace: NSLayoutConstraint!
    
    var menus = [[String : String]]()
    var isShutterOpened  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMenus()
        initializeShutterActionBlock()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func initializeMenus() {
        menus = [["title" : "Home",                 "iconName" : "ic_home"],
                 ["title" : "Inbox",                "iconName" : "ic_inbox"],
                 ["title" : "Booking to my travel", "iconName" : "ic_booking_to_my_trip"],
                 ["title" : "My Offers",            "iconName" : "ic_myoffer"],
                 ["title" : "My Ride",              "iconName" : "ic_my_rides"],
                 ["title" : "Today Work",           "iconName" : "ic_today_work"],
                 ["title" : "Tracking",             "iconName" : "ic_tracking"],
                 ["title" : "Alert",                "iconName" : "ic_alert"],
                 ["title" : "My Car",               "iconName" : "ic_my_car"],
                 ["title" : "Rating",               "iconName" : "ic_rating"],
                 ["title" : "More Info",            "iconName" : "ic_more_info"]]
    }
    
    
    //MARK: Shutter Actions and block initialization
    func initializeShutterActionBlock() {
        shutterActioinBlock = {[unowned self] in
            print("block call")
            self.openCloseShutter()
        }
    }
    
    func openCloseShutter() {
        var x: CGFloat = 0
        if isShutterOpened {
            isShutterOpened = false
            x = 0
            
        } else {
            isShutterOpened = true
            x = shutterMaxXValue * _widthRatio
        }
        
        UIView.animateWithDuration(0.3) {
            self.containerViewLeadignSpace.constant = x
            self.view.layoutIfNeeded()
        }
    }
    
}

//MARK: Tableview Datasource and delegate
extension DContainerVC : UITableViewDelegate, UITableViewDataSource {
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var identifier = "cell"
        if [3, 5].contains(indexPath.row) {
            identifier = "sectionLastCell"
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! TVGenericeCell
        let menu = menus[indexPath.row]
        cell.lblTitle.text = menu["title"]
        cell.imgView.image = UIImage(named: menu["iconName"]!)
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50 * _widthRatio
    }
}
