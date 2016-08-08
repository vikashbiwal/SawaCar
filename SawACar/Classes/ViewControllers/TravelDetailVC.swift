//
//  TravelDetailVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 18/07/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class TravelDetailVC: ParentVC {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: TableView DataSource and Delegate
extension TravelDetailVC : UITableViewDataSource, UITableViewDelegate {
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("travelInfoCell") as! TVGenericeCell
            return cell
        } else  {
            let cell = tableView.dequeueReusableCellWithIdentifier("myRulesCell") as! TVGenericeCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 158 * _widthRatio
        } else if indexPath.row == 1 {
            return 110 * _widthRatio
        } else {
            return 0
        }
    }
}