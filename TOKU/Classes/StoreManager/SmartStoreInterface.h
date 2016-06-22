//
//  SmartStoreInterface.h
//  ToKu
//
//  Created by Igor Old MAC on 2/3/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFSmartStore;

extern NSString* const kAccountSoupName;
extern NSString* const kOpportunitySoupName;
extern NSString* const kAllAccountsQuery;
extern NSString* const kAllOpportunitiesQuery;
extern NSString* const kAggregateQueryStr;

extern NSString* const kUserSoupName;
extern NSString* const kContactSoupName;
extern NSString* const kAllUsersQuery;

@interface SmartStoreInterface : NSObject

@property (nonatomic, readonly) SFSmartStore *store;

- (void)createUsersSoup;
- (void)createContactsSoup;
- (void)deleteUsersSoup;
- (void)deleteContactsSoup;

/**
 * Creates a soup for accounts.
 */
- (void)createAccountsSoup;

/**
 * Creates a soup for opportunities.
 */
- (void)createOpportunitiesSoup;

/**
 * Deletes the accounts soup.
 */
- (void)deleteAccountsSoup;

/**
 * Deletes the opportunities soup.
 */
- (void)deleteOpportunitiesSoup;

/**
 * Inserts accounts into the accounts soup.
 */
- (void)insertAccounts:(NSArray*)accounts;

/**
 * Inserts opportunities into the opportunities soup.
 */
- (void)insertOpportunities:(NSArray*)opportunities;

/**
 * Inserts Users into the users soup.
 */
- (void)insertUsers:(NSArray*)users;

/**
 * Inserts a single account into the accounts soup.
 */
- (void)insertAccount:(NSDictionary*)account;

/**
 * Inserts a single opportunity into the opportunities soup.
 */
- (void)insertOpportunity:(NSDictionary*)opportunity;

/**
 * Returns saved accounts.
 */
- (NSArray*)getAccounts;

/**
 * Returns saved opportunities.
 */
- (NSArray*)getOpportunities;

/**
 * Runs a smart SQL query against the smartstore and returns results.
 */
- (NSArray*)query:(NSString*)queryString;

@end
