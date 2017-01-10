//
//  CarListVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 23/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class CarListVC: ParentVC {

    @IBOutlet var btnBack: UIButton!
    
    var Cars = [Vehicle]()
    var selectedCar: Vehicle?
    var completionBlock: (Vehicle)->Void = {_ in}
    var refreshControl : UIRefreshControl!

    var isComeFromSliderMenu = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = self.tableView.addRefreshControl(self, selector: #selector(CarListVC.getUserCarsAPICall))

        self.setBackButtonAction()
        self.getUserCarsAPICall()
        initEmptyDataView()
        showEmptyDataView("kNoCarAvailable".localizedString())
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SBSegue_ToAddCar" {
            let vc = segue.destination as! AddCarVC
            if let car = sender as? Vehicle {
                vc.isEditMode = true
                vc.car = car
            }
            vc.completionBlock = {(car) in
                if self.Cars.contains(car) {
                 
                } else {
                    self.Cars.append(car)
                }
                self.emptyDataView.hide()
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: IBActions
extension CarListVC {
    @IBAction func addCarBtnClicked(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SBSegue_ToAddCar", sender: nil)
    }
    
}

//MARK: TableView DataSource and Delegate
extension CarListVC : UITableViewDataSource, UITableViewDelegate {
    //MARK: Tableview datasource and delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carCell") as! TVCarCell
        let car = Cars[indexPath.row]
        cell.lblTitle.text = car.name
        cell.lblColor.text = car.color?.name
        cell.lblSeats.text = car.seatCounter.max.ToString()
        cell.imgView.setImageWith(URL(string: car.photo)!, placeholderImage: UIImage(named: "carPlaceholder"))
        cell.btnCheck.isHidden = car == selectedCar ? false : true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let car = Cars[indexPath.row]
        completionBlock(car)
        self.parentBackAction(nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit".localizedString()) { (action, idxPath) in
            let car  = self.Cars[idxPath.row]
            self.performSegue(withIdentifier: "SBSegue_ToAddCar", sender: car)
        }
        editAction.backgroundColor = UIColor.scHeaderColor()
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete".localizedString()) { (action, idxPath) in
            let car = self.Cars[idxPath.row]
            self.deleteCar(car)
        }
        return [editAction, deleteAction]
    }
    
}



//MARK: Other
extension CarListVC {

    //Set back button action as per navigation
    func setBackButtonAction() {
     
        if isComeFromSliderMenu {
            btnBack.addTarget(self, action: #selector(self.shutterAction(_:)), for: .touchUpInside)
            btnBack.setImage(UIImage(named: "ic_menu"), for: UIControlState())
        } else {
            btnBack.addTarget(self, action: #selector(self.parentBackAction(_:)), for: .touchUpInside)
            btnBack.setImage(UIImage(named: "ic_back_arrow"), for: UIControlState())

        }
    }
    
    //Delete car
    func deleteCar(_ car: Vehicle) {
        let sheet = UIAlertController(title: nil, message: "are_you_sure_delete".localizedString() +  "- '\(car.name)' ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No".localizedString(), style: .default, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Yes".localizedString(), style: .destructive, handler: {(action) in
            self.deleteCarAPICall(car)
        })
        sheet.addAction(cancelAction)
        sheet.addAction(deleteAction)
        self.present(sheet, animated: true, completion: nil)
    }
}
//MARK: API Calls
extension CarListVC {

    func getUserCarsAPICall() {
        self.showCentralGraySpinner()
        wsCall.getCarOfUser { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    if let array = json as? [[String : Any]] {
                        for item in array {
                            let car = Vehicle(item)
                            self.Cars.append(car)
                        }
                    }
                }
//                let carsObject = response.json!["Object"] as! [[String : AnyObject]]
                self.Cars.isEmpty ? self.showEmptyDataView() : self.emptyDataView.hide()
                
                self.tableView.reloadData()
            } else {
                self.showEmptyDataView("kNoCarAvailable".localizedString())
            }
            self.hideCentralGraySpinner()
            self.refreshControl.endRefreshing()
        }
    }
    
    func deleteCarAPICall(_ car: Vehicle) {
        self.showCentralGraySpinner()
        wsCall.deleteCar(["CarID" : car.id]) { (response, flag) in
            if response.isSuccess {
                self.Cars.removeElement(car)
                self.tableView.reloadData()
            } else {
                showToastMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
        
    }
}
