//
//  InboxViewController.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 12/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class InboxViewController: ParentVC {

    @IBOutlet var searchBarTopSpace: NSLayoutConstraint!
    @IBOutlet var searchBox: UISearchBar!
    
    var inbox = [Message] ()
    var filteredInbox = [Message] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.getInboxMessageAPICall()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChatVCSegue" {
            let chatVC = segue.destination as! ChatingViewController
            chatVC.contact = (sender as! Message).contact
        }
    }
    
}

//MARK: IBActions
extension InboxViewController {
    
    @IBAction func searchIconBtnTapped(_ sender: UIButton) {
        searchBox.becomeFirstResponder()
        UIView.animate(withDuration: 0.3, animations: { 
            self.searchBarTopSpace.constant = 0
            self.view.layoutIfNeeded()
        }) 
    }
    
    @IBAction func newChatBtnTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "InboxToContactsSegue", sender: nil)
    }
}

//SearchBar delegatation
extension InboxViewController : UISearchBarDelegate {
   
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
        if text.isEmpty {
            filteredInbox = inbox
        } else {
            filteredInbox.removeAll()
             filteredInbox = inbox.filter({ (message) -> Bool in
                return message.senderName.contains(text)
            })
        }
        tableView.reloadData()
    }
}

//MARK: TableViewController

extension InboxViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredInbox.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! MessageCell
        let message  = filteredInbox[indexPath.row]
        cell.setInfo(forInbox: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 * _widthRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let message = inbox[indexPath.row]
        self.performSegue(withIdentifier: "toChatVCSegue", sender: message)
    }
    
}


//MARK: Web service calls
extension InboxViewController {
    //Get inbox messages api call
    
    func getInboxMessageAPICall() {
        
        self.showCentralGraySpinner()
        let params = ["UserID" : me.Id]
        wsCall.getInboxMessages(params) { (response, flag) in
            if response.isSuccess {
                if let json = response.json as? [String : Any] {
                    if let objects = json["Object"] as? [[String : Any]] {
                        self.inbox.removeAll()
                        for item in objects {
                            let message = Message(item)
                            self.inbox.append(message)
                        }
                        self.filteredInbox = self.inbox
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


//Message Cell
class MessageCell: TVGenericeCell {
    @IBOutlet var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //Set message info
    func setInfo(forInbox message: Message) {
        lblTitle.text = message.contact.name
        lblSubTitle.text = (message.senderId == me.Id ? "You : " : "") + message.text
        lblTime.text = message.dateString
        imgView.setImageWith(URL(string: message.contact.photo)!, placeholderImage: _userPlaceholderImage)
    }
    
    func setInfo(forMessage message: Message) {
        lblTitle.text = message.text
        //lblSubTitle.text = (message.senderId == me.Id ? "You : " : "") + message.text
        lblTime.text = dateFormator.stringFromDate(message.date, format: "hh:mm a")
    }

}


