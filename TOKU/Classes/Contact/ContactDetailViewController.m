//
//  ContactDetailViewController.m
//  Appirian
//
//  Created by Igor Old MAC on 1/22/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "SFRestAPI.h"
#import "SFAuthenticationManager.h"
#import "AttributesFacade.h"
#import "CommonUtil.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Reachability.h"

@interface ContactDetailViewController ()

@end

//static const CGSize imageSize = {200, 200};

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"MSG.TITLE.Contact",@"Contact");
    if([self.contact.name isKindOfClass:[NSNull class]]){
        self.name.text = @" ";
    }else{
        self.name.text = self.contact.name;
    }
    if([self.contact.address isKindOfClass:[NSNull class]]){
        self.address.text = @" ";
    }else{
        self.address.text = self.contact.address;
    }
    if([self.contact.title isKindOfClass:[NSNull class]]){
        self.ctitle.text = @" ";
    }else{
        self.ctitle.text = self.contact.title;
    }
    if ([self.contact.email isKindOfClass:[NSString class]] && [self.contact.email length] > 0){
        [self.emailButton setTitle:self.contact.email forState:UIControlStateNormal];
        [self.emailButton setEnabled:YES];
    }else{
        //disable button
        [self.emailButton setEnabled:NO];
        self.emailButton.backgroundColor = [UIColor grayColor];
    }
    if ([self.contact.phone isKindOfClass:[NSString class]] && [self.contact.phone length] > 0){
        [self.phoneButton setTitle:self.contact.phone forState:UIControlStateNormal];
        [self.phoneButton setEnabled:YES];
    }else{
        [self.phoneButton setEnabled:NO];
        self.phoneButton.backgroundColor = [UIColor grayColor];
    }
    
    self.photo.image = [self getScaleSizedImage:[self getUserImage]];
    //[self imageWithImage:img scaledToSize:imageSize];
    
    self.view.backgroundColor = [AttributesFacade contanerBackgroundColor];
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)sendEmail:(id)sender {
    
    NSString *mailString = [NSString stringWithFormat:@"mailto:%@",self.contact.email];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}

- (IBAction)makePhoneCall:(id)sender {
    
    NSString* phone = [[self.contact.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    NSURL* callUrl=[NSURL URLWithString:[NSString   stringWithFormat:@"tel:%@",phone]];
    
    if([[UIApplication sharedApplication] canOpenURL:callUrl]) {
        [[UIApplication sharedApplication] openURL:callUrl];
    }
    else {
        [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"MSG.TITLE.Alert.Error", @"Error")
                                   message:@"This function is only available on the iPhone"  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"MSG.BTN.OK", @"OK") otherButtonTitles:nil] show];
    }
    
}

- (IBAction)addContact:(id)sender {
    
    [ self authorizedAccesstoAddressBook ];
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// If connected to net try to download user pofile image frm SFDC and cache the image
// When OFF-line display local image is exists otherwise display default avatar
- (UIImage *)getUserImage {
    UIImage *img = [UIImage imageNamed:@"placeholder"];
    Reachability *hostReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [hostReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        // Look for local copy of image if exists
        img = [CommonUtil getCellImageLocal:self.contact.sfid];
    }else{
        SFOAuthCredentials *cred = [[[SFRestAPI sharedInstance] coordinator] credentials];
        NSString *purl = [NSString stringWithFormat:@"%@?oauth_token=%@", self.contact.fullPhotoURL,cred.accessToken];
        img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:purl]]];
        
        // save user profile photo
        if (img){
            [ CommonUtil createLocalImage:img fileId:self.contact.sfid];
        }
    }

    return img;
}

- (UIImage*)getScaleSizedImage:(UIImage*)photo
{
    UIImage* sizeImage = photo;
    if(photo != nil){

        CGSize bounds = CGSizeMake(184, 184);
        CGSize originalSize = [sizeImage size];
        float xScale = bounds.width / originalSize.width;
        float yScale = bounds.height / originalSize.height;
        float scale = MIN(xScale, yScale);
        
        scale = MIN(scale, 1);
        
        CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
        [sizeImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return resultImage;
        
    }
    return sizeImage;
}

- (void)authorizedAccesstoAddressBook
{
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            [self addContactInContactBook];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self addContactInContactBook];
    }
    else {
        // The user has previously denied access
        UIAlertView *contactAddedAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"MSG.TXT.No.Access.Address", @"Access not granted") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"MSG.BTN.OK", @"OK") otherButtonTitles: nil];
        [contactAddedAlert show];
    }
}

- (void)addContactInContactBook
{
    if (self.contact.phone == nil) {
        UIAlertView *contactAddedAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"MSG.TXT.Cannot.Add.Contact",@"Cannot add Contact without a phone") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"MSG.BTN.OK", @"OK") otherButtonTitles: nil];
        [contactAddedAlert show];
        
        
        return;
    }
    
    CFErrorRef  error = nil;
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    ABRecordRef person = ABPersonCreate();
    if(self.contact.firstName){
        ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef)self.contact.firstName, nil);
    }
    if(self.contact.lastName){
        ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFStringRef)self.contact.lastName, nil);
    }
    
    ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)self.contact.phone, kABPersonPhoneMainLabel, NULL);
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumbers, nil);
    
    if(self.contact.email){
        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(self.contact.email), kABHomeLabel, NULL);
        ABRecordSetValue(person, kABPersonEmailProperty, multiEmail, &error);
    }
    
    // Address only if all address min elements presnt save address in book
    // safety net avoid crashes
    if (self.contact.city && self.contact.state && self.contact.postalcode && self.contact.country)
    {
        ABMutableMultiValueRef address = ABMultiValueCreateMutable(kABDictionaryPropertyType);
        // Set up keys and values for the dictionary.
        CFStringRef keys[5];
        CFStringRef values[5];
        keys[0] = kABPersonAddressStreetKey;
        keys[1] = kABPersonAddressCityKey;
        keys[2] = kABPersonAddressStateKey;
        keys[3] = kABPersonAddressZIPKey;
        keys[4] = kABPersonAddressCountryKey;
    
        CFStringRef ref1 = (__bridge_retained CFStringRef)@""; // No Street for this app
    
        CFStringRef ref2 = (__bridge_retained CFStringRef)self.contact.city;
    
        CFStringRef ref3 = (__bridge_retained CFStringRef)self.contact.state;
    
        CFStringRef ref4 = (__bridge_retained CFStringRef)self.contact.postalcode;
    
        CFStringRef ref5 = (__bridge_retained CFStringRef)self.contact.country;
    
        values[0] = ref1;
        values[1] = ref2;
        values[2] = ref3;
        values[3] = ref4;
        values[4] = ref5;
    
    
    
        CFDictionaryRef dicref = CFDictionaryCreate(kCFAllocatorDefault, (void *)keys, (void *)values, 5, &kCFCopyStringDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
        ABMultiValueIdentifier identifier;
        ABMultiValueAddValueAndLabel(address, dicref, kABHomeLabel, &identifier);
        ABRecordSetValue(person, kABPersonAddressProperty, address, &error);
    }
    
    if (self.photo.image){
        NSData *personImageData = UIImageJPEGRepresentation(self.photo.image, 0.7f);
        ABPersonSetImageData(person, (__bridge CFDataRef)personImageData, nil);
    }
    
    bool add = ABAddressBookAddRecord(addressBookRef, person, &error);
    ABAddressBookSave(addressBookRef, nil);
    if (add) {
        UIAlertView *contactAddedAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"MSG.TXT.Contact.Added",@"Contact Added") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"MSG.BTN.OK", @"OK") otherButtonTitles: nil];
        [contactAddedAlert show];
    }else{
        UIAlertView *contactAddedAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"MSG.TXT.Add.Contact.Error",@"Add Contact error") message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"MSG.BTN.OK", @"OK") otherButtonTitles: nil];
        [contactAddedAlert show];        
    }

}

@end
