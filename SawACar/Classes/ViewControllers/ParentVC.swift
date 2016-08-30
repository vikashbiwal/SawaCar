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
  
    // MARK: - Actions
    // Navigate to Previous View Controller with navigation popview method
    @IBAction func parentBackAction(sender:UIButton? ){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Navigate to Previous View Controller with dismiss view method
    @IBAction func parentDismissAction(sender:UIButton?){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shutterAction(sender: UIButton) {
        self.view.endEditing(true)
        shutterActioinBlock()
    }
    
    // Navigate to Root view controller
    @IBAction func parentBackToRootViewController(sender: UIButton?){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraintUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
       return .LightContent
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
    func showAlert(message: String?, title: String?)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Show and hide spinner hud
    lazy internal var centralActivityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "spinnerIcon")!
        return CustomActivityIndicatorView(image: image)
    }()
    
    func showCentralSpinner() {
        self.view.addSubview(centralActivityIndicator)
        let xConstraint = NSLayoutConstraint(item: centralActivityIndicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: centralActivityIndicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        centralActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([xConstraint, yConstraint])
        centralActivityIndicator.alpha = 0.0
        view.layoutIfNeeded()
        self.view.userInteractionEnabled = false
        centralActivityIndicator.startAnimating()
        UIView.animateWithDuration(0.2) { () -> Void in
            self.centralActivityIndicator.alpha = 1.0
        }
    }
    func hideCentralSpinner() {
        self.view.userInteractionEnabled = true
        centralActivityIndicator.stopAnimating()
        UIView.animateWithDuration(0.2) { () -> Void in
            self.centralActivityIndicator.alpha = 0.0
        }
    }
    
    lazy internal var centralGrayActivityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "spinnerIcon_gray")!
        return CustomActivityIndicatorView(image: image)
    }()
    
    func showCentralGraySpinner() {
        centralGrayActivityIndicator.center = self.view.center
        self.view.addSubview(centralGrayActivityIndicator)
        //let xConstraint = NSLayoutConstraint(item: centralGrayActivityIndicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
       // let yConstraint = NSLayoutConstraint(item: centralGrayActivityIndicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        centralGrayActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        //NSLayoutConstraint.activateConstraints([xConstraint, yConstraint])
        centralGrayActivityIndicator.alpha = 0.0
        view.layoutIfNeeded()
        self.view.userInteractionEnabled = false
        centralGrayActivityIndicator.startAnimating()
        UIView.animateWithDuration(0.2) { () -> Void in
            self.centralGrayActivityIndicator.alpha = 1.0
        }
    }
    
    func hideCentralGraySpinner() {
        self.view.userInteractionEnabled = true
        centralGrayActivityIndicator.stopAnimating()
        UIView.animateWithDuration(0.2) { () -> Void in
            self.centralGrayActivityIndicator.alpha = 0.0
        }
    }
}
