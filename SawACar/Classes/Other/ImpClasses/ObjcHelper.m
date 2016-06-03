//
//  ObjcHelper.m
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 02/02/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

#import "ObjcHelper.h"
@import AddressBook;
@import UIKit;
static UserContact* usercontact;

#pragma mark - WildcardGestureRecognizer
@implementation UserContact

+ (instancetype)shared {
    if (!usercontact) {
        usercontact = [[UserContact alloc] init];
    }
    return usercontact;
}

- (void)fetchUserNameNumberEmails:(void (^)(NSArray <NSDictionary*> *))block {
    [self checkAuthorizationStatus:^(BOOL authorize, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (authorize) {
                block([self getNameNumberAndEmails]);
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Need Permission" message:@"In Order to find your friend we would need access to your contact" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                block(nil);
            }
        });
    }];
}

- (void)fetchUserNameEmails:(void (^)(NSArray <NSDictionary*> *))block {
    [self checkAuthorizationStatus:^(BOOL authorize, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (authorize) {
                block([self getNameAndEmails]);
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Need Permission" message:@"In Order to find your friend we would need access to your contact" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                block(nil);
            }
        });
    }];
}

- (void)fetchUserEmails:(void (^)(NSArray <NSString*> *))block {
    [self checkAuthorizationStatus:^(BOOL authorize, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (authorize) {
                block([self getAllEmails]);
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Need Permission" message:@"In Order to find your friend we would need access to your contact" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                block(nil);
            }
        });
    }];
}

- (void)fetchUserContacts:(void(^)(NSArray*))block {
    [self checkAuthorizationStatus:^(BOOL authorize, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (authorize) {
                block([self arrayofUserContacts]);
            } else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Need Permission" message:@"In Order to find your friend we would need access to your contact" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                block(nil);
            }
        });
    }];
}


- (NSArray*)arrayofUserContacts {
    
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    NSMutableArray *numbers = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        NSString *firstName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *fullname = @"No Name";
        if (firstName != nil && lastName != nil) {
            fullname = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
        } else if (firstName != nil) {
            fullname = firstName;
        } else if (lastName != nil) {
            fullname = lastName;
        }
        
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
            NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            if (error == nil ) {
                NSLog(@"Name: %@", fullname);
                NSLog(@"Number: %@", phoneNumber);
                [numbers addObject:@{ @"number": phoneNumber,
                                      @"name": fullname }];
            }
        }
        
        CFRelease(phoneNumbers);
    }
    
    // Added by jigar later
    CFRelease(allPeople);
    CFRelease(addressBook);
    return numbers.copy;
}

- (NSArray<NSDictionary*>*)getNameNumberAndEmails {
    
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    NSMutableArray *contacts = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        NSString *firstName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *fullname = @"No Name";
        if (firstName != nil && lastName != nil) {
            fullname = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
        } else if (firstName != nil) {
            fullname = firstName;
        } else if (lastName != nil) {
            fullname = lastName;
        }
        
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);

        NSString* email = @"";
        NSString *phoneNumber = @"";
        
        if (ABMultiValueGetCount(emails) > 0)
            email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, 0);
        if (ABMultiValueGetCount(phoneNumbers) > 0)
            phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
        
        if (![email isEqualToString:@""] || ![phoneNumber isEqualToString:@""]) {
            [contacts addObject:@{  @"email"  : email,
                                    @"number" : phoneNumber,
                                    @"name"   : fullname }];

        }
        
        CFRelease(emails);
        CFRelease(phoneNumbers);
    }
    
    // Added by jigar later
    CFRelease(allPeople);
    CFRelease(addressBook);
    return contacts.copy;
    
}


- (NSArray<NSDictionary*>*)getNameAndEmails {
    
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    NSMutableArray *contacts = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        NSString *firstName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge_transfer NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *fullname = @"No Name";
        if (firstName != nil && lastName != nil) {
            fullname = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
        } else if (firstName != nil) {
            fullname = firstName;
        } else if (lastName != nil) {
            fullname = lastName;
        }

        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
            NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, j);
            if (error == nil ) {
                [contacts addObject:@{ @"email"  : email,
                                       @"name"   : fullname }];
            }
        }
        
        
        
        CFRelease(emails);
    }
    
    // Added by jigar later
    CFRelease(allPeople);
    CFRelease(addressBook);
    return contacts.copy;
    
}

- (NSArray<NSString*>*)getAllEmails {
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *allEmails = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
    for (CFIndex i = 0; i < CFArrayGetCount(people); i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
            NSString* email = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emails, j);
            [allEmails addObject:email];
        }
        CFRelease(emails);
    }
    CFRelease(addressBook);
    CFRelease(people);
    return allEmails;
    
}


- (void)checkAuthorizationStatus:(void(^)(BOOL,NSError*))block
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                block(granted,(__bridge NSError*)error);
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
                block(granted,(__bridge NSError*)error);
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        block(YES,nil);
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
        block(NO,nil);
    }
    
    CFRelease(addressBookRef);
}

@end

