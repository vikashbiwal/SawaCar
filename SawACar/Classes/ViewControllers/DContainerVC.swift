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
    
    var Menus = [Menu]()
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
    
    func initializeMenus() {
        Menus = [Menu(title: "Home",                 imgName: "ic_home", selected: true),
                 Menu(title: "Inbox",                imgName: "ic_inbox"),
                 Menu(title: "Booking to my travel", imgName: "ic_booking_to_my_trip"),
                 Menu(title: "My Offers",            imgName: "ic_myoffer"),
                 Menu(title: "My Ride",              imgName: "ic_my_rides"),
                 Menu(title: "Today Work",           imgName: "ic_today_work"),
                 Menu(title: "Tracking",             imgName: "ic_tracking"),
                 Menu(title: "Alert",                imgName: "ic_alert"),
                 Menu(title: "Rating",               imgName: "ic_rating"),
                 Menu(title: "More Info",            imgName: "ic_more_info")]
        
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
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50 * _widthRatio
    }
}
