//
//  ContactModel.h
//  Appirian
//
//  Created by Igor Old MAC on 1/21/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject {

    NSString *sfid;
    NSString *name;
    NSString *firstName;
    NSString *lastName;
    NSString *title;
    NSString *city;
    NSString *state;
    NSString *postalcode;
    NSString *country;
    NSString *email;
    NSString *phone;
    NSString *licenseType;
    NSString *smallPhotoURL;
    NSString *fullPhotoURL;
    NSString *token;
    
    NSString *address;
    BOOL isActive;
}

@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, copy) NSString *sfid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *postalcode;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *licenseType;
@property (nonatomic, copy) NSString *smallPhotoURL;
@property (nonatomic, copy) NSString *fullPhotoURL;
@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *address;

- (void)initWithDictionary:(NSDictionary *)obj;
- (void)initWithArray:(NSArray*)list;
@end
