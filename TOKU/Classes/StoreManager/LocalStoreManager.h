//
//  LocalStoreManager.h
//  Appirian
//
//  Created by Igor Old MAC on 1/24/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFSmartStore.h"

#define CONTACT_SOUP @"CONTACT_SOUP"

@interface LocalStoreManager : NSObject

+ (NSArray*)getCantacts;
+ (BOOL)saveApplicationData:(NSArray*)records;
+ (BOOL)isDataExists;
+ (BOOL)isLocalDataExists;
+ (NSArray*)getCantactsModel;
@end
