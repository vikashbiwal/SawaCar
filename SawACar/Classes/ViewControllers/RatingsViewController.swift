//
//  RatingsViewController.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 16/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class RatingsViewController: ParentVC {

    @IBOutlet var lblScrollLine: UILabel!
    @IBOutlet var lblScrollLeadingSpace: NSLayoutConstraint!
    @IBOutlet var menuContainerView: UIView!
    @IBOutlet var collView: UICollectionView!

    @IBOutlet var btnGroupUsers: UIButton!
    @IBOutlet var btnSingleUser: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: IBActions
extension RatingsViewController {
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        btnGroupUsers.selected = false
        btnSingleUser.selected = false
        sender.selected = true
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        collView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }
}

//MARK: CollectionView DataSource and Delegate
extension RatingsViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CVGenericeCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //TODO
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 375 * _widthRatio, height: 553 * _widthRatio)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffSet = scrollView.contentOffset
        self.lblScrollLeadingSpace.constant = contentOffSet.x / 2
        self.menuContainerView.layoutIfNeeded()
    }
    
    
}


//MARK: TableView DataSource and Delegate
extension RatingsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row % 3 == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("travelRatingCell") as! TVGenericeCell
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("carRatingCell") as! TVGenericeCell
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return (indexPath.row % 3 == 0 ? 120 : 100) * _widthRatio
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
}


//MARK: Web services Call
extension RatingsViewController {
    
    //Get ratings for user
    func getRatingsForUser_APICall() {
        wsCall.getRatings(forUser: me.Id) { (response, flag) in
            
        }
    }
    
    //Get ratings by user
    func getRatingsByUser_APICall() {
        wsCall.getRatings(byUser: me.Id) { (response, flag) in
            
        }
    }
}


