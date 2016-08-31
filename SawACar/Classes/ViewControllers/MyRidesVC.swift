//
//  MyRidesVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 31/08/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class MyRidesVC: ParentVC {

    var myRides = [Travel]()
    var refreshControl : UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = self.tableView.addRefreshControl(self, selector: #selector(MyRidesVC.getMyRides))
        initEmptyDataView()
        showEmptyDataView(kMyRidesNotAvailable)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: TableView DataSource and Delegate
extension MyRidesVC {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRides.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//MARK: API Calls
extension MyRidesVC {
    func getMyRides() {
        if !refreshControl.refreshing {
            showCentralGraySpinner()
        }
     let userid = me.Id
        wsCall.getTravels(userid) { (response, flag) in
            if response.isSuccess {
            
                let arrRides = response.json!["Object"] as! [[String : AnyObject]]
                
                for json in arrRides {
                    let ride = Travel(json)
                    self.myRides.append(ride)
                }
                
                self.myRides.isEmpty ? self.showEmptyDataView(kMyRidesNotAvailable) : self.emptyDataView.hide()
                self.tableView.reloadData()
            } else {
                showToastErrorMessage("", message: response.message!)
            }
            self.refreshControl.endRefreshing()
            self.hideCentralGraySpinner()
        }
    }
}