//
//  DRideRequestDetailVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 11/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class DRideRequestDetailVC: ParentVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

// MARK: TableView Datasource and Delegate
extension DRideRequestDetailVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("RideLocationInfoCell") as! TVRideRequestLocationCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("RidePriceInfoCell") as! TVGenericeCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 125 * _widthRatio
        } else {
            return 25 * _widthRatio
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
}



//Cells
class TVRideRequestLocationCell : TVGenericeCell {
   
    @IBOutlet var lblLocationFrom : UILabel!
    @IBOutlet var lblLocatonTo : UILabel!
    @IBOutlet var lblRideDate : UILabel!
    @IBOutlet var lblRideTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


