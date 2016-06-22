//
//  LocalStoreManager.m
//  Appirian
//
//  Created by Igor Old MAC on 1/24/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import "LocalStoreManager.h"
#import "SFQuerySpec.h"
#import "SmartStoreInterface.h"
#import "ContactModel.h"

@implementation LocalStoreManager

#pragma mark Metadata Store

+ (NSArray*)getCantactsModel {
    
    SmartStoreInterface *smartStoreIntf = [[SmartStoreInterface alloc] init];
    NSArray* dataRows = [smartStoreIntf query:kAllUsersQuery];
    NSMutableArray *model_list = [[NSMutableArray alloc] init];
    for (int i = 0; i < [dataRows count]; i++){
        ContactModel *contact = [[ContactModel alloc] init];
        [contact initWithArray:dataRows[i]];
        
        [model_list addObject:contact];
    }
    
    smartStoreIntf = nil;
    return model_list;
}

+ (NSArray*)getCantacts {
    
    [self isDataExists];
    
    // Search local store to initialize data
    NSMutableDictionary *queryDictionary = [[ NSMutableDictionary alloc] init];
    [queryDictionary setObject:@"range" forKey:@"queryType"];
    [queryDictionary setObject:@"Id" forKey:@"indexPath"];
    [queryDictionary setObject:@"ascending" forKey:@"order"];
    [queryDictionary setObject:[NSNumber numberWithInt:2000] forKey:@"pageSize"];

    // Init Smart Store
    SFSmartStore *gsi_store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];
    NSError *sferror = nil;
    SFQuerySpec *querySpec = [[SFQuerySpec alloc] initWithDictionary:queryDictionary withSoupName:CONTACT_SOUP];
    NSArray *results = [gsi_store queryWithQuerySpec:querySpec pageIndex:0 error:&sferror];
    return results;
}

+ (BOOL)saveApplicationData:(NSArray*)records {
    BOOL rc = FALSE;
    NSError *error = nil;
    // Init Smart Store
    SFSmartStore *gsi_store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];

    BOOL exists = [gsi_store soupExists:CONTACT_SOUP];
    
    // check if store exists and create it if not
    if(!exists) {
        
        NSMutableDictionary *columnIndex1 = [[NSMutableDictionary alloc] init];
        [columnIndex1 setObject:@"Id" forKey:@"path"];
        [columnIndex1 setObject:@"string" forKey:@"type"];
        [gsi_store registerSoup:CONTACT_SOUP withIndexSpecs:[NSArray arrayWithObjects:columnIndex1, nil]];
        
    }
    
    [gsi_store upsertEntries:records toSoup:CONTACT_SOUP withExternalIdPath:@"Id" error:&error];
    NSLog(@"Upsert contact info: %@", error);
    if(error == nil){
        rc = TRUE;
    }
    return rc;
}

+ (BOOL)isDataExists {
    
    // Init Smart Store
    SFSmartStore *gsi_store = [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];
    
    BOOL exists = [gsi_store soupExists:CONTACT_SOUP];
    
    // check if store exists and create it if not
    if(!exists) {
        
        NSMutableDictionary *columnIndex1 = [[NSMutableDictionary alloc] init];
        [columnIndex1 setObject:@"Id" forKey:@"path"];
        [columnIndex1 setObject:@"string" forKey:@"type"];
        [gsi_store registerSoup:CONTACT_SOUP withIndexSpecs:[NSArray arrayWithObjects:columnIndex1, nil]];
        
    }
    exists = [gsi_store soupExists:CONTACT_SOUP];
    return exists;
}

+ (BOOL)isLocalDataExists {
    BOOL exists = NO;
    SmartStoreInterface *smartStoreIntf = [[SmartStoreInterface alloc] init];
    NSArray* dataRows = [smartStoreIntf query:kAllUsersQuery];
    if(dataRows != nil && [dataRows count] > 0) {
        exists = YES;
    }
    return exists;
}

@end
