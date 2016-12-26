////
////  CollectionExtension.swift
////  manup
////
////  Created by Yudiz Solutions Pvt. Ltd. on 18/03/16.
////  Copyright © 2016 The App Developers. All rights reserved.
////
//
//import UIKit
//
//// MARK: Dictionary
//extension Dictionary {
//    
//    func removeNullValues() -> Dictionary<String, Any> {
//        var adict = [String : Any]()
//        for (key,obj) in self {
//            if obj is NSNull {
//                // do nothing
//            } else {
//                adict[key as! String] = obj
//            }
//        }
//        return adict
//    }
//}
//
//extension Dictionary {
//    
//    func doubleValueForKey(_ key: String) -> Double {
//        
//        if let any: Any = self[key] {
//            if let number = any as? NSNumber{
//                return number.doubleValue
//            }else if let str = any as? NSString{
//                return str.doubleValue
//            }
//        }
//        return 0
//    }
//    
//    func floatValueForKey(_ key: String) -> Float{
//        
//        if let any: Any = self[key]{
//            if let number = any as? NSNumber{
//                return number.floatValue
//            }else if let str = any as? NSString{
//                return str.floatValue
//            }
//        }
//        return 0
//    }
//    
//    func intValueForKey(_ key: String) -> Int{
//        
//        if let any: Any = self[key]{
//            if let number = any as? NSNumber{
//                return number.intValue
//            }else if let str = any as? NSString{
//                return str.integerValue
//            }
//        }
//        return 0
//    }
//    
//    
//    func stringValueForKey(_ key: String) -> String {
//        
//        if let any: Any = self[key]{
//            if let number = any as? NSNumber{
//                return number.stringValue
//            }else if let str = any as? String{
//                return str
//            }
//        }
//        return ""
//    }
//    
//    func boolValueForKey(_ key: String) -> Bool {
//        
//        if let any:Any = self[key] {
//            if let num = any as? NSNumber {
//                return num.boolValue
//            } else if let str = any as? NSString {
//                return str.boolValue
//            }
//        }
//        return false
//    }
//}
//
//// MARK: - Array
//extension Array {
//    func offSetValue(_ idx: Int) -> Element  {
//        return self[idx % count]
//    }
//}
//
//
