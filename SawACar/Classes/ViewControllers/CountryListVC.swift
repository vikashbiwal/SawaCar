//
//  ListVC.swift
//  SawACar
//  Created by Vikash Prajapati
//  Created by Yudiz Solutions Pvt. Ltd. on 12/04/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

enum LocationSelectionForType {
    case nationality, country, dialCodeAction
    case from, to
    case none
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
        refreshControl.addTarget(self, action: #selector(self.getCountriesWS), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    //MARK: Other
    func filterList(_ text: String)  {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TVGenericeCell
        let country = filteredCountries[indexPath.row]
        cell.lblTitle.text = country.name
        if country.Id == selectedCountryId {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        let ct = filteredCountries[indexPath.row]
        completionBlock(ct)
        self.parentBackAction(nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    //MARK: SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
