//
//  RawdataConverter.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 07/03/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit

class RConverter: NSObject {
    
    // MARK: Flinnt Object type
    class func date(timestamp: AnyObject?) -> NSDate {
        if let any:AnyObject = timestamp {
            if let str = any as? NSString {
                return NSDate(timeIntervalSince1970: str.doubleValue)
            } else if let str = any as? NSNumber {
                return NSDate(timeIntervalSince1970: str.doubleValue)
            }
        }
        return NSDate()
    }
    
    class func integer(anything: AnyObject?) -> Int {
        
        if let any:AnyObject = anything {
            if let num = any as? NSNumber {
                return num.integerValue
            } else if let str = any as? NSString {
                return str.integerValue
            }
        }
        return 0
        
    }
    
    class func double(anything: AnyObject?) -> Double {
        
        if let any:AnyObject = anything {
            if let num = any as? NSNumber {
                return num.doubleValue
            } else if let str = any as? NSString {
                return str.doubleValue
            }
        }
        return 0
        
    }
    
    class func float(anything: AnyObject?) -> Float {
        
        if let any:AnyObject = anything {
            if let num = any as? NSNumber {
                return num.floatValue
            } else if let str = any as? NSString {
                return str.floatValue
            }
        }
        return 0
        
    }
    
    class func string(anything: AnyObject?) -> String {
        
        if let any:AnyObject = anything {
            if let num = any as? NSNumber {
                return num.stringValue
            } else if let str = any as? String {
                return str
            }
        }
        return ""
        
    }
    
    class func optionalString(anything: AnyObject?) -> String? {
        
        if let any:AnyObject = anything {
            if let num = any as? NSNumber {
                return num.stringValue
            } else if let str = any as? String {
                return str
            }
        }
        return nil
        
    }
    
    class func boolean(anything: AnyObject?) -> Bool {
        
        if let any:AnyObject = anything {
            if let num = any as? NSNumber {
                return num.boolValue
            } else if let str = any as? NSString {
                return str.boolValue
            }
        }
        return false
    }


}


