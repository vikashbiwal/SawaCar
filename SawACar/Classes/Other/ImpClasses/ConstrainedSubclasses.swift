//
//  ConstrainedSubclasses.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 01/03/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit


//MARK: - Constained Classes for All device support
/// Bewlow all calssed reduces text of button and Lavel according to device screen size
class JPWidthTextField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        if let afont = font {
            font = afont.withSize(afont.pointSize * _widthRatio)
        }
    }
}

class JPWidthButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        if let afont = titleLabel?.font {
            titleLabel?.font = afont.withSize(afont.pointSize * _widthRatio)
        }
    }
}

class JPHeightButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        if let afont = titleLabel?.font {
            titleLabel?.font = afont.withSize(afont.pointSize * _heighRatio)
        }
    }
}

class JPWidthLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font.withSize(font.pointSize * _widthRatio)
    }
}

class JPHeightLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font.withSize(font.pointSize * _heighRatio)
    }
}

class JPWidthRoundLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font.withSize(font.pointSize * _widthRatio)
        self.layer.cornerRadius = (self.bounds.size.height * _widthRatio)/2
        self.layer.masksToBounds = true
    }
}

class JPHeightRoundLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font.withSize(font.pointSize * _heighRatio)
        self.layer.cornerRadius = (self.bounds.size.height * _heighRatio)/2
        self.layer.masksToBounds = true
    }
}


class KPIconButton: UIButton {
    override func awakeFromNib() {
        if let img = self.imageView{
            let btnsize = self.frame.size
            let imgsize = img.frame.size
            let verPad = ((btnsize.height - (imgsize.height * _widthRatio)) / 2)
            self.imageEdgeInsets = UIEdgeInsetsMake(verPad, 0, verPad, 0)
            self.imageView?.contentMode = .scaleAspectFit
        }
        if let afont = titleLabel?.font {
            titleLabel?.font = afont.withSize(afont.pointSize * _widthRatio)
        }
    }
}


/// This View contains collection of Horizontal and Vertical constrains. Who's constant value varies by size of device screen size.
class ConstrainedView: UIView {
    
    // MARK: Outlets
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    
    // MARK: Awaken
    override func awakeFromNib() {
        super.awakeFromNib()
        constraintUpdate()
    }
    
    func constraintUpdate() {
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * _widthRatio
                const.constant = v2
            }
        }
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * _heighRatio
                const.constant = v2
            }
        }
    }
}

/// This Collection view cell contains collection of Horizontal and Vertical constrains. Who's constant value varies by size of device screen size.
class ConstrainedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        constraintUpdate()
    }
    
    // This will update constaints and shrunk it as device screen goes lower.
    func constraintUpdate() {
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * _widthRatio
                const.constant = v2
            }
        }
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * _heighRatio
                const.constant = v2
            }
        }
    }
    
}

/// This Table view cell contains collection of Horizontal and Vertical constrains. Who's constant value varies by size of device screen size.
class ConstrainedTableViewCell: UITableViewCell {
    
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        constraintUpdate()
    }
    
    
    // This will update constaints and shrunk it as device screen goes lower.
    func constraintUpdate() {
        if let hConts = horizontalConstraints {
            for const in hConts {
                let v1 = const.constant
                let v2 = v1 * _widthRatio
                const.constant = v2
            }
        }
        if let vConst = verticalConstraints {
            for const in vConst {
                let v1 = const.constant
                let v2 = v1 * _heighRatio
                const.constant = v2
            }
        }
    }
    
    
    // MARK: Activity
    lazy internal var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "spinnerIcon")!
        return CustomActivityIndicatorView(image: image)
    }()
    
    // This will show and hide spinner. In middle of container View
    // You can pass any view here, Spinner will be placed there runtime and removed on hide.
    func showSpinnerIn(_ container: UIView, control: UIButton) {
        container.addSubview(activityIndicator)
        let xConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: -10)
        let yConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -10)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        activityIndicator.alpha = 0.0
        layoutIfNeeded()
        isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.activityIndicator.alpha = 1.0
            control.alpha = 0.0
        }) 
    }
    
    func hideSpinnerIn(_ container: UIView, control: UIButton) {
        isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.activityIndicator.alpha = 0.0
            control.alpha = 1.0
        }) 
    }
}
