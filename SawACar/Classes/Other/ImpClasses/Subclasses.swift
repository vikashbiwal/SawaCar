//
//  Subclasses.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 29/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit

// MARK: - Useful Classes
class GenericCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var imgv: UIImageView!
    
}

class GenericTableViewCell: ConstrainedTableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var imgv: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class PushWithoutAnimationSegue: UIStoryboardSegue {
    override func perform() {
        let svc =  source
        svc.navigationController?.pushViewController(destination , animated: false)
    }
}

class RoundedImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = (self.bounds.size.height * _widthRatio) / 2
        self.layer.masksToBounds = true
    }
}

class RoundedView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = (self.bounds.size.height * _widthRatio) / 2
        self.layer.masksToBounds = true
    }
}

class RoundedCollectionView: UICollectionView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = (self.bounds.size.height * _widthRatio) / 2
        self.layer.masksToBounds = true
    }
}


class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = (self.bounds.size.height * _widthRatio ) / 2
        self.layer.masksToBounds = true
    }
}

class RoundedLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.masksToBounds = true
    }
}

class RoundedLabelWithWidthRatio: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        font = font.withSize(font.pointSize * _widthRatio)
        self.layer.cornerRadius = (self.bounds.size.height * _widthRatio ) / 2
        self.layer.masksToBounds = true
    }
}



