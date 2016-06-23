//
//  VKeyboardAccessoryView.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 23/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class VKeyboardAccessoryView: UIView {
    enum KBAction {
        case Cancel, Done
    }
    var actionBlock: (KBAction)->Void = {_ in}
    
    override func awakeFromNib() {
        
    }
    
    @IBAction func doneBtnClicked(sender: UIButton) {
        actionBlock(.Done)
    }
    
    @IBAction func cancelBtnClicked(sender: UIButton) {
        actionBlock(.Cancel)
    }
}
