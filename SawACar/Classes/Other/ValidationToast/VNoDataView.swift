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
        self.frame = CGRect(x: 0, y: 64, width: _screenSize.width, height: 50)
        super.awakeFromNib()
    }
    
    func showInView(view: UIView, textColor: UIColor = UIColor.blackColor(), backgroundColor: UIColor = UIColor.whiteColor()) {
        self.frame = CGRect(x: 0, y: 64, width: _screenSize.width, height: 50)
        self.lblTitle.textColor = textColor
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
