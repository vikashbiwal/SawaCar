//
//  KPParentViewController.swift
//  VoteMe
//
//  Created by Yudiz Solutions Pvt.Ltd. on 30/03/16.
//  Copyright © 2016 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

import UIKit

class ParentVC: UIViewController  {
    
    // MARK: - Outlets
    @IBOutlet var tableView :UITableView!
    @IBOutlet var lblTitle  :UILabel!
   
//    @IBOutlet var viewHeader    : UIView?
//    @IBOutlet var viewBottom    : UIView?
    @IBOutlet var viewContainer : UIView?
    
    @IBOutlet var horizontalConstraints: [NSLayoutConstraint]?
    @IBOutlet var verticalConstraints: [NSLayoutConstraint]?
    var emptyDataView: VNoDataView! //Empty data message view for show on screen when no data available.

    // MARK: - Actions
    // Navigate to Previous View Controller with navigation popview method
    @IBAction func parentBackAction(_ sender:UIButton? ){
        self.navigationController?.popViewController(animated: true)
    }
    
    // Navigate to Previous View Controller with dismiss view method
    @IBAction func parentDismissAction(_ sender:UIButton?){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shutterAction(_ sender: UIButton) {
        self.view.endEditing(true)
        shutterActioinBlock()
    }
    
    // Navigate to Root view controller
    @IBAction func parentBackToRootViewController(_ sender: UIButton?){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
       return .lightContent
    }
    
    func setHeaderShadow(){
        //self.viewHeader?.layer.shadowColor = UIColor.blackColor().CGColor
        //self.viewHeader?.layer.shadowOpacity = 0.4
        //self.viewHeader?.layer.shadowOffset = CGSizeMake(0, 2)
        //self.lblTitle?.font = UIFont.muAvenirMedium(18.0)
    }
    
    func setBottomShadow(){
//        self.viewBottom?.layer.shadowColor = UIColor.blackColor().CGColor
//        self.viewBottom?.layer.shadowOpacity = 0.4
//        self.viewBottom?.layer.shadowOffset = CGSizeMake(0, 0)
    }
    
    func setViewContainerSize() {
        if let cView = viewContainer {
            var frame = cView.frame
            frame.size.height = tableView.contentSize.height;
            viewContainer!.frame = frame
        }
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
    
    //Show an alert message
    func showAlert(_ message: String?, title: String?)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK".localizedString(), style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Show and hide spinner hud
    lazy internal var centralActivityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "spinnerIcon")!
        return CustomActivityIndicatorView(image: image)
    }()
    
    func showCentralSpinner() {
        self.view.addSubview(centralActivityIndicator)
        let xConstraint = NSLayoutConstraint(item: centralActivityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: centralActivityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        centralActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        centralActivityIndicator.alpha = 0.0
        view.layoutIfNeeded()
        self.view.isUserInteractionEnabled = false
        centralActivityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.centralActivityIndicator.alpha = 1.0
        }) 
    }
    func hideCentralSpinner() {
        self.view.isUserInteractionEnabled = true
        centralActivityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.centralActivityIndicator.alpha = 0.0
        }) 
    }
    
    lazy internal var centralGrayActivityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "spinnerIcon_gray")!
        return CustomActivityIndicatorView(image: image)
    }()
    
    func showCentralGraySpinner() {
        centralGrayActivityIndicator.center = self.view.center
        self.view.addSubview(centralGrayActivityIndicator)
        centralGrayActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        centralGrayActivityIndicator.alpha = 0.0
        view.layoutIfNeeded()
        self.view.isUserInteractionEnabled = false
        centralGrayActivityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.centralGrayActivityIndicator.alpha = 1.0
        }) 
    }
    
    func hideCentralGraySpinner() {
        self.view.isUserInteractionEnabled = true
        centralGrayActivityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.centralGrayActivityIndicator.alpha = 0.0
        }) 
    }
}

//MARK: TextField Delegate
extension ParentVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

//MARK: Setup Empty data view
extension ParentVC {
    func initEmptyDataView()  {
        let customViews = Bundle.main.loadNibNamed("VNoDataView", owner: nil, options: nil)
        emptyDataView = customViews![0] as! VNoDataView
    }
    
    func showEmptyDataView(_ message: String = "No_items_available".localizedString(), frame frm : CGRect = CGRect.zero) {
        if frm == CGRect.zero {
            self.emptyDataView.showInCenterInView(self.view, title: message)
        } else {
            self.emptyDataView.showInView(self.view, message: message, frame : frm)
        }
    }
    
    func showEmptyDataViewAtTop(_ message: String = "No_items_available".localizedString()) {
        self.emptyDataView.showInView(self.view, message: message)
    }

}

