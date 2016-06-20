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
    }
}

//Cell is used in Profile Vc for Setting tab
class ProfileSettingCell: TVGenericeCell {
    @IBOutlet var switchBtn: SettingSwitch!
    @IBOutlet var lblHeader:UILabel?

}
