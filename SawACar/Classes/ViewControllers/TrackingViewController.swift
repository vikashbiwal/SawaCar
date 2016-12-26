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
        addContactsBtnTransform()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //show/hide addContacts button
    func addContactsBtnTransform(_ toVisible: Bool = false) {
        let scaleFactor: CGFloat = toVisible ? 1.0 : 0.1
        self.addContactButtonView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            let transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            self.addContactButtonView.transform = transform
            
        }, completion: { (hmm) in
            self.addContactButtonView.isHidden = !toVisible
        }) 
    }
}

//MARK: IBActions
extension TrackingViewController {
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        collView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func followMeSwitchTapped(_ sender: UISwitch) {
        //TODO
    }
    
    @IBAction func generateCodeButtonTapped(_ sender: UIButton) {
        //TODO
    }
    
    @IBAction func addContactsBtnTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toAddContactSegue", sender: nil)
    }
}


//MARK: CollectionView DataSource and Delegate
extension TrackingViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrackingCollectionViewCell
        if indexPath.row == 0 {
            cell.selectedMenuType = .me
        } else if indexPath.row == 1  {
            cell.selectedMenuType = .myTrips
        } else {
            cell.selectedMenuType = .myContacts
        }
        cell.viewcontroller = self
        cell.tableView.reloadData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375 * _widthRatio, height: 553 * _widthRatio)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffSet = scrollView.contentOffset
        self.lblScrollLeadingSpace.constant = contentOffSet.x / 3
        self.menuContainerView.layoutIfNeeded()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffSet = scrollView.contentOffset
        let pageIndex = Int(contentOffSet.x / ScreenSize.SCREEN_WIDTH)
        self.setUIForPageIndex(pageIndex)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let contentOffSet = scrollView.contentOffset
        let pageIndex = Int(contentOffSet.x / ScreenSize.SCREEN_WIDTH)
        self.setUIForPageIndex(pageIndex)
    }
    
    //SetUI for Current Visible Page Menu
    func setUIForPageIndex(_ index: Int) {
        if (index >= 0) && (index < collView.numberOfItems(inSection: 0)) {
            addContactsBtnTransform(index == 2 ? true : false)
            self.view.endEditing(true)
        }
    }
}

//MARK: Tracking CollectionView cell
class TrackingCollectionViewCell: CVGenericeCell, UITableViewDataSource, UITableViewDelegate {
   
    enum TrackingMenuType: Int {
        case me, myTrips, myContacts
    }

    @IBOutlet var tableView: UITableView!
    var selectedMenuType = TrackingMenuType.me
    weak var viewcontroller: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView?.tableFooterView = UIView()
    }
    
    //MARK: TableView DataSource and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedMenuType == .me {
            return 2
        } else if selectedMenuType == .myTrips {
            return 5
            
        } else  { //if selectedMenuType == .MyContacts
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if selectedMenuType == .me {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "followMeCell")  as! TVGenericeCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "codeGenerateCell")  as! TVGenericeCell
                return cell
            }
            
        } else if selectedMenuType == .myTrips {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell")  as! TVGenericeCell
            return cell
            
        } else  { //if selectedMenuType == .MyContacts
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")  as! TVGenericeCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedMenuType == .me {
            return indexPath.row == 0 ? 60 : 169
            
        } else if selectedMenuType == .myTrips {
            return 150
            
        } else  { //if selectedMenuType == .MyContacts
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedMenuType == .myTrips {
            
        } else if selectedMenuType == .myContacts {
            viewcontroller?.performSegue(withIdentifier: "toLocationSegue", sender: nil)
        }
    }

}
