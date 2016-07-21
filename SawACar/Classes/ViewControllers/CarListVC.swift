//
//  CarListVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 23/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class CarListVC: ParentVC {

    var Cars = [Car]()
    var selectedCar: Car?
    var completionBlock: (Car)->Void = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserCarsAPICall()
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addCarBtnClicked(sender: UIButton) {
        self.performSegueWithIdentifier("SBSegue_ToAddCar", sender: nil)
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SBSegue_ToAddCar" {
            let vc = segue.destinationViewController as! AddCarVC
            if let car = sender as? Car {
                vc.isEditMode = true
                vc.car = car
            }
            vc.completionBlock = {(car) in
                if self.Cars.contains(car) {
                 
                } else {
                    self.Cars.append(car)
                }
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: TableView DataSource and Delegate
extension CarListVC : UITableViewDataSource, UITableViewDelegate {
    //MARK: Tableview datasource and delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cars.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("carCell") as! TVCarCell
        let car = Cars[indexPath.row]
        cell.lblTitle.text = car.name
        cell.lblColor.text = car.color?.name
        cell.lblRating.text = car.rating.ToString()
        cell.imgView.setImageWithURL(NSURL(string: car.photo!)!)
        cell.btnCheck.hidden = car == selectedCar ? false : true
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let car = Cars[indexPath.row]
//        guard  car ==  selectedCar else {
//            selectedCar = car
//            tableView.reloadData()
//            
//        }
        completionBlock(car)
        self.parentBackAction(nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .Default, title: "Edit") { (action, idxPath) in
            let car  = self.Cars[idxPath.row]
            self.performSegueWithIdentifier("SBSegue_ToAddCar", sender: car)
        }
        editAction.backgroundColor = UIColor.scHeaderColor()
        let deleteAction = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, idxPath) in
            let car = self.Cars[idxPath.row]
            self.deleteCar(car)
        }
        return [editAction, deleteAction]
    }
    
}


//MARK: Other
extension CarListVC {

    func deleteCar(car: Car) {
        let sheet = UIAlertController(title: nil, message: "Are you sure you want to delete car - \(car.name) ?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Yes", style: .Destructive, handler: {(action) in
            self.deleteCarAPICall(car)
        })
        sheet.addAction(cancelAction)
        sheet.addAction(deleteAction)
        self.presentViewController(sheet, animated: true, completion: nil)
    }
}
//MARK: API Calls
extension CarListVC {

    func getUserCarsAPICall() {
        self.showCentralGraySpinner()
        wsCall.getCarOfUser(me.Id) { (response, flag) in
            if response.isSuccess {
                let carsObject = response.json!["Object"] as! [[String : AnyObject]]
                for item in carsObject {
                    let car = Car(item)
                    self.Cars.append(car)
                }
                self.tableView.reloadData()
            } else {
                
            }
            self.hideCentralGraySpinner()
        }
    }
    
    func deleteCarAPICall(car: Car) {
        self.showCentralGraySpinner()
        wsCall.deleteCar(car.id) { (response, flag) in
            if response.isSuccess {
                self.Cars.removeElement(car)
                self.tableView.reloadData()
            } else {
                showToastMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
        }
        
    }
}