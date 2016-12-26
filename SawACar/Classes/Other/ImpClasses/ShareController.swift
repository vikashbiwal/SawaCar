//
//  ShareController.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 28/03/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit
import MessageUI

class ShareController: NSObject, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    static var shared = ShareController()
    
    var completionBlock: ((SendStatus) -> ())?
    enum SendStatus: Int {
        case sent
        case cancelled
        case failed
        case notSupported
        case saved
    }

    func sendMessageToRecipients(_ numbers: [String], messages: [String], toController: UIViewController, block:@escaping (SendStatus)->()) {
        guard MFMessageComposeViewController.canSendText() else {
            block(.notSupported)
            return
        }
        MFMessageComposeViewController.canSendText()
        completionBlock = block
        let msgController = MFMessageComposeViewController()
        msgController.subject = messages[0]
        msgController.body = messages[1]
        msgController.recipients = numbers
        msgController.messageComposeDelegate = self
        toController.present(msgController, animated: true, completion: nil)
    }
    
    func sendMailToRecipients(_ emails: [String], messages: [String], toController: UIViewController, block:@escaping (SendStatus)->()) {
        guard MFMailComposeViewController.canSendMail() else {
            block(.notSupported)
            return
        }
        completionBlock = block
        let mailController = MFMailComposeViewController()
        mailController.setSubject(messages[0])
        mailController.setMessageBody(messages[1], isHTML: false)
        mailController.setToRecipients(emails)
        mailController.mailComposeDelegate = self
        toController.present(mailController, animated: true, completion: nil)
    }
    
    // MARK: MFMessageComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        switch result {
        case .sent:
            completionBlock?(.sent)
        case .cancelled:
            completionBlock?(.cancelled)
        case .failed:
            completionBlock?(.failed)
        default:
            completionBlock?(.notSupported)
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        switch result {
        case .sent:
            completionBlock?(.sent)
        case .cancelled:
            completionBlock?(.cancelled)
        case .failed:
            completionBlock?(.failed)
        case .saved:
            completionBlock?(.saved)
        default:
            completionBlock?(.notSupported)
        }
    }

}

// Typical Example
/*
 
ShareController.shared.sendMessageToRecipients(numbers, messages: ["Cool APP","APP URL"], toController: self, block: { (status) in
    var statusAlert: (msg:String?, popupType: String?)
    switch status {
    case .Sent:
        statusAlert.msg = "Invitation\nSent"
        statusAlert.popupType = "Splash"
    case .Cancelled:
        statusAlert.msg = "Invitation\nCancelled"
        statusAlert.popupType = "Splash"
    case .Failed:
        statusAlert.msg = "Invitation\nFailed"
        statusAlert.popupType = "Splash"
    default:
        statusAlert.msg = "Not Supported"
        statusAlert.popupType = "Bar"
    }
    if statusAlert.popupType! == "Bar" {
        ValidationToast.showBarMessage(statusAlert.msg!, inView: self.view)
    } else {
        Alert.instanceWithMessageFromNib(statusAlert.msg!, alertType: Alert.AlertType.Negative, automaticallyAnimateOut: true)
}

ShareController.shared.sendMailToRecipients([self.contactUsers[sender.tag].email], messages: ["Cool APP","APP URL"], toController: self, block: { (status) in
    var statusAlert: (msg:String?, popupType: String?)
    switch status {
    case .Sent:
        statusAlert.msg = "Message\nSent"
        statusAlert.popupType = "Splash"
    case .Cancelled:
        statusAlert.msg = "Message\nCancelled"
        statusAlert.popupType = "Splash"
    case .Failed:
        statusAlert.msg = "Message\nFailed"
        statusAlert.popupType = "Splash"
    case .Saved:
        statusAlert.msg = "Message\nSaved"
        statusAlert.popupType = "Splash"
    default:
        statusAlert.msg = "Not Supported"
        statusAlert.popupType = "Bar"
    }
    if statusAlert.popupType! == "Bar" {
        ValidationToast.showBarMessage(statusAlert.msg!, inView: self.view)
    } else {
        Alert.instanceWithMessageFromNib(statusAlert.msg!, alertType: Alert.AlertType.Negative, automaticallyAnimateOut: true)
    }
})

*/
