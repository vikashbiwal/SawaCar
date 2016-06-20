//
//  AccountTypeListVC.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 14/06/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit


enum ListType {
    case AccountType, Language
}


class ListViewController: ParentVC {
    //MARK:
    @IBOutlet var btnDone: UIButton!
    
    var listItems = [ListItem]()
    var filteredItems = [ListItem]()
    var selectedItes = [ListItem]()
    var preSelectedIDs = [String]()
    var listType: ListType!
    var enableMultipleChoice = false
    
    var refreshControl : UIRefreshControl!
    var completionBlock : ([ListItem])-> Void = {_ in}
    
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
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
            lblTitle.text = "Account Type"
            getAccountTypes()
        } else if listType == .Language {
            lblTitle.text = "Languages"
            getLanguages()
        }
    }

    
    //MARK: Other
    func filterList(text: String)  {
        let arr = listItems.filter { (ct) -> Bool in
            return ct.name.hasPrefix(text)
        }
        self.filteredItems = arr
        tableView.reloadData()
    }
    
    //MARK: IBActions
    @IBAction func doneBtnClicked(sender: UIButton) {
        if listType == .Language {
            completionBlock(selectedItes)
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
        cell.lblTitle.text = item.name
        if preSelectedIDs.contains(item.Id) || selectedItes.contains(item) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        let item = filteredItems[indexPath.row]

        if enableMultipleChoice {
            if selectedItes.contains(item) {
                selectedItes.removeElement(item)
            } else {
                selectedItes.append(item)
            }
            tableView.reloadData()
        } else {
            completionBlock([item])
            self.parentBackAction(nil)
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .None
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
                        let at = ListItem(id: Id, name: name)
                        self.listItems.append(at)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
            
            }
            self.hideCentralGraySpinner()
        }
    }
    
    //Get Languages
    func getLanguages() {
        wsCall.getLanguages { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    let arr = json["Object"] as! [[String : AnyObject]]
                    self.listItems.removeAll()
                    for item in arr {
                        let Id = RConverter.string(item["LanguageID"])
                        let name = RConverter.string(item["Name"])
                        let code = RConverter.string(item["Code"])
                        let at = ListItem(id: Id, name: name, code: code)
                        self.listItems.append(at)
                    }
                    self.filteredItems = self.listItems
                    self.tableView.reloadData()
                }
            } else {
                
            }
            self.hideCentralGraySpinner()
        }
    }
}

//MARK: List Item to handle all type of item
class ListItem: Equatable {
    var Id: String!
    var name: String
    var code: String!
    init(id: String, name: String, code: String = "") {
        self.Id = id
        self.name = name
        self.code = code
    }
    
}

func ==(lhs:ListItem, rhs:ListItem) -> Bool { // Implement Equatable
    return lhs.Id == rhs.Id
}
