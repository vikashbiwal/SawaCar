//
//  Comment.swift
//  SawACar
//
//  Created by Yudiz Solutions Pvt. Ltd. on 30/11/16.
//  Copyright © 2016 Yudiz Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

//MARK: Message class
class Message {
    var messageId:      String!
    var senderId:       String!
    var senderName:     String!
    var senderPhoto:    String!
    var receiverId:     String!
    var receiverName:   String!
    var receiverPhoto:  String!
    var dateString:    String!
    var text : String!
    
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
    
    init(_ info: [String : AnyObject]) {
        id      = RConverter.string(info["ContactID"])
        userId  = RConverter.string(info["UserID"])
        contactUserId = RConverter.string(info["UserContactID"])
        name    = RConverter.string(info["ContactName"])
        photo   = kWSDomainURL + RConverter.string(info["ContactPhoto"])
        detail  = RConverter.string(info["ContactDetails"])
    }
}

