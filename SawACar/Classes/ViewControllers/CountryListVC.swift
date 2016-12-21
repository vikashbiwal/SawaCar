//
//  ListVC.swift
//  SawACar
//  Created by Vikash Prajapati
//  Created by Yudiz Solutions Pvt. Ltd. on 12/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

enum LocationSelectionForType {
    case Nationality, Country, DialCodeAction
    case From, To
    case None
}

class CountryListVC: ParentVC {
    //MARK:
    var countries = [Country]()
    var filteredCountries = [Country]()
    var selectedCountryId: String?
    var titleString: String = "countries".localizedString()
    var refreshControl : UIRefreshControl!
    var completionBlock : (Country)-> Void = {_ in}
    
    //MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = titleString
        getCountriesWS()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: SetupUI
    func setupRefreshControl()  {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.getCountriesWS), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    //MARK: Other
    func filterList(text: String)  {
        let arr = countries.filter { (ct) -> Bool in
            return ct.name.hasPrefix(text)
        }
        self.filteredCountries = arr
        tableView.reloadData()
    }
    
}

//MARK: Conform Protocols
extension CountryListVC: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    //MARK: Tableview datasource and delgate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TVGenericeCell
        let country = filteredCountries[indexPath.row]
        cell.lblTitle.text = country.name
        if country.Id == selectedCountryId {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        
        let ct = filteredCountries[indexPath.row]
        completionBlock(ct)
        self.parentBackAction(nil)
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
            self.filteredCountries = countries
            tableView.reloadData()
        }
    }
}

//MARK: WS Calls
extension CountryListVC {
    func getCountriesWS()  {
        self.showCentralGraySpinner()
        wsCall.getActiveCountries { (response, statusCode) in
            if response.isSuccess  {
                if let arr = response.json as? [[String : AnyObject]] {
                    self.countries.removeAll()
                    for item in arr {
                        self.countries.append(Country(info: item))
                    }
                    self.filteredCountries = self.countries
                    self.tableView.reloadData()
                }
            } else {
                showToastMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
}
