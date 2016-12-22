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
        refreshControl.addTarget(self, action: #selector(self.getItemsAPICall), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //MARK: SearchBar Delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            filterList(searchText)
        } else {
            self.filteredItems = listItems
            tableView.reloadData()
        }
    }

    //MARK: IBActions
    @IBAction func doneBtnClicked(sender: UIButton) {
        let selectedItems = filteredItems.filter { (item) -> Bool in
            return item.selected
        }
        completionBlock(selectedItems)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelBtnTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

//MARK: TableView DataSource and Delegate
extension VListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        
        let item = filteredItems[indexPath.row]
        
        cell!.textLabel!.text = item.name
        if preSelectedIDs.contains(item.Id) || item.selected {
            cell!.accessoryType = .Checkmark
            item.selected = true
        } else {
            cell!.accessoryType = .None
            item.selected = false
        }
        return cell!
        
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
            self.dismissViewControllerAnimated(true, completion: nil)
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

}


extension VListViewController {
    func getItemsAPICall() {
        self.showCentralGraySpinner()
        wsCall.callAPI(withName: apiName) { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    if let objects = json as? [[String : AnyObject]] {
                        for obj in objects {
                            let listItem = ListItem()
                            listItem.Id = RConverter.string(obj[self.keyForId])
                            listItem.name = RConverter.string(obj[self.keyForTitle])
                            listItem.obj = obj
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
    var obj: AnyObject!
}
