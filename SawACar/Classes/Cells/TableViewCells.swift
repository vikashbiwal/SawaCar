//
//  TableViewCells.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 12/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class TVGenericeCell: ConstrainedTableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class TVSignUpFormCell: TVGenericeCell {
    @IBOutlet var txtField: SignupTextField!
    @IBOutlet var button: UIButton?
    @IBOutlet var dtPicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//Cell is used in Profile Vc for Setting tab
class ProfileSettingCell: TVGenericeCell {
    @IBOutlet var switchBtn: SettingSwitch!
    @IBOutlet var lblHeader:UILabel?

}


//MARK: Cells for Add travel screen
//MARK: WeekDayCell : Used to get user's choice of week day.
class WeekDaysTblCell: TVGenericeCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    
    var weekDays = [Day("Mon"), Day("Tue"), Day("Wed"), Day("Thu"), Day("Fri"), Day("Sat"), Day("Sun")]
    
    //MARK: CollectionView datasource and delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CVGenericeCell
        let day = weekDays[indexPath.row]
        let (backColor, textColor) = day.selected ? (UIColor.scHeaderColor(), UIColor.whiteColor()): (UIColor.groupTableViewBackgroundColor(), UIColor.lightGrayColor())
        cell.lblTitle.backgroundColor = backColor
        cell.lblTitle.textColor = textColor
        
        cell.lblTitle.text = day.name
        cell.lblTitle.layer.borderColor = UIColor.scHeaderColor().CGColor
        cell.lblTitle.layer.borderWidth = 1.0
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 42 * _widthRatio, height: 42 * _widthRatio)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 7 * _widthRatio
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let day = weekDays[indexPath.row]
        day.selected = !day.selected
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    //class that represent a day
    class Day {
        var name: String!
        var selected = false
        init(_ name: String, selected: Bool = false) {
            self.name = name
            self.selected = selected
        }
    }
}


//MARK: ==============================Add Travel related Cells=======================

//MARK: StopoverCell : Used in Add Travel Screen of Driver mode.
class StopoverCell: TVGenericeCell {
    @IBOutlet var firstStopView :  UIView?
    @IBOutlet var secondStopView:  UIView?
    @IBOutlet var thirdStopView :  UIView?
    @IBOutlet var lblStop1 : UILabel!
    @IBOutlet var lblStop2 : UILabel!
    @IBOutlet var lblStop3 : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstStopView?.layer.borderWidth  = 1.0
        firstStopView?.layer.borderColor  = UIColor.lightGrayColor().CGColor
        
        secondStopView?.layer.borderWidth = 1.0
        secondStopView?.layer.borderColor = UIColor.lightGrayColor().CGColor

        thirdStopView?.layer.borderWidth  = 1.0
        thirdStopView?.layer.borderColor  = UIColor.lightGrayColor().CGColor
        
        firstStopView?.backgroundColor    = UIColor.whiteColor()
        secondStopView?.backgroundColor   = UIColor.whiteColor()
        thirdStopView?.backgroundColor    = UIColor.whiteColor()
    }
}

//MARK: Round/Reguler Travel Cell: Used in Add Travel Screen of Driver Mode.
class TravelDateTimeCell: TVGenericeCell {
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblDateTitile: UILabel!
    @IBOutlet var lblTimeTitle: UILabel!
    @IBOutlet var checkBoxBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK: SteperCell : Used in AddTravel screen to increase/decrease value
class SteperCell: TVGenericeCell {
    @IBOutlet var btnDecreaseCount: IndexPathButton!
    @IBOutlet var btnIncreaseCount: IndexPathButton!
    @IBOutlet var txtField: IndexPathTextField!
    var steperForType: TravelPreferenceType = .None
    weak var delegate: AddTravelStep2VC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let customViews = NSBundle.mainBundle().loadNibNamed("CustomViews", owner: nil, options: nil)
        let av = customViews[0] as! VKeyboardAccessoryView
        
        av.actionBlock = {(action) in
            self.txtField.resignFirstResponder()
            self.delegate?.steperTextFieldCompleteEditing(self.steperForType, cell: self)
        }
        
        txtField.inputAccessoryView = av
    }
}

//MARK: TravelSwitchCell : Used in AddTravel Screen
class TravelSwitchCell: TVGenericeCell {
    @IBOutlet var switchBtn1: TravelSwitch!
    @IBOutlet var switchBtn2: TravelSwitch!
    @IBOutlet var lblSubTitle2: TravelSwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK: Car list cell
class TVCarCell : TVGenericeCell {
    @IBOutlet var lblColor: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblSeats: UILabel!
    @IBOutlet var btnCheck: UIButton!
    @IBOutlet var ratingView: HCSStarRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


//MARK: ==============================Travel Detail related Cells=======================

//MARK: MyRulesCell
class TVDriverRulesCell : TVGenericeCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var Rules = [String]()
    override func awakeFromNib() {
        
    }
    
    //MARK: CollectionView DataSource and Delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Rules.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CVGenericeCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = 50 * _widthRatio
        return CGSize(width: width, height: width)
    }
}


//MAR: TravelCell
class TVTravelCell : TVGenericeCell {
    @IBOutlet var lblTravelDate     : UILabel!
    @IBOutlet var lblTravelTime     : UILabel!
    @IBOutlet var lblLocationFrom   : UILabel!
    @IBOutlet var lblLocationTo     : UILabel!
    @IBOutlet var lblCarName        : UILabel!
    @IBOutlet var lblCarPrice       : UILabel!
    @IBOutlet var lblSeatNumber     : UILabel!
    @IBOutlet var lblSeatsLeft      : UILabel!
    @IBOutlet var lblDriverName     : UILabel!
    @IBOutlet var imgvDriver        : UIImageView!
    @IBOutlet var cardView          : UIView?  //View that contain Travel info. See MyRides screen.
    @IBOutlet var ratingView: HCSStarRatingView!

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView?.layer.cornerRadius = 5 * _widthRatio
        cardView?.layer.borderColor = UIColor.scTravelCardColor().CGColor
        cardView?.layer.borderWidth = 2.0
    }
}