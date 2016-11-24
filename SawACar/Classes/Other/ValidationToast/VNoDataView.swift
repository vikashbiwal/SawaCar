//
//  VPopupView.swift
//  Clingr
//
//  Created by Yudiz Solutions Pvt. Ltd. on 27/07/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class VNoDataView: ConstrainedView {
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.frame = CGRect(x: 0, y: 64, width: _screenSize.width, height: 50)
    }
    
    func showInView(view: UIView, message: String? = nil, textColor: UIColor = UIColor.blackColor(), backgroundColor: UIColor = UIColor.whiteColor(), frame frm: CGRect = CGRect(x: 0, y: 64, width: _screenSize.width, height: 50)) {
        self.frame = frm
        self.lblTitle.textColor = textColor
        self.lblTitle.text = message ?? "No data available."
        self.backgroundColor = backgroundColor
        view.addSubview(self)
    }
    
    func showInCenterInView(view: UIView, title: String? = nil, textColor: UIColor = UIColor.blackColor(), backgroundColor: UIColor = UIColor.whiteColor()) {
        
        let center = (_screenSize.height / 2) - 25
        self.frame = CGRect(x: 0, y: center, width: _screenSize.width, height: 50)
        self.lblTitle.textColor = textColor
        self.backgroundColor = backgroundColor
        self.lblTitle.text = title ?? "No data available."
        view.addSubview(self)
    }

    func hide(animated: Bool = false) {
        self.removeFromSuperview()
    }
    
}
