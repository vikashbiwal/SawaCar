//
//  VListViewController.swift
//  VListViewDemo
//
//  Created by Yudiz Solutions Pvt. Ltd. on 20/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

/* How to Use
 let listVC = VListViewController.loadFromNib()
 listVC.apiName = "GetAllCountries"
 listVC.keyForId = "CountryID"
 listVC.keyForTitle = "CountryName"
 
 listVC.completionBlock = {(items) in
 print(items)
 print(items.first?.obj) //obj is the json object. Convert this json obj in particular model type (like country, currency, etc.)
 }
 
 self.presentViewController(listVC, animated: true, completion: nil)
 
 */

class VListViewController: ParentVC, UISearchBarDelegate {
   
    
    var refreshControl : UIRefreshControl!
    
    var screenTitle: String = "List Item"
    var listItems = [ListItem]()
    var filteredItems = [ListItem]()
    var enableMultipleChoice = false

    var apiName = "" //Name of the api from which items will be fetched.
    var keyForId = "" //Key name for id field in response api object
    var keyForTitle = "" //Key name for title field (which want to show on tableview) in api response object
    var keyForData = "Object" //as per sawaCar api
    var preSelectedIDs = [String]()
    
    var completionBlock : ([ListItem])-> Void = {_ in};
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        lblTitle.text = screenTitle
        
        getItemsAPICall()
    }

    deinit {
        print("VListViewController deInit")
    }
    //Load listVC from nib
    class func loadFromNib()-> VListViewController {
        let vc = VListViewController(nibName: "VListViewController", bundle: nil)
        return vc
    }

    //MARK: SetupUI
    func setupRefreshControl()  {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.getItemsAPICall), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //MARK: SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            filterList(searchText)
        } else {
            self.filteredItems = listItems
            tableView.reloadData()
        }
    }

    //MARK: IBActions
    @IBAction func doneBtnClicked(_ sender: UIButton) {
        let selectedItems = filteredItems.filter { (item) -> Bool in
            return item.selected
        }
        completionBlock(selectedItems)
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: TableView DataSource and Delegate
extension VListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        let item = filteredItems[indexPath.row]
        
        cell!.textLabel!.text = item.name
        if  item.selected {
            cell!.accessoryType = .checkmark
            item.selected = true
        } else {
            cell!.accessoryType = .none
            item.selected = false
        }
        return cell!
        
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filteredItems[indexPath.row]
        
        if enableMultipleChoice {
            item.selected = !item.selected
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            completionBlock([item])
            self.dismiss(animated: true, completion: nil)
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

}


extension VListViewController {
    func getItemsAPICall() {
        self.showCentralGraySpinner()
        wsCall.callAPI(withName: apiName) { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    if let objects = json as? [[String : Any]] {
                        for obj in objects {
                            let listItem = ListItem()
                            listItem.Id = RConverter.string(obj[self.keyForId])
                            listItem.name = RConverter.string(obj[self.keyForTitle])
                            listItem.obj = obj
                            if self.preSelectedIDs.contains(listItem.Id) {
                                listItem.selected = true
                            }
                            self.listItems.append(listItem)
                        }
                        self.filteredItems = self.listItems
                        self.tableView.reloadData()
                    }
                }
            } else {
                //
            }
            self.hideCentralGraySpinner()
        }
    }
}

//MARK: List Item to handle all type of item
class ListItem : Equatable {
    var Id: String = ""
    var name: String = ""
    var code: String! = ""
    var selected = false
    var obj: Any?
}
