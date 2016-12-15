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
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var addContactButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContactButtonView.drawShadow()
        addContactsBtnTransform()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //show/hide addContacts button
    func addContactsBtnTransform(toVisible: Bool = false) {
        let scaleFactor: CGFloat = toVisible ? 1.0 : 0.1
        self.addContactButtonView.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            let transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
            self.addContactButtonView.transform = transform
            
        }) { (hmm) in
            self.addContactButtonView.hidden = !toVisible
        }
    }
}

//MARK: IBActions
extension TrackingViewController {
    
    @IBAction func menuButtonTapped(sender: UIButton) {
        let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
        collView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
    }
    
    @IBAction func followMeSwitchTapped(sender: UISwitch) {
        //TODO
    }
    
    @IBAction func generateCodeButtonTapped(sender: UIButton) {
        //TODO
    }
    
    @IBAction func addContactsBtnTapped(sender: UIButton) {
        self.performSegueWithIdentifier("toAddContactSegue", sender: nil)
    }
}


//MARK: CollectionView DataSource and Delegate
extension TrackingViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TrackingCollectionViewCell
        if indexPath.row == 0 {
            cell.selectedMenuType = .Me
        } else if indexPath.row == 1  {
            cell.selectedMenuType = .MyTrips
        } else {
            cell.selectedMenuType = .MyContacts
        }
        cell.viewcontroller = self
        cell.tableView.reloadData()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //TODO
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let contentOffSet = scrollView.contentOffset
        self.lblScrollLeadingSpace.constant = contentOffSet.x / 3
        self.menuContainerView.layoutIfNeeded()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let contentOffSet = scrollView.contentOffset
        let pageIndex = Int(contentOffSet.x / ScreenSize.SCREEN_WIDTH)
        self.setUIForPageIndex(pageIndex)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let contentOffSet = scrollView.contentOffset
        let pageIndex = Int(contentOffSet.x / ScreenSize.SCREEN_WIDTH)
        self.setUIForPageIndex(pageIndex)
    }
    
    //SetUI for Current Visible Page Menu
    func setUIForPageIndex(index: Int) {
        if (index >= 0) && (index < collView.numberOfItemsInSection(0)) {
            addContactsBtnTransform(index == 2 ? true : false)
            self.view.endEditing(true)
        }
    }
}

//MARK: Tracking CollectionView cell
class TrackingCollectionViewCell: CVGenericeCell, UITableViewDataSource, UITableViewDelegate {
   
    enum TrackingMenuType: Int {
        case Me, MyTrips, MyContacts
    }

    @IBOutlet var tableView: UITableView!
    var selectedMenuType = TrackingMenuType.Me
    weak var viewcontroller: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: TableView DataSource and Delegate
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
        if selectedMenuType == .MyTrips {
            
        } else if selectedMenuType == .MyContacts {
            viewcontroller?.performSegueWithIdentifier("toLocationSegue", sender: nil)
        }
    }

}
