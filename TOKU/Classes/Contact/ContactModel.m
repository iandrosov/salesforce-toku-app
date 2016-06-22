//
//  ContactModel.m
//  Appirian
//
//  Created by Igor Old MAC on 1/21/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

@synthesize sfid;
@synthesize firstName;
@synthesize name;
@synthesize postalcode;
@synthesize email;
@synthesize address;
@synthesize state;
@synthesize token;
@synthesize fullPhotoURL;
@synthesize title;
@synthesize city;
@synthesize smallPhotoURL;
@synthesize lastName;
@synthesize country;
@synthesize phone;
@synthesize isActive;
@synthesize licenseType;

- (void)initWithDictionary:(NSDictionary *)obj {
    /*
    self.name       = [obj objectForKey:@"Name"];
    self.firstName  = [obj objectForKey:@"FirstName"];
    self.lastName   = [obj objectForKey:@"LastName"];
    self.city       = [obj objectForKey:@"MailingCity"];
    self.state      = [obj objectForKey:@"MailingState"];
    self.postalcode = [obj objectForKey:@"MailingPostalCode"];
    self.country    = [obj objectForKey:@"MailingCountry"];
    self.title      = [obj objectForKey:@"Title"];
    self.email      = [obj objectForKey:@"Email"];
    self.phone      = [obj objectForKey:@"MobilePhone"];
    */
    
    self.sfid       = [obj objectForKey:@"Id"];
    self.name       = [obj objectForKey:@"Name"];
    self.firstName  = [obj objectForKey:@"FirstName"];
    self.lastName   = [obj objectForKey:@"LastName"];
    self.city       = [obj objectForKey:@"City"];
    self.state      = [obj objectForKey:@"State"];
    self.postalcode = [obj objectForKey:@"PostalCode"];
    self.country    = [obj objectForKey:@"Country"];
    self.title      = [obj objectForKey:@"Title"];
    self.email      = [obj objectForKey:@"Email"];
    self.phone      = [obj objectForKey:@"MobilePhone"];
    
    self.fullPhotoURL = [obj objectForKey:@"FullPhotoUrl"];
    
    self.address = @"";
    
    if (self.city && self.state && self.postalcode && self.country){
        self.address = [NSString stringWithFormat:@"%@,%@,%@,%@", self.city,self.state,self.postalcode,self.country];
    }
    
    NSString *active = [obj objectForKey:@"IsActive"];
    if ([active isKindOfClass:[NSString class]] && [active length] > 0) {
        if ([active isEqualToString:@"1"]) { // 1 - TRUE 0 - FALSE retunred by service
            self.isActive = YES;
        }else{
            self.isActive = NO;
        }
    }else{
        // Possible BOOL value transmitted  instead of String
        self.isActive = [[obj objectForKey:@"IsActive"] boolValue];
    }

    
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *md = [[NSMutableDictionary alloc] init];
    
    
    return md;
}

- (void)initWithArray:(NSArray*)list
{
    if(list){
        for (int i = 0; i < [list count]; i++){
            NSString *active = @"1";
            
            switch (i) {
                case 0:
                    //Name
                    self.name = list[i];
                    break;
                case 1:
                    // Id
                    self.sfid = list[i];
                    break;
                case 2:
                    // First Name
                    self.firstName = list[i];
                    break;
                case 3:
                    // Last Name
                    self.lastName = list[i];
                    break;
                case 4:
                    // License
                    self.licenseType = list[i];
                    break;
                case 5:
                    // Title
                    self.title = list[i];
                    break;
                case 6:
                    // Sreet
                    //self.street = list[i];
                    break;
                case 7:
                    // City
                    self.city = list[i];
                    break;
                case 8:
                    // State
                    self.state = list[i];
                    break;
                case 9:
                    // postal Code
                    self.postalcode = list[i];
                    break;
                case 10:
                    // Country
                    self.country = list[i];
                    break;
                case 11:
                    // Email
                    self.email = list[i];
                    break;
                case 12:
                    // Phone
                    self.phone = list[i];
                    break;
                case 13:
                    // mobile
                    self.phone = list[i];
                    break;
                case 14:
                    // isActive
                    active = list[i];
                    if ([active isKindOfClass:[NSString class]] && [active length] > 0) {
                        if ([active isEqualToString:@"1"]) { // 1 - TRUE 0 - FALSE retunred by service
                            self.isActive = YES;
                        }else{
                            self.isActive = NO;
                        }
                    }
                    
                    break;
                case 15:
                    // Full Photo
                    self.fullPhotoURL = list[i];
                    break;
                case 16:
                    // Small Photo
                    self.smallPhotoURL = list[i];
                    break;
                    
                default:
                    break;
            }
        }
        
        if (self.city && self.state && self.postalcode && self.country){
            self.address = [NSString stringWithFormat:@"%@,%@,%@,%@", self.city,self.state,self.postalcode,self.country];
        }

    }
}

@end
