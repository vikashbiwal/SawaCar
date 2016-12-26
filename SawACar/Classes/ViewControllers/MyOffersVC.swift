//
//  MyOffersVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 06/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class MyOffersVC: ParentVC {

    var offers = [TravelRequestOffer]()
    var refreshControl: UIRefreshControl!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recrea.
    }
    
}

//MARK: TableviewDataSource
extension MyOffersVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "offerCell") as! TravelRequestOfferInfoCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190 * _widthRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

//MARK: Web Service Calls
extension MyOffersVC {
    
    func getOffersAPICallForDriver() {
    
    }
}
