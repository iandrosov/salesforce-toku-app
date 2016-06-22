//
//  MemberLocation.h
//  Appirian
//
//  Created by Igor Old MAC on 1/20/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#include <AddressBook/ABAddressBook.h>
#include <AddressBook/ABPerson.h>
#import "ContactModel.h"

@interface MemberLocation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *isresource;
@property (nonatomic, strong) ContactModel *contact;

- (id)initWithName:(NSString*)name address:(NSString*)address resource:(NSString*)resource coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
