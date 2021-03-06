//
//  TableViewCells.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 12/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class TVGenericeCell: ConstrainedTableViewCell {

    @IBOutlet var lblTitle   : UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var imgView    : UIImageView!
    @IBOutlet var button     : UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class TVSignUpFormCell: TVGenericeCell {
    @IBOutlet var txtField: SignupTextField!
    @IBOutlet var dtPicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//Cell is used in Profile Vc for Setting tab
class TblSwitchBtnCell : TVGenericeCell {
    @IBOutlet var switchBtn: SettingSwitch!
    @IBOutlet var lblHeader:UILabel?

}

//MARK: Cells for Add travel screen
//MARK: WeekDayCell : Used to get user's choice of week day.
class WeekDaysTblCell: TVGenericeCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collView: UICollectionView!
    
    var weekDays = [Day("Mon"), Day("Tue"), Day("Wed"), Day("Thu"), Day("Fri"), Day("Sat"), Day("Sun")]
    
    //MARK: CollectionView datasource and delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CVGenericeCell
        let day = weekDays[indexPath.row]
        let (backColor, textColor) = day.selected ? (UIColor.scHeaderColor(), UIColor.white): (UIColor.groupTableViewBackground, UIColor.lightGray)
        cell.lblTitle.backgroundColor = backColor
        cell.lblTitle.textColor = textColor
        
        cell.lblTitle.text = day.name
        cell.lblTitle.layer.borderColor = UIColor.scHeaderColor().cgColor
        cell.lblTitle.layer.borderWidth = 1.0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 42 * _widthRatio, height: 42 * _widthRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 7 * _widthRatio
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = weekDays[indexPath.row]
        day.selected = !day.selected
        collectionView.reloadItems(at: [indexPath])
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
    
    @IBOutlet var icn_downArrow1 : UIImageView!
    @IBOutlet var icn_downArrow2 : UIImageView!
    @IBOutlet var icn_downArrow3 : UIImageView!
    
    @IBOutlet var btnClose1 : UIButton!
    @IBOutlet var btnClose2 : UIButton!
    @IBOutlet var btnClose3 : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstStopView?.layer.borderWidth  = 1.0
        firstStopView?.layer.borderColor  = UIColor.lightGray.cgColor
        
        secondStopView?.layer.borderWidth = 1.0
        secondStopView?.layer.borderColor = UIColor.lightGray.cgColor

        thirdStopView?.layer.borderWidth  = 1.0
        thirdStopView?.layer.borderColor  = UIColor.lightGray.cgColor
        
        firstStopView?.backgroundColor    = UIColor.white
        secondStopView?.backgroundColor   = UIColor.white
        thirdStopView?.backgroundColor    = UIColor.white
    }
    
    //set Stopover location info 
    func setStoppersInfo(_ stopers : [GLocation?]) {
        if let location1 = stopers[0] {
            lblStop1.text = location1.name
            btnClose1.isHidden = false
            icn_downArrow1.isHidden = true
        } else {
            lblStop1.text = "Stop".localizedString() +  "1"
            btnClose1.isHidden = true
            icn_downArrow1.isHidden = false
        }
        
        if let location2 = stopers[1] {
            lblStop2.text = location2.name
            btnClose2.isHidden = false
            icn_downArrow2.isHidden = true

        } else {
            lblStop2.text = "Stop".localizedString() + "2"
            btnClose2.isHidden = true
            icn_downArrow2.isHidden = false

        }
        
        if let location3 = stopers[2] {
            lblStop3.text = location3.name
            btnClose3.isHidden = false
            icn_downArrow3.isHidden = true

        } else {
            lblStop3.text = "Stop".localizedString() + "3"
            btnClose3.isHidden = true
            icn_downArrow3.isHidden = false

        }
    }
}

//MARK: Round/Reguler Travel Cell: Used in Add Travel Screen of Driver Mode.
class TravelDateTimeCell: TVGenericeCell {
    @IBOutlet var lblDate       : UILabel!
    @IBOutlet var lblTime       : UILabel!
    @IBOutlet var lblDateTitile : UILabel!
    @IBOutlet var lblTimeTitle  : UILabel!
    @IBOutlet var checkBoxBtn   : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //Set info for regular travel
    func setRegularTravelInfo(_ travel: Travel) {
        self.checkBoxBtn.isSelected = travel.isRegularTravel
        
        if let date = travel.repeateEndDate() {
            let repeatEndTime = dateFormator.stringFromDate(date, style: DateFormatter.Style.medium)
            self.lblTime.text = repeatEndTime
        } else {
            self.lblTime.text = "Select".localizedString()
        }
        
        self.lblDate.text = travel.repeatType == 1 ? "Day".localizedString() : "Month".localizedString()
    }
    
    //set info for Round travel.
    func setRoundTravelInfo(_ travel: Travel) {
        self.checkBoxBtn.isSelected = travel.isRoundTravel
        
        //round date
        if let date = travel.roundTravelDate() {
            let roundDate = dateFormator.stringFromDate(date, style: DateFormatter.Style.medium)
            self.lblDate.text = roundDate
        } else {
            self.lblDate.text = "Select".localizedString()
        }

        //round time.
        let time =  travel.roundHour + ":" + travel.roundMinute + ":00"
        if let date = dateFormator.dateFromString(time, fomat: "HH:mm:ss") {
            self.lblTime.text = dateFormator.stringFromDate(date, format: "hh:mm a")
        } else {
          self.lblTime.text = "Select".localizedString()
        }
    }
    
    //Set departure time for travel
    func setDepartureInfoFor(_ travel: Travel) {
        //departure date
        if let date = travel.departurDate() {
            let roundDate = dateFormator.stringFromDate(date, style: DateFormatter.Style.medium)
            self.lblDate.text = roundDate
        } else {
            self.lblDate.text = "Select".localizedString()
        }
        
        //departure time.
        let time =  travel.departureHour + ":" + travel.departureMinute + ":00"
        if let date = dateFormator.dateFromString(time, fomat: "HH:mm:ss") {
            self.lblTime.text = dateFormator.stringFromDate(date, format: "hh:mm a")
            
        } else {
            self.lblTime.text = "Select".localizedString()
        }
    }
    
    //Set ride date and time for ride request for passanger
    func setDateAndTime(ForRideRequest request: TravelRequest) {
        //Ride date
        if let date = request.departurDate() {
            let dateString = dateFormator.stringFromDate(date, style: DateFormatter.Style.medium)
            self.lblDate.text = dateString
            self.lblTime.text = dateFormator.stringFromDate(date, format: "hh:mm a")

        } else {
            self.lblDate.text = "Select".localizedString()
            self.lblTime.text = "Select".localizedString()
        }
        
//        //Ride time.
//        if let date = dateFormator.dateFromString(request.departureTime, fomat: "HH:mm:ss") {
//            self.lblTime.text = dateFormator.stringFromDate(date, format: "hh:mm a")
//            
//        } else {
//            self.lblTime.text = "Select".localizedString()
//        }

    }
    
}

//MARK: SteperCell : Used in AddTravel screen to increase/decrease value
class SteperCell: TVGenericeCell {
    @IBOutlet var btnDecreaseCount: IndexPathButton!
    @IBOutlet var btnIncreaseCount: IndexPathButton!
    @IBOutlet var txtField: IndexPathTextField!
    var steperForType: TravelPreferenceType = .none
    weak var delegate: AddTravelStep2VC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let customViews = Bundle.main.loadNibNamed("CustomViews", owner: nil, options: nil)
        let av = customViews![0] as! VKeyboardAccessoryView
        
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
    @IBOutlet var collView: UICollectionView!
    
    let Rules = ["Smoking", "Music", "Food", "Kids", "Pets", "PrayingStop", "Quran"]
    var driverRules = [String]()
    
    var RulesImages = ["Smoking"     : UIImage(named: "ic_rules_smoking"),
                       "Music"       : UIImage(named: "ic_rules_music"),
                       "Food"        : UIImage(named: "ic_rules_food"),
                       "Kids"        : UIImage(named: "ic_rules_children"),
                       "Pets"        : UIImage(named: "ic_rules_pets"),
                       "PrayingStop" : UIImage(named: "ic_rules_pray"),
                       "Quran"       : UIImage(named: "ic_rules_quran"),
                       "NoSmoking"   : UIImage(named: "ic_rules_no_smoking"),
                       "NoMusic"     : UIImage(named: "ic_rules_no_music"),
                       "NoFood"      : UIImage(named: "ic_rules_no_food"),
                       "NoKids"      : UIImage(named: "ic_rules_no_children"),
                       "NoPets"      : UIImage(named: "ic_rules_no_pets"),
                       "NoPrayingStop" : UIImage(named: "ic_rules_no_pray"),
                       "NoQuran"     : UIImage(named: "ic_rules_no_quran")]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: CollectionView DataSource and Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Rules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CVGenericeCell
        let rule = Rules[indexPath.row]
        if driverRules.contains(rule) {
            let image = RulesImages[rule]
            cell.imgView.image = image!
        } else {
            let image = RulesImages["No" + rule]
            cell.imgView.image = image!
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 50 * _widthRatio
        return CGSize(width: width, height: width)
    }
}


class TVTravelPassengersCell : TVGenericeCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var passengers = [Booking]()
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: CollectionView DataSource and Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return passengers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CVGenericeCell
        let booking = passengers[indexPath.row]
        cell.imgView.setImageWith(URL(string: booking.userPhoto)!, placeholderImage: _userPlaceholderImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 40 * _widthRatio
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5 * _widthRatio
    }
}


//MARK: TravelCell
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
    @IBOutlet var ratingView        : HCSStarRatingView!

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView?.layer.cornerRadius = 5 * _widthRatio
        cardView?.layer.borderColor = UIColor.scTravelCardColor().cgColor
        cardView?.layer.borderWidth = 2.0
    }
    
    //set ride info 
    func setRideInfo(_ ride: Travel) {
        lblTravelDate.text = dateFormator.dateString(ride.departureDate, fromFomat: "dd/MM/yyyy hh:mm:ss", toFromat: "dd MMM")//ride.departureDate
        lblTravelTime.text = dateFormator.dateString(ride.departureTime, fromFomat: "HH:mm", toFromat: "hh:mm a")
        
        lblCarName.text      = ride.car?.name
        lblLocationFrom.text = ride.locationFrom?.name
        lblLocationTo.text   = ride.locationTo?.name
        lblSeatNumber.text   = ride.travelSeat.value.ToString() + " " + "Seats".localizedString()
        lblSeatsLeft.text    = ride.seatLeft.ToString() + " " + "Left".localizedString()
        lblDriverName.text   = ride.driver.name
        lblCarPrice.text     = ride.currency!.symbol + " " + ride.passengerPrice.value.ToString()
        ratingView.value     = CGFloat(ride.driver.rating)
        
        imgvDriver.setImageWith(URL(string: ride.driver.photoURl)!, placeholderImage: _userPlaceholderImage)
    }
}


//MARK: RideRequestCell   used for show ride requests info

class TblRideRequestCell: TVGenericeCell {
    @IBOutlet var lblLocationFrom   : UILabel!
    @IBOutlet var lblLocationTo     : UILabel!
    @IBOutlet var lblTravelDate     : UILabel!
    @IBOutlet var lblTravelTime     : UILabel!
    @IBOutlet var lblOfferCount     : UILabel!
    @IBOutlet var lblAcceptCount    : UILabel!
    @IBOutlet var lblPrice          : UILabel!
    @IBOutlet var lblRequesterName  : UILabel!
    @IBOutlet var imgvRequester     : UIImageView!
    @IBOutlet var cardView          : UIView?  //View that contain Travel info. See MyRides screen.
    @IBOutlet var ratingView        : HCSStarRatingView!

    override func awakeFromNib() {
        super.awakeFromNib()
        cardView?.layer.cornerRadius = 5 * _widthRatio
        cardView?.layer.borderColor = UIColor.scTravelCardColor().cgColor
        cardView?.layer.borderWidth = 2.0 
    }
    
    func setInfoFor(_ request: TravelRequest) {
        lblLocationFrom.text = request.fromLocation.name
        lblLocationTo.text = request.toLocation.name
        lblTravelDate.text = dateFormator.stringFromDate(request.departurDate()!, format: "dd MMM")
        lblTravelTime.text = dateFormator.dateString(request.departureTime, fromFomat: "HH:mm:ss", toFromat: "hh:mm a")
        lblOfferCount.text = request.offers.count.ToString() + " " + (request.offers.count > 1 ? "Offers" : "Offer").localizedString()
        lblPrice.text = request.currency!.symbol + " " + request.suggestedPrice.ToString()
        lblRequesterName.text = request.passanger.name
        imgvRequester.setImageWith(URL(string: request.passanger.photoURl)!, placeholderImage: _userPlaceholderImage)
    }
}


