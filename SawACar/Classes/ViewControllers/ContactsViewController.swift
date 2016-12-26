//
//  ContactsViewController.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 12/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class ContactsViewController: ParentVC {
    @IBOutlet var searchBarTopSpace: NSLayoutConstraint!
    @IBOutlet var searchBox: UISearchBar!
    
    var contacts = [Contact] ()
    var sortedContacts = [[Contact]] ()
    var sectionTitles = [String]()
    
    //property used for partitioned array in sections
    let indexedCollation = UILocalizedIndexedCollation.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.getContactsAPICall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sort contacts section wise
    func sortContacts(_ contacts: [Contact]) {
        let (resultContacts, resultSectionTitls) = indexedCollation.partitionObjects(contacts, collationStringSelector: #selector(getter: Contact.name))
        self.sortedContacts = resultContacts as! [[Contact]]
        self.sectionTitles = resultSectionTitls
    }
}


//MARK: IBActions
extension ContactsViewController {
    
    @IBAction func searchIconBtnTapped(_ sender: UIButton) {
        searchBox.becomeFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBarTopSpace.constant = 0
            self.view.layoutIfNeeded()
        }) 
    }
    
}

//SearchBar delegatation
extension ContactsViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBox.resignFirstResponder()
        searchBar.showsCancelButton = false
        UIView.animate(withDuration: 0.3, animations: {
            self.searchBarTopSpace.constant = -44
            self.view.layoutIfNeeded()
        }) 
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.trimmedString()
       var filterContacts = [Contact]()
        if text.isEmpty {
            filterContacts = self.contacts
            
        } else {
            filterContacts = contacts.filter({ (message) -> Bool in
                return message.name.contains(text)
            })
        }
        self.sortContacts(filterContacts)
        self.tableView.reloadData()
    }
}

//MARK: TableViewController

extension ContactsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedContacts[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! TVGenericeCell
        let contact  = sortedContacts[indexPath.section][indexPath.row]
        cell.lblTitle.text = contact.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 * _widthRatio
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 * _widthRatio
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! TVGenericeCell
        cell.lblTitle.text = sectionTitles[section]
        cell.contentView.backgroundColor = UIColor.white
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


//MARK: Web service calls
extension ContactsViewController {
    //Get inbox messages api call
    func getContactsAPICall() {
        self.showCentralGraySpinner()
        let params = ["UserID" : me.Id]
        wsCall.getContacts(params) { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let objects = json["Object"] as? [[String : Any]] {
                        self.contacts.removeAll()
                        for item in objects {
                            let message = Contact(fromContact: item)
                            self.contacts.append(message)
                        }
                        self.sortContacts(self.contacts)
                        self.tableView.reloadData()
                    }
                }
                
            } else {
                showToastErrorMessage("", message: response.message)
            }
            self.hideCentralGraySpinner()
        }
    }
}
