//
//  ShareView.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 02/09/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class ShareView: VBlurView {
    
    @IBOutlet var messageView: UIView!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var lblMsg1: UILabel!
    @IBOutlet var lblMsg2: UILabel!
    @IBOutlet var lblMsg3: UILabel!
    
    var radius: Double = 0.0
    var actionBlock: (VAction)-> Void = {_ in}
    
    enum ShareViewType {
        case travel, travelRequest
    }
    
    var shareType: ShareViewType = ShareViewType.travel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 0, width: _screenSize.width, height: _screenSize.height)
        messageView.layer.cornerRadius = 8 * _widthRatio
        messageView.clipsToBounds = true
        
        btnShare.layer.cornerRadius = 5 * _widthRatio
        btnShare.clipsToBounds = true
    }
    
    func prepareForUI() {
        if shareType == .travel {
            lblMsg1.text = "Great, Now other people can join your travel!"
            lblMsg2.text = "Please wait for offer from passengers!"
            lblMsg3.text = "You can share to reach more people"
            messageView.backgroundColor = UIColor.scHeaderColor()
            
        } else if shareType == .travelRequest {
            lblMsg1.text = "Great, your request is registered"
            lblMsg2.text = "Please wait for offer from driver!"
            lblMsg3.text = "You can share to reach more people"
            messageView.backgroundColor = UIColor.green
        }
    }
    
    func showInView(_ view: UIView) {
        self.prepareForUI()
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        view.addSubview(self)
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) 
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: {(finished) in
                if finished {
                    self.removeFromSuperview()
                }
        })
    }
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        hide()
        actionBlock(VAction.cancel)
    }
    
    @IBAction func shareBtnClicked(_ sender: UIButton) {
        actionBlock(VAction.share)
    }
}
