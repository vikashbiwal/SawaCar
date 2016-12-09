//
//  DriverSearchResultVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 08/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class DriverSearchResultVC: ParentVC {

    var searchParamObj: SearchDriverParameter!
    var drivers = [User]()
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
    }
    
    func prepareUI() {
        refreshControl = self.tableView.addRefreshControl(self, selector: #selector(self.findDriverAPICall))
        initEmptyDataView()
        self.findDriverAPICall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DriverDetailSegue" {
            let detailVc = segue.destinationViewController as! DriverDetailViewController
            detailVc.driver = sender as! User
        }
    }
}

//MARK: TableViewDataSource
extension DriverSearchResultVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("driverCell") as! DriverCell
        let driver = drivers[indexPath.row]
        cell.setInfo(forDriver: driver)
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170 * _widthRatio
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let driver = drivers[indexPath.row]
        self.performSegueWithIdentifier("DriverDetailSegue", sender: driver)
    }
    
}

//MARK: Webservices call
extension DriverSearchResultVC {
    
    //Find drivers api call
    func findDriverAPICall() {
        if !refreshControl.refreshing {
            self.showCentralGraySpinner()
        }
        let params = ["AccountTypeID" : searchParamObj.accountTypeId,
                      "CountryID" :  searchParamObj.countryId ]
        wsCall.findDrivers(params) { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    if let objects = json["Object"] as? [[String : AnyObject]] {
                        self.drivers.removeAll()
                        for object in objects {
                            let driver = User(info: object)
                            self.drivers.append(driver)
                        }
                        self.tableView.reloadData()
                    }
                }
                
            } else {
                showToastErrorMessage("", message: response.message!)
            }
            self.refreshControl.endRefreshing()
            self.hideCentralGraySpinner()
            self.drivers.isEmpty ? self.emptyDataView.showInView(self.tableView, message: "NoDriversFound".localizedString(), frame: CGRect(x: 0, y: 35, width: ScreenSize.SCREEN_WIDTH, height: 40)) : self.emptyDataView.hide()
        }
        
    }
}




//MARK: AlertCell
class DriverCell: TVGenericeCell {
    @IBOutlet var cardView: UIView!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var ratingView: HCSStarRatingView!
    @IBOutlet var lblCounryName: UILabel!
    @IBOutlet var lblLanguage: UILabel!
    @IBOutlet var lblAccountType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView?.layer.cornerRadius = 5 * _widthRatio
        cardView?.layer.borderColor = UIColor.scTravelCardColor().CGColor
        cardView?.layer.borderWidth = 2.0
    }
    
    //set driver info
    func setInfo(forDriver driver: User) {
        imgView.setImageWithURL(NSURL(string: driver.photo)!, placeholderImage: _userPlaceholderImage)
        lblDriverName.text = driver.fullname
        ratingView.value = CGFloat(driver.rating)
        lblAccountType.text = driver.accountType.name
        lblCounryName.text = driver.country.name
        lblLanguage.text = driver.language
    }
}
