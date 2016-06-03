//
//  ObjcHelper.h
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 02/02/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - UserContact
@interface UserContact: NSObject

+ (instancetype)shared;
- (void)fetchUserContacts:(void(^)(NSArray*))block;
- (void)checkAuthorizationStatus:(void(^)(BOOL,NSError*))block;
- (void)fetchUserEmails:(void(^)(NSArray <NSString*> *))block;
- (void)fetchUserNameEmails:(void (^)(NSArray <NSDictionary*> *))block;
- (void)fetchUserNameNumberEmails:(void (^)(NSArray <NSDictionary*> *))block;

@end
