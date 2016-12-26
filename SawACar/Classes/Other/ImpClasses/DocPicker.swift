//
//  DocPicker.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 21/03/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit

class DocPicker: NSObject, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    var pickerBlock: ((URL?) -> ())?
    weak var toController: UIViewController?
    
    static var shared = DocPicker()
    
    // Method to Pick Document from third party app and iCloud
    func pickDocumentFromStorage(_ toController: UIViewController, block: @escaping (URL?) -> ()) {
        pickerBlock = block
        self.toController = toController
        let testPicker : UIDocumentMenuViewController = UIDocumentMenuViewController(documentTypes: ["public.data"], in: .import)
        testPicker.delegate = self
        testPicker.modalPresentationStyle = UIModalPresentationStyle.formSheet
        toController.present(testPicker, animated: true, completion: nil)
    }
    
    // Method to Export Document
    func shareDocumentFromApp(_ baseController: UIViewController, filePath: URL, block: @escaping ((URL?) -> ())){
        pickerBlock = block
        self.toController = baseController
        let docShareVC:UIDocumentMenuViewController = UIDocumentMenuViewController(url: filePath, in: .exportToService)
        docShareVC.delegate = self
        docShareVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        baseController.present(docShareVC, animated: true, completion: nil)
    }
    
    // MARK: - Document Menu Delegate Methods
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController){
        documentPicker.delegate = self
        toController?.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentMenuWasCancelled(_ documentMenu: UIDocumentMenuViewController){
        jprint("--- documentMenuWasCancelled ---")
        pickerBlock?(nil)
    }
    
    // MARK: - Document Picker Deleage Methods
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        jprint("--- documentPicker ---")
        jprint(url)
        pickerBlock?(url)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController){
        jprint("--- documentPickerWasCancelled ---")
        pickerBlock?(nil)
    }
    
}
