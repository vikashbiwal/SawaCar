//
//  GiveRatingsVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 19/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class GiveRatingsVC: ParentVC {

    @IBOutlet var profileImageHeight: NSLayoutConstraint!
    @IBOutlet var profileContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: IBActions
extension GiveRatingsVC {
    
    @IBAction func userRatingChanged(_ sender: AnyObject?) {
        
    }
    
    @IBAction func carRatingBtnChanged(_ sender: AnyObject?) {
        
    }
}

//MARK: TableView DataSource and Delegate
extension GiveRatingsVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "driverRatingCell") as! TVGenericeCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "carRatingCell") as! TVGenericeCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 180 : 222
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset
        profileImageHeight.constant =  -contentOffset.y
    }
}

//MARK: Rating Cell for Tableview
class RatingCell: TVGenericeCell {
    
    @IBOutlet var lblRatingCount: UILabel!
    @IBOutlet var ratingView: HCSStarRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblRatingCount.layer.cornerRadius = 15
        lblRatingCount.layer.borderColor = UIColor.scHeaderColor().cgColor
        lblRatingCount.layer.borderWidth = 1.5
        lblRatingCount.clipsToBounds = true
        ratingView.backgroundColor = UIColor.clear
    }
}
