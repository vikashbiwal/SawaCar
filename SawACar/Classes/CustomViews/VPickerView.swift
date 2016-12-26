//
//  VPickerView.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 24/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class VPickerView: ConstrainedView, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var pickerViewBottomSpace: NSLayoutConstraint!
    var actionBlock: (VAction, String, Int)->Void = {_ in}
    var selectedItem: (value: String, idx: Int)?
    
    var Items = [String]()
   
    override func awakeFromNib() {
        self.frame = CGRect(x: 0, y: 0, width: _screenSize.width, height: _screenSize.height)
        pickerViewBottomSpace.constant = -(260 * _widthRatio)
        self.layoutIfNeeded()

    }

    //MARK: UIPickerView DataSource and Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = (Items[row], row)
    }
    
    //MARK: Show and Hide action
    func showWithAnnimation() {
        pickerView.reloadAllComponents()
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerViewBottomSpace.constant = 0
            self.alpha = 1
            self.layoutIfNeeded()
        }) 
    }
    
    func hideWithAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerViewBottomSpace.constant = -(260 *  _widthRatio)
            self.alpha = 0
            self.layoutIfNeeded()
        }, completion: { (res) in
            self.removeFromSuperview()
        }) 
    }
    
    @IBAction func doneBtnClicked(_ sender: UIButton) {
        if let item = selectedItem {
            actionBlock(.done, item.value, item.idx)
        }
        hideWithAnimation()
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        hideWithAnimation()
    }
}
