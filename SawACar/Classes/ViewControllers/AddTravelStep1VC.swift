//
//  AddTravelStep1VC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class AddTravelStep1VC: ParentVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: Tableview datasource and delegate
extension AddTravelStep1VC: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = ""
        if indexPath.row == 0 {
            cellIdentifier = "locationCell"
        } else if indexPath.row == 1 {
            cellIdentifier = "stopoverCell"
        } else if indexPath.row == 2 {
            cellIdentifier = "regularTravelCell"
        } else if indexPath.row == 3 {
            cellIdentifier = "roundTravelCell"
        } else if indexPath.row == 4 {
            cellIdentifier = "weekDayCell"
        } else if indexPath.row == 5 {
            cellIdentifier = "rideDateTimeCell"
        } else {
            cellIdentifier = "buttonCell"
        }
        let cell =  tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 75 * _widthRatio
        } else if indexPath.row == 1 {
            return 200 * _widthRatio
        } else if indexPath.row == 2 {
            return 150 * _widthRatio
        } else if indexPath.row == 3 {
            return 150 * _widthRatio
        } else if indexPath.row == 4 {
            return 100 * _widthRatio
        } else if indexPath.row == 5 {
            return 90 * _widthRatio
        } else {
            return 80 * _widthRatio
        }
    }
}