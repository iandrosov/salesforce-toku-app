//
//  SmartStoreInterface.m
//  ToKu
//
//  Created by Igor Old MAC on 2/3/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import "SmartStoreInterface.h"
#import <SalesforceSDKCore/SFSmartStore.h>
#import <SalesforceSDKCore/SFSoupIndex.h>
#import <SalesforceSDKCore/SFQuerySpec.h>
#import <SalesforceCommonUtils/NSDictionary+SFAdditions.h>

NSString* const kUserSoupName = @"User";
NSString* const kContactSoupName = @"Contact";
NSString* const kAllUsersQuery = @"SELECT {User:Name}, {User:Id}, {User:FirstName}, {User:LastName}, {User:UserType}, {User:Title}, {User:Street}, {User:City}, {User:State}, {User:PostalCode}, {User:Country}, {User:Email}, {User:Phone}, {User:MobilePhone}, {User:IsActive}, {User:FullPhotoUrl}, {User:SmallPhotoUrl} FROM {User}";

NSString* const kAllContactsQuery = @"SELECT {Contact:Name}, {Contact:Id}, {Contact:OwnerId} FROM {Contact}";

NSString* const kAccountSoupName = @"Account";
NSString* const kOpportunitySoupName = @"Opportunity";
NSString* const kAllAccountsQuery = @"SELECT {Account:Name}, {Account:Id}, {Account:OwnerId} FROM {Account}";
NSString* const kAllOpportunitiesQuery = @"SELECT {Opportunity:Name}, {Opportunity:Id}, {Opportunity:AccountId}, {Opportunity:OwnerId}, {Opportunity:Amount} FROM {Opportunity}";
NSString* const kAggregateQueryStr = @"SELECT {Account:Name}, COUNT({Opportunity:Name}), SUM({Opportunity:Amount}), AVG({Opportunity:Amount}), {Account:Id}, {Opportunity:AccountId} FROM {Account}, {Opportunity} WHERE {Account:Id} = {Opportunity:AccountId} GROUP BY {Account:Name}";

@implementation SmartStoreInterface : NSObject

@synthesize store = _store;

- (id)init
{
    self = [super init];
    if (nil != self)  {
        
    }
    return self;
}

- (SFSmartStore *)store
{
    return [SFSmartStore sharedStoreWithName:kDefaultSmartStoreName];
}

- (void)createUsersSoup
{
    if (![self.store soupExists:kUserSoupName]) {
        NSArray *keys = @[@"path", @"type"];
        NSArray *nameValues = @[@"Name", kSoupIndexTypeString];
        NSDictionary *nameDictionary = [NSDictionary dictionaryWithObjects:nameValues forKeys:keys];
        NSArray *idValues = @[@"Id", kSoupIndexTypeString];
        NSDictionary *idDictionary = [NSDictionary dictionaryWithObjects:idValues forKeys:keys];
        NSArray *firstNameValues = @[@"FirstName", kSoupIndexTypeString];
        NSDictionary *firstNameDictionary = [NSDictionary dictionaryWithObjects:firstNameValues forKeys:keys];
        NSArray *lastNameValues = @[@"LastName", kSoupIndexTypeString];
        NSDictionary *lastNameDictionary = [NSDictionary dictionaryWithObjects:lastNameValues forKeys:keys];
        NSArray *typeValues = @[@"UserType", kSoupIndexTypeString];
        NSDictionary *typeDictionary = [NSDictionary dictionaryWithObjects:typeValues forKeys:keys];
        NSArray *titleValues = @[@"Title", kSoupIndexTypeString];
        NSDictionary *titleDictionary = [NSDictionary dictionaryWithObjects:titleValues forKeys:keys];
        NSArray *streetValues = @[@"Street", kSoupIndexTypeString];
        NSDictionary *streetDictionary = [NSDictionary dictionaryWithObjects:streetValues forKeys:keys];
        NSArray *cityValues = @[@"City", kSoupIndexTypeString];
        NSDictionary *cityDictionary = [NSDictionary dictionaryWithObjects:cityValues forKeys:keys];
        NSArray *stateValues = @[@"State", kSoupIndexTypeString];
        NSDictionary *stateDictionary = [NSDictionary dictionaryWithObjects:stateValues forKeys:keys];
        NSArray *postalCodeValues = @[@"PostalCode", kSoupIndexTypeString];
        NSDictionary *postalCodeDictionary = [NSDictionary dictionaryWithObjects:postalCodeValues forKeys:keys];
        NSArray *countryValues = @[@"Country", kSoupIndexTypeString];
        NSDictionary *countryDictionary = [NSDictionary dictionaryWithObjects:countryValues forKeys:keys];
        NSArray *emailValues = @[@"Email", kSoupIndexTypeString];
        NSDictionary *emailDictionary = [NSDictionary dictionaryWithObjects:emailValues forKeys:keys];
        NSArray *phoneValues = @[@"Phone", kSoupIndexTypeString];
        NSDictionary *phoneDictionary = [NSDictionary dictionaryWithObjects:phoneValues forKeys:keys];
        NSArray *mobilePhoneValues = @[@"MobilePhone", kSoupIndexTypeString];
        NSDictionary *mobilePhoneDictionary = [NSDictionary dictionaryWithObjects:mobilePhoneValues forKeys:keys];
        NSArray *activeValues = @[@"IsActive", kSoupIndexType];
        NSDictionary *activeDictionary = [NSDictionary dictionaryWithObjects:activeValues forKeys:keys];
        //NSArray *profileValues = @[@"ProfielId", kSoupIndexTypeString];
        //NSDictionary *profileDictionary = [NSDictionary dictionaryWithObjects:profileValues forKeys:keys];
        NSArray *fullPhotoValues = @[@"FullPhotoUrl", kSoupIndexTypeString];
        NSDictionary *fullPhotoDictionary = [NSDictionary dictionaryWithObjects:fullPhotoValues forKeys:keys];
        NSArray *smallPhotoValues = @[@"SmallPhotoUrl", kSoupIndexTypeString];
        NSDictionary *smallPhotoDictionary = [NSDictionary dictionaryWithObjects:smallPhotoValues forKeys:keys];
        
        NSArray *userIndexSpecs = [SFSoupIndex asArraySoupIndexes:@[nameDictionary, idDictionary, firstNameDictionary, lastNameDictionary, typeDictionary, titleDictionary, streetDictionary, cityDictionary, stateDictionary, postalCodeDictionary, countryDictionary, emailDictionary, phoneDictionary, mobilePhoneDictionary, activeDictionary, fullPhotoDictionary, smallPhotoDictionary]];
        [self.store registerSoup:kUserSoupName withIndexSpecs:userIndexSpecs];
    }
}

- (void)createContactsSoup
{
    if (![self.store soupExists:kContactSoupName]) {
        NSArray *keys = @[@"path", @"type"];
        NSArray *nameValues = @[@"Name", kSoupIndexTypeString];
        NSDictionary *nameDictionary = [NSDictionary dictionaryWithObjects:nameValues forKeys:keys];
        NSArray *idValues = @[@"Id", kSoupIndexTypeString];
        NSDictionary *idDictionary = [NSDictionary dictionaryWithObjects:idValues forKeys:keys];
        NSArray *ownerIdValues = @[@"OwnerId", kSoupIndexTypeString];
        NSDictionary *ownerIdDictionary = [NSDictionary dictionaryWithObjects:ownerIdValues forKeys:keys];
        NSArray *contactIndexSpecs = [SFSoupIndex asArraySoupIndexes:@[nameDictionary, idDictionary, ownerIdDictionary]];
        [self.store registerSoup:kContactSoupName withIndexSpecs:contactIndexSpecs];
    }
}

- (void)createAccountsSoup
{
    if (![self.store soupExists:kAccountSoupName]) {
        NSArray *keys = @[@"path", @"type"];
        NSArray *nameValues = @[@"Name", kSoupIndexTypeString];
        NSDictionary *nameDictionary = [NSDictionary dictionaryWithObjects:nameValues forKeys:keys];
        NSArray *idValues = @[@"Id", kSoupIndexTypeString];
        NSDictionary *idDictionary = [NSDictionary dictionaryWithObjects:idValues forKeys:keys];
        NSArray *ownerIdValues = @[@"OwnerId", kSoupIndexTypeString];
        NSDictionary *ownerIdDictionary = [NSDictionary dictionaryWithObjects:ownerIdValues forKeys:keys];
        NSArray *accountIndexSpecs = [SFSoupIndex asArraySoupIndexes:@[nameDictionary, idDictionary, ownerIdDictionary]];
        [self.store registerSoup:kAccountSoupName withIndexSpecs:accountIndexSpecs];
    }
}

- (void)createOpportunitiesSoup
{
    if (![self.store soupExists:kOpportunitySoupName]) {
        NSArray *keys = @[@"path", @"type"];
        NSArray *nameValues = @[@"Name", kSoupIndexTypeString];
        NSDictionary *nameDictionary = [NSDictionary dictionaryWithObjects:nameValues forKeys:keys];
        NSArray *idValues = @[@"Id", kSoupIndexTypeString];
        NSDictionary *idDictionary = [NSDictionary dictionaryWithObjects:idValues forKeys:keys];
        NSArray *accountIdValues = @[@"AccountId", kSoupIndexTypeString];
        NSDictionary *accountIdDictionary = [NSDictionary dictionaryWithObjects:accountIdValues forKeys:keys];
        NSArray *ownerIdValues = @[@"OwnerId", kSoupIndexTypeString];
        NSDictionary *ownerIdDictionary = [NSDictionary dictionaryWithObjects:ownerIdValues forKeys:keys];
        NSArray *amountValues = @[@"Amount", kSoupIndexTypeFloating];
        NSDictionary *amountDictionary = [NSDictionary dictionaryWithObjects:amountValues forKeys:keys];
        NSArray *opportunityIndexSpecs = [SFSoupIndex asArraySoupIndexes:@[nameDictionary, idDictionary, accountIdDictionary, ownerIdDictionary, amountDictionary]];
        [self.store registerSoup:kOpportunitySoupName withIndexSpecs:opportunityIndexSpecs];
    }
}

- (void)deleteUsersSoup
{
    if ([self.store soupExists:kUserSoupName]) {
        [self.store removeSoup:kUserSoupName];
    }
}

- (void)deleteContactsSoup
{
    if ([self.store soupExists:kContactSoupName]) {
        [self.store removeSoup:kContactSoupName];
    }
}

- (void)deleteAccountsSoup
{
    if ([self.store soupExists:kAccountSoupName]) {
        [self.store removeSoup:kAccountSoupName];
    }
}

- (void)deleteOpportunitiesSoup
{
    if ([self.store soupExists:kOpportunitySoupName]) {
        [self.store removeSoup:kOpportunitySoupName];
    }
}

- (void)insertUsers:(NSArray*)users
{
    if (nil != users) {
        for (int i = 0; i < users.count; i++) {
            [self insertUser:users[i]];
        }
    }
}

- (void)insertContacts:(NSArray*)contacts
{
    if (nil != contacts) {
        for (int i = 0; i < contacts.count; i++) {
            [self insertContact:contacts[i]];
        }
    }
}

- (void)insertAccounts:(NSArray*)accounts
{
    if (nil != accounts) {
        for (int i = 0; i < accounts.count; i++) {
            [self insertAccount:accounts[i]];
        }
    }
}

- (void)insertOpportunities:(NSArray*)opportunities
{
    if (nil != opportunities) {
        for (int i = 0; i < opportunities.count; i++) {
            [self insertOpportunity:opportunities[i]];
        }
    }
}

- (void)insertUser:(NSDictionary*)user
{
    if (nil != user) {
        [self.store upsertEntries:@[user] toSoup:kUserSoupName];
    }
}

- (void)insertContact:(NSDictionary*)contact
{
    if (nil != contact) {
        [self.store upsertEntries:@[contact] toSoup:kContactSoupName];
    }
}

- (void)insertAccount:(NSDictionary*)account
{
    if (nil != account) {
        [self.store upsertEntries:@[account] toSoup:kAccountSoupName];
    }
}

- (void)insertOpportunity:(NSDictionary*)opportunity
{
    if (nil != opportunity) {

        /*
         * SmartStore doesn't currently support default values
         * for indexed columns (0 for 'integer' or 'floating',
         * for instance. It stores the data as is. Hence, we need
         * to check the values for 'Amount' and replace 'null'
         * with '0', for aggregate queries such as 'sum' and
         * 'avg' to work properly.
         */
        NSMutableDictionary *mutableOpportunity = [NSMutableDictionary dictionaryWithDictionary:opportunity];
        double amount = 0;
        if (![mutableOpportunity nonNullObjectForKey:@"Amount"]) {
            mutableOpportunity[@"Amount"] = @(amount);
        }
        [self.store upsertEntries:@[mutableOpportunity] toSoup:kOpportunitySoupName];
    }
}

- (NSArray*)getUsers
{
    return [self query:kAllUsersQuery];
}

- (NSArray*)getContacts
{
    return [self query:kAllContactsQuery];
}

- (NSArray*)getAccounts
{
    return [self query:kAllAccountsQuery];
}

- (NSArray*)getOpportunities
{
    return [self query:kAllOpportunitiesQuery];
}

- (NSArray*)query:(NSString*)queryString
{
    SFQuerySpec *querySpec = [SFQuerySpec newSmartQuerySpec:queryString withPageSize:2000];
    //long count = [self.store countWithQuerySpec:querySpec error:nil];
    //querySpec = [SFQuerySpec newSmartQuerySpec:queryString withPageSize:count];
    return [self.store queryWithQuerySpec:querySpec pageIndex:0 error:nil];
}

@end
