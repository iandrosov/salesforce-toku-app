//
//  MemberLocation.m
//  Appirian
//
//  Created by Igor Old MAC on 1/20/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import "MemberLocation.h"
#import <AddressBook/AddressBook.h>

@interface MemberLocation ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end

@implementation MemberLocation

- (id)initWithName:(NSString*)name address:(NSString*)address resource:(NSString*)resource coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown charge";
        }
        self.address = address;
        self.isresource = resource;
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{@"City" : _address}; //kABPersonAddressCityKey kABPersonAddressStreetKey
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
