//
//  JPUtility.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 18/03/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit


class JPUtility: NSObject {
    
    static let shared = JPUtility()
    
    func agoStringFromTime(_ date: Date) -> String {
        var timeScale = [String : Int]()
        timeScale["sec"] = 1
        timeScale["min"] = 60
        timeScale["hour"] = 3600
        timeScale["day"] = 86400
        timeScale["week"] = 605800
        timeScale["month"] = 2629743
        timeScale["year"] = 31556926
        var scale : String!
        let timeAgo = -1 * date.timeIntervalSinceNow
        if timeAgo < 60 {
            scale = "sec"
        } else if timeAgo < 3600 {
            scale = "min"
        } else if timeAgo < 86400 {
            scale = "hour"
        } else if timeAgo < 605800 {
            scale = "day"
        } else if timeAgo < 2629743 {
            scale = "week"
        } else if timeAgo < 31556926 {
            scale = "month"
        } else {
            scale = "year"
        }
        let ago = Int(timeAgo) / timeScale[scale]!
        var s = ""
        if ago > 1 {
            s = "s"
        }
        return "\(ago) \(scale)\(s)"
    }
}



/*
static NSString* agoStringFromTime(NSDate* dateTime)
{
    NSDictionary *timeScale = @{@"sec"  :@1,
        @"min"  :@60,
        @"hr"   :@3600,
        @"day"  :@86400,
        @"week" :@605800,
        @"month":@2629743,
        @"year" :@31556926};
    NSString *scale;
    int timeAgo = 0-(int)[dateTime timeIntervalSinceNow];
    if (timeAgo < 60) {
        scale = @"sec";
    } else if (timeAgo < 3600) {
        scale = @"min";
    } else if (timeAgo < 86400) {
        scale = @"hr";
    } else if (timeAgo < 605800) {
        scale = @"day";
    } else if (timeAgo < 2629743) {
        scale = @"week";
    } else if (timeAgo < 31556926) {
        scale = @"month";
    } else {
        scale = @"year";
    }
    
    timeAgo = timeAgo/[[timeScale objectForKey:scale] integerValue];
    NSString *s = @"";
    if (timeAgo > 1) {
        s = @"s";
    }
    
    return [NSString stringWithFormat:@"%d %@%@", timeAgo, scale, s];
}
*/



