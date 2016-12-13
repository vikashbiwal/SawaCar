//
//  ChatingViewController.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 12/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class ChatingViewController: ParentVC {
   
    @IBOutlet var txtComment: UITextView!
    @IBOutlet var lblCommentPlaceholder: UILabel!
    @IBOutlet var chatBoxBottomConstraint: NSLayoutConstraint!
    @IBOutlet var chatTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imgUserProfile: UIImageView!
    
    let messageBubbleTopBottomPadding: CGFloat = 7 + 7
    let messageLabelTopBottomPadding: CGFloat = 10 + 10
    
    let messageTextFont: UIFont = UIFont(name: "OpenSans", size: 14 * _widthRatio)!
    
    var contact: Contact!
    var messages = [[Message]]()
    var sectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        self.getMessagesWithOtherUser()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addObservations()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        _defaultCenter.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Prepare UI
    func prepareUI() {
        txtComment.layer.borderColor = UIColor.scHeaderColor().CGColor
        txtComment.layer.borderWidth = 1.0
        txtComment.layer.cornerRadius = 5
        txtComment.clipsToBounds = true
        
        lblTitle.text = contact.name
        imgUserProfile.setImageWithURL(NSURL(string: contact.photo)!, placeholderImage: _userPlaceholderImage)
        
    }

}

//MARK: IBActions
extension ChatingViewController {
    //Message send button clicked
    @IBAction func sendMessageBtnClicked(sender: UIButton) {
        //TODO - sent message api call
        let text = txtComment.text.trimmedString()
        if !text.isEmpty {
           self.sendMessage()
        }
        self.resetCommentBox(true)
        txtComment.resignFirstResponder()
    }

}

//MARK: TextViewDelegate functions
extension ChatingViewController : UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        let text = textView.text
        lblCommentPlaceholder.hidden = !text.isEmpty
        let contentHieght = textView.contentSize.height
        chatTextViewHeightConstraint.constant =  contentHieght > 250  ? 250 : (contentHieght + 10)
        //txtComment.contentOffset = CGPoint(x: 0, y: 0)
    }
    
}

//MARK: Notification setup and selectors
extension ChatingViewController {
    
    func addObservations() {
        //Add Keybaord observeration
        _defaultCenter.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        _defaultCenter.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Keyboard Notifications
    func keyboardWillShow(nf: NSNotification)  {
        let userinfo = nf.userInfo!
        if let keyboarFrame = (userinfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            //tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:keyboarFrame.size.height , right: 0)
            chatBoxBottomConstraint.constant = keyboarFrame.size.height
            self.view.layoutIfNeeded()
        }
        scrollToBottom()

    }
    
    func keyboardWillHide(nf: NSNotification)  {
        //Reset comment textview
        chatBoxBottomConstraint.constant = 0
        self.resetCommentBox()
        self.view.layoutIfNeeded()
    }
    
    //Reset comment box UI
    func resetCommentBox(onMessageSent: Bool = false) {
        let commentText = txtComment.text.trimmedString()
        if onMessageSent || commentText.isEmpty  {
            chatTextViewHeightConstraint.constant = 45
            txtComment.text = ""
            lblCommentPlaceholder.hidden = false
        }
        scrollToBottom()
    }

}

//MARK: TableView DataSource
extension ChatingViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let message = messages[indexPath.section][indexPath.row]
        if message.senderId == me.Id {
            let cell = tableView.dequeueReusableCellWithIdentifier("senderCell") as! MessageCell
            cell.setInfo(forMessage: message)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("receiverCell") as! MessageCell
            cell.setInfo(forMessage: message)
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message = messages[indexPath.section][indexPath.row]
       
        let lable = UILabel()
        lable.font = messageTextFont
        lable.numberOfLines = 0
        var lblFrame = lable.frame
        
        lblFrame.size.width = 240
        lable.frame = lblFrame
        lable.text = message.text
        lable.sizeToFit()
        
        let cellHeight = lable.frame.size.height + messageLabelTopBottomPadding + messageBubbleTopBottomPadding
        return cellHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 * _widthRatio
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! TVGenericeCell
        cell.lblTitle.text = sectionTitles[section]
        return cell.contentView
    }
    
    func scrollToBottom() {
        let lastSection = tableView.numberOfSections - 1
        if lastSection >= 0 {
            let lastIndex = tableView.numberOfRowsInSection(lastSection) - 1
            if lastIndex >= 0 {
                let lastIndexPath = NSIndexPath(forItem: lastIndex, inSection: lastSection)
                tableView.scrollToRowAtIndexPath(lastIndexPath, atScrollPosition: .Bottom, animated: false)
            }
        }
    }
    
}

//MARK: Webservice calls
extension ChatingViewController {
    
    func getMessagesWithOtherUser() {
        let params = ["UserID" : me.Id, "OtherUserID" : contact.contactUserId, "Count" : "50" , "Page" : "1"]
        wsCall.getMessageWithOtherUser(params) { (response, flag) in
            if response.isSuccess {
                
                if let json = response.json {
                    if let objects = json["Object"] as? [[String : AnyObject]] {
                        var messages = [Message]()
                        for item in objects {
                            let message = Message(item)
                            messages.append(message)
                        }
                        self.sortMessagesDateWise(messages)
                        
                    }
                }
                
            } else  {
                //error
            }
        }
    }
    
    //Send Message Api call
    func sendMessage() {
        //self.showCentralGraySpinner()
        let params = ["UserFromID" : me.Id, "UserToID" : contact.contactUserId, "Text" : txtComment.text]
        wsCall.sendMessage(params) { (response, flag) in
            if response.isSuccess {
                if let json = response.json {
                    if let jMessage = json["Object"] as? [String : AnyObject] {
                        let message = Message(jMessage)
                        self.addMessageInSection(message)
                    }
                }
            } else {
                
            }
            //self.hideCentralGraySpinner()
        }
    }
    
    //add new message in section array
    func addMessageInSection(message: Message) {
        let messageDateString = dateFormator.stringFromDate(message.date, format: "dd/MM/yyyy")
        
        if let lastSctionDateString = sectionTitles.last {
            if lastSctionDateString == messageDateString {
                var lastSectionItems = messages[sectionTitles.count - 1]
                lastSectionItems.append(message)
                messages[sectionTitles.count - 1] = lastSectionItems
                
            } else {
                sectionTitles.append(messageDateString)
                let messageArray = [message]
                self.messages.append(messageArray)
            }
        } else {
            sectionTitles.append(messageDateString)
            let messageArray = [message]
            self.messages.append(messageArray)
        }
        
        self.tableView.reloadData()
    }
    
    //Sorting messages and create section as date wise.
    func sortMessagesDateWise(messages : [Message]) {
        //sort all messages in ascending order
        let sortedItems = messages.sort { (message1, message2) -> Bool in
            let result = message1.date.compare(message2.date)
            if result == .OrderedAscending || result == .OrderedSame {
                return true
            } else {
                return false
            }
        }
        
        //Create sections
        var sections = [String]()
        for item in sortedItems {
            let strDate = dateFormator.stringFromDate(item.date, format: "dd/MM/yyyy")
            if !sections.contains(strDate) {
                sections.append(strDate)
            }
        }
        
        //
        var sectionedItems = Array(count: sections.count, repeatedValue: [Message]())
        //Add items in sections
        
        for i in 0..<sections.count {
        let sectionDate = sections[i]
        var sectionItem = sectionedItems[i]
            for item in sortedItems {
                let strDate = dateFormator.stringFromDate(item.date, format: "dd/MM/yyyy")
                if sectionDate == strDate {
                   sectionItem.append(item)
                }
            }
            sectionedItems[i] = sectionItem
        }
        self.messages = sectionedItems
        self.sectionTitles = sections
        self.tableView.reloadData()
        self.scrollToBottom()
    }
}

