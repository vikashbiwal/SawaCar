//
//  Comment.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 30/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

//MARK: Message class
class Message : NSObject {
    var messageId:      String!
    var senderId:       String!
    var senderName:     String!
    var senderPhoto:    String!
    var receiverId:     String!
    var receiverName:   String!
    var receiverPhoto:  String!
    var text:           String!
    var dateString:     String!
    var date:    NSDate!
    var contact: Contact!
    
    
    init(_ info: [String: AnyObject]) {
        messageId   = RConverter.string(info["MessageID"])
        senderId    = RConverter.string(info["UserFromID"])
        senderName  = RConverter.string(info["UserFromName"])
        senderPhoto = kWSDomainURL + RConverter.string(info["UserFromPhoto"])
        receiverId  = RConverter.string(info["UserToID"])
        receiverName  = RConverter.string(info["UserToName"])
        receiverPhoto = kWSDomainURL +  RConverter.string(info["UserToPhoto"])
        text          = RConverter.string(info["Text"])
        dateString   = RConverter.string(info["MessageDate"])
        contact = Contact(fromMessage: info)
        date = dateFormator.dateFromString(dateString, fomat: "dd/MM/yyyy HH:mm:ss")!
    }
}


//MARK: Contact Class
class Contact: NSObject {
    
    var id: String!
    var userId: String!
    var contactUserId: String!
    var name: String!
    var photo: String!
    var detail: String!
    
    //Create contact from contact object get through json response
    init(fromContact info: [String : AnyObject]) {
        id      = RConverter.string(info["ContactID"])
        userId  = RConverter.string(info["UserID"])
        contactUserId = RConverter.string(info["UserContactID"])
        name    = RConverter.string(info["ContactName"])
        photo   = kWSDomainURL + RConverter.string(info["ContactPhoto"])
        detail  = RConverter.string(info["ContactDetails"])
    }
    
    //Create contact from message object get through json response
    init(fromMessage info: [String : AnyObject]) {
        //inbox object does not have contact info separately in it, thats why i(Vikash) have create contact from message info.
        
        let contactId = RConverter.string(info["UserFromID"])
        if contactId == me.Id {
            id      = RConverter.string(info[""])
            userId  = RConverter.string(info["UserFromID"])
            contactUserId = RConverter.string(info["UserToID"])
            name    = RConverter.string(info["UserToName"])
            photo   = kWSDomainURL + RConverter.string(info["UserToPhoto"])
        } else {
            id      = RConverter.string(info[""])
            userId  = RConverter.string(info["UserToID"])
            contactUserId = RConverter.string(info["UserFromID"])
            name    = RConverter.string(info["UserFromName"])
            photo   = kWSDomainURL + RConverter.string(info["UserFromPhoto"])
        }
        detail  = RConverter.string(info[""])
    }

}

