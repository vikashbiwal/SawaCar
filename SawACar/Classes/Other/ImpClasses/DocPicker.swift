//
//  DocPicker.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 21/03/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit

class DocPicker: NSObject, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    var pickerBlock: ((NSURL?) -> ())?
    weak var toController: UIViewController?
    
    static var shared = DocPicker()
    
    // Method to Pick Document from third party app and iCloud
    func pickDocumentFromStorage(toController: UIViewController, block: (NSURL?) -> ()) {
        pickerBlock = block
        self.toController = toController
        let testPicker : UIDocumentMenuViewController = UIDocumentMenuViewController(documentTypes: ["public.data"], inMode: .Import)
        testPicker.delegate = self
        testPicker.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        toController.presentViewController(testPicker, animated: true, completion: nil)
    }
    
    // Method to Export Document
    func shareDocumentFromApp(baseController: UIViewController, filePath: NSURL, block: ((NSURL?) -> ())){
        pickerBlock = block
        self.toController = baseController
        let docShareVC:UIDocumentMenuViewController = UIDocumentMenuViewController(URL: filePath, inMode: .ExportToService)
        docShareVC.delegate = self
        docShareVC.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        baseController.presentViewController(docShareVC, animated: true, completion: nil)
    }
    
    // MARK: - Document Menu Delegate Methods
    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController){
        documentPicker.delegate = self
        toController?.presentViewController(documentPicker, animated: true, completion: nil)
    }
    
    func documentMenuWasCancelled(documentMenu: UIDocumentMenuViewController){
        jprint("--- documentMenuWasCancelled ---")
        pickerBlock?(nil)
    }
    
    // MARK: - Document Picker Deleage Methods
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        jprint("--- documentPicker ---")
        jprint(url)
        pickerBlock?(url)
    }
    
    func documentPickerWasCancelled(controller: UIDocumentPickerViewController){
        jprint("--- documentPickerWasCancelled ---")
        pickerBlock?(nil)
    }
    
}
