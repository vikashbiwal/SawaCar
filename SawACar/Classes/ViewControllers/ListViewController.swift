//
//  AccountTypeListVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 14/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit


enum ListType {
    case accountType, language, currency, carCompany, color, travelType
}


class ListViewController: ParentVC {
    //MARK:
    @IBOutlet var btnDone: UIButton!
    
    var listItems = [ListItem]()
    var filteredItems = [ListItem]()
    var preSelectedIDs = [String]()
    var listType: ListType!
    var enableMultipleChoice = false
    
    var refreshControl : UIRefreshControl!
    var completionBlock : ([ListItem])-> Void = {_ in}
    
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        
        self.callAPIAndSetUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: SetupUI
    func setupRefreshControl()  {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ListViewController.getAccountTypes), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func callAPIAndSetUI()  {
        btnDone.isHidden = !enableMultipleChoice
        if listType == .accountType {
            lblTitle.text = "account_type".localizedString()
            getAccountTypes()
        } else if listType == .language {
            lblTitle.text = "Languages".localizedString()
            getLanguages()
        } else if listType == .currency {
            lblTitle.text = "Currencies".localizedString()
            getCurrencies()
        } else if listType == .carCompany {
            lblTitle.text = "Compnay".localizedString()
            getCarCompanies()
        } else if listType == .color {
            lblTitle.text = "Color".localizedString()
            getColors()
        } else if listType == .travelType {
            lblTitle.text = "Travel Type".localizedString()
            getTravelTypes()
        }
    }
    
    //MARK: Other
    func filterList(_ text: String)  {
        let valuetocompare = text.lowercased()
        let arr = listItems.filter { (item) -> Bool in
            return item.name.lowercased().hasPrefix(valuetocompare) || item.code.lowercased().hasPrefix(valuetocompare)
        }
        self.filteredItems = arr
        tableView.reloadData()
    }
    
    //MARK: IBActions
    @IBAction func doneBtnClicked(_ sender: UIButton) {
        if listType == .language {
            let seletedItems = filteredItems.filter({ (item) -> Bool in
                return item.selected
            })
            completionBlock(seletedItems)
        }
        self.parentBackAction(nil)
    }
}

//MARK: Conform Protocols
extension ListViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    //MARK: Tableview datasource and delgate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TVGenericeCell
        let item = filteredItems[indexPath.row]
        if listType == .currency {
            cell.lblTitle.text = item.name + " (\(item.code))"
        } else {
            cell.lblTitle.text = item.name
        }
        
        if listType == .language {
            if preSelectedIDs.contains(item.code) || item.selected || preSelectedIDs.contains(item.Id) {
                cell.accessoryType = .checkmark
                item.selected = true
            } else {
                cell.accessoryType = .none
                item.selected = false
            }
        } else {
            if preSelectedIDs.contains(item.Id) || item.selected {
                cell.accessoryType = .checkmark
                item.selected = true
            } else {
                cell.accessoryType = .none
                item.selected = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        let item = filteredItems[indexPath.row]

        if enableMultipleChoice {
            item.selected = !item.selected
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            completionBlock([item])
            self.parentBackAction(nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if !enableMultipleChoice {
            let item  = filteredItems[indexPath.row]
            item.selected = !item.selected
            cell?.accessoryType = .none
        }
    }
    
    //MARK: SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            filterList(searchText)
        } else {
            self.filteredItems = listItems
            tableView.reloadData()
        }
    }
}

//MARK: WS Calls
extension ListViewController {
    //Get Account Types
    func getAccountTypes()  {
        self.showCentralGraySpinner()
        wsCall.getAccountTypes { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    let arr = json["Object"] as! [[String : Any]]
                   self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["AccountTypeID"])
                        let name = RConverter.string(item["Name"])
                        let li = ListItem()
                        li.Id = Id
                        li.name = name
                        let at = AccountType(info: item)
                        li.obj = at
                        self.listItems.append(li)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Get Languages
    func getLanguages() {
        self.showCentralGraySpinner()
        wsCall.getLanguages { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any]{
                    let arr = json["Object"] as! [[String : Any]]
                    self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["LanguageID"])
                        let name = RConverter.string(item["Name"])
                        let code = RConverter.string(item["Code"])
                        let li = ListItem()
                        li.Id = Id
                        li.name = name
                        li.code = code
                        self.listItems.append(li)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Get List of Currencies 
    func getCurrencies()  {
        self.showCentralGraySpinner()
        wsCall.GetAllCurrencies { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    let arr = json["Object"] as! [[String : Any]]
                    self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["CurrencyID"])
                        let name = RConverter.string(item["CurrencyName"])
                        let code = RConverter.string(item["CurrencyCode"])
                        let at = ListItem()
                        at.Id = Id
                        at.name = name
                        at.code = code
                        let currency = Currency(item)
                        at.obj = currency
                        self.listItems.append(at)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Get List of Currencies
    func getCarCompanies()  {
        self.showCentralGraySpinner()
        wsCall.getCarCompanies { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    let arr = json["Object"] as! [[String : Any]]
                    self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["CompanyID"])
                        let name = RConverter.string(item["Name"])
                        let company = Company(item)
                        let listItem = ListItem()
                        listItem.Id = Id
                        listItem.name = name
                        listItem.obj = company
                        self.listItems.append(listItem)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Get List of Currencies
    func getColors()  {
        self.showCentralGraySpinner()
        wsCall.getColors { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    let arr = json["Object"] as! [[String : Any]]
                    self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["ColorID"])
                        let name = RConverter.string(item["Name"])
                        let color = Color(item)
                        let listItem = ListItem()
                        listItem.Id = Id
                        listItem.name = name
                        listItem.obj = color
                        self.listItems.append(listItem)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }

    //Get Travel Types
    func getTravelTypes() {
        self.showCentralGraySpinner()
        wsCall.getTravelTypes { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    let arr = json["Object"] as! [[String : Any]]
                    self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["TravelTypeID"])
                        let name = RConverter.string(item["Name"])
                        let travelType = TravelType(item)
                        let listItem = ListItem()
                        listItem.Id = Id
                        listItem.name = name
                        listItem.obj = travelType
                        self.listItems.append(listItem)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()

        }
    }

}


func ==(lhs:ListItem, rhs:ListItem) -> Bool { // Implement Equatable
    return lhs.Id == rhs.Id
}
