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
    let indexedCollation = UILocalizedIndexedCollation.currentCollation()
    
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
    func sortContacts(contacts: [Contact]) {
        let (resultContacts, resultSectionTitls) = indexedCollation.partitionObjects(contacts, collationStringSelector: Selector("name"))
        self.sortedContacts = resultContacts as! [[Contact]]
        self.sectionTitles = resultSectionTitls
    }
}


//MARK: IBActions
extension ContactsViewController {
    
    @IBAction func searchIconBtnTapped(sender: UIButton) {
        searchBox.becomeFirstResponder()
        UIView.animateWithDuration(0.3) {
            self.searchBarTopSpace.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
}

//SearchBar delegatation
extension ContactsViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBox.resignFirstResponder()
        searchBar.showsCancelButton = false
        UIView.animateWithDuration(0.3) {
            self.searchBarTopSpace.constant = -44
            self.view.layoutIfNeeded()
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedContacts[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell") as! TVGenericeCell
        let contact  = sortedContacts[indexPath.section][indexPath.row]
        cell.lblTitle.text = contact.name
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70 * _widthRatio
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 * _widthRatio
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TVGenericeCell
        cell.lblTitle.text = sectionTitles[section]
        cell.contentView.backgroundColor = UIColor.whiteColor()
        return cell.contentView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
                if let json = response.json {
                    if let objects = json["Object"] as? [[String : AnyObject]] {
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
                showToastErrorMessage("", message: response.message!)
            }
            self.hideCentralGraySpinner()
        }
    }
}
