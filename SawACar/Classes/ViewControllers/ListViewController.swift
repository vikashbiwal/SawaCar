//
//  AccountTypeListVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 14/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit


enum ListType {
    case AccountType, Language, Currency, CarCompany, Color, TravelType
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
        refreshControl.addTarget(self, action: #selector(ListViewController.getAccountTypes), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func callAPIAndSetUI()  {
        btnDone.hidden = !enableMultipleChoice
        if listType == .AccountType {
            lblTitle.text = "account_type".localizedString()
            getAccountTypes()
        } else if listType == .Language {
            lblTitle.text = "Languages".localizedString()
            getLanguages()
        } else if listType == .Currency {
            lblTitle.text = "Currencies".localizedString()
            getCurrencies()
        } else if listType == .CarCompany {
            lblTitle.text = "Compnay".localizedString()
            getCarCompanies()
        } else if listType == .Color {
            lblTitle.text = "Color".localizedString()
            getColors()
        } else if listType == .TravelType {
            lblTitle.text = "Travel Type".localizedString()
            getTravelTypes()
        }
    }
    
    //MARK: Other
    func filterList(text: String)  {
        let valuetocompare = text.lowercaseString
        let arr = listItems.filter { (item) -> Bool in
            return item.name.lowercaseString.hasPrefix(valuetocompare) || item.code.lowercaseString.hasPrefix(valuetocompare)
        }
        self.filteredItems = arr
        tableView.reloadData()
    }
    
    //MARK: IBActions
    @IBAction func doneBtnClicked(sender: UIButton) {
        if listType == .Language {
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TVGenericeCell
        let item = filteredItems[indexPath.row]
        if listType == .Currency {
            cell.lblTitle.text = item.name + " (\(item.code))"
        } else {
            cell.lblTitle.text = item.name
        }
        
        if listType == .Language {
            if preSelectedIDs.contains(item.code) || item.selected || preSelectedIDs.contains(item.Id) {
                cell.accessoryType = .Checkmark
                item.selected = true
            } else {
                cell.accessoryType = .None
                item.selected = false
            }
        } else {
            if preSelectedIDs.contains(item.Id) || item.selected {
                cell.accessoryType = .Checkmark
                item.selected = true
            } else {
                cell.accessoryType = .None
                item.selected = false
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        let item = filteredItems[indexPath.row]

        if enableMultipleChoice {
            item.selected = !item.selected
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        } else {
            completionBlock([item])
            self.parentBackAction(nil)
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if !enableMultipleChoice {
            let item  = filteredItems[indexPath.row]
            item.selected = !item.selected
            cell?.accessoryType = .None
        }
    }
    
    //MARK: SearchBar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
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
                if let json = response.json {
                    let arr = json["Object"] as! [[String : AnyObject]]
                   self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["AccountTypeID"])
                        let name = RConverter.string(item["Name"])
                        let li = ListItem(id: Id, name: name)
                        let at = AccountType(info: item)
                        li.obj = at
                        self.listItems.append(li)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Get Languages
    func getLanguages() {
        self.showCentralGraySpinner()
        wsCall.getLanguages { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    let arr = json["Object"] as! [[String : AnyObject]]
                    self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["LanguageID"])
                        let name = RConverter.string(item["Name"])
                        let code = RConverter.string(item["Code"])
                        let li = ListItem(id: Id, name: name, code: code)
                        self.listItems.append(li)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Get List of Currencies 
    func getCurrencies()  {
        self.showCentralGraySpinner()
        wsCall.GetAllCurrencies { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    let arr = json["Object"] as! [[String : AnyObject]]
                    self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["CurrencyID"])
                        let name = RConverter.string(item["CurrencyName"])
                        let code = RConverter.string(item["CurrencyCode"])
                        let at = ListItem(id: Id, name: name, code: code)
                        let currency = Currency(item)
                        at.obj = currency
                        self.listItems.append(at)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Get List of Currencies
    func getCarCompanies()  {
        self.showCentralGraySpinner()
        wsCall.getCarCompanies { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    let arr = json["Object"] as! [[String : AnyObject]]
                    self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["CompanyID"])
                        let name = RConverter.string(item["Name"])
                        let company = Company(item)
                        let listItem = ListItem(id: Id, name: name)
                        listItem.obj = company
                        self.listItems.append(listItem)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Get List of Currencies
    func getColors()  {
        self.showCentralGraySpinner()
        wsCall.getColors { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    let arr = json["Object"] as! [[String : AnyObject]]
                    self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["ColorID"])
                        let name = RConverter.string(item["Name"])
                        let color = Color(item)
                        let listItem = ListItem(id: Id, name: name)
                        listItem.obj = color
                        self.listItems.append(listItem)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
        }
    }

    //Get Travel Types
    func getTravelTypes() {
        self.showCentralGraySpinner()
        wsCall.getTravelTypes { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    let arr = json["Object"] as! [[String : AnyObject]]
                    self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["TravelTypeID"])
                        let name = RConverter.string(item["Name"])
                        let travelType = TravelType(item)
                        let listItem = ListItem(id: Id, name: name)
                        listItem.obj = travelType
                        self.listItems.append(listItem)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()

        }
    }

}

//MARK: List Item to handle all type of item
class ListItem : Equatable {
    var Id: String!
    var name: String
    var code: String!
    var selected = false
    var obj: AnyObject!
    init(id: String, name: String, code: String = "") {
        self.Id = id
        self.name = name
        self.code = code
    }
    
}

func ==(lhs:ListItem, rhs:ListItem) -> Bool { // Implement Equatable
    return lhs.Id == rhs.Id
}
