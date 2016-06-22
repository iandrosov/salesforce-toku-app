//
//  CloudStoreViewController.m
//  ToKu
//
//  Created by Igor Old MAC on 2/3/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import "CloudStoreViewController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"
#import "LocalStoreManager.h"
#import "MapViewController.h"
#import "ContactTableViewController.h"
#import "AttributesFacade.h"
#import "Reachability.h"

@interface CloudStoreViewController ()

@end

@implementation CloudStoreViewController

@synthesize dataRows;
@synthesize request_spinner;
@synthesize smartStoreIntf;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        smartStoreIntf = [[SmartStoreInterface alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.request_spinner.hidesWhenStopped = YES;
    [self.request_spinner stopAnimating];
    //self.request_spinner.hidden = YES;
    // Call API for data
    if([LocalStoreManager isLocalDataExists] == NO){
        [self querySFData];
    }
    self.view.backgroundColor = [AttributesFacade contanerBackgroundColor];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)dealloc
{
    self.smartStoreIntf = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)refreshData:(id)sender {
    Reachability *hostReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [hostReachability currentReachabilityStatus];
    if (networkStatus == SFNotReachable) {
        UIAlertView* alert;
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MSG.TITLE.Alert.Warning", @"Warning")
                                           message:NSLocalizedString(@"MSG.TEXT.Alert.NoConection", @"No Internet connection to refresh data") delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"MSG.BTN.OK", @"OK") otherButtonTitles: nil];
        [alert show];
    }else{
        [self querySFData];
    }
/**
    
    [SFNetworkEngine sharedInstance].reachabilityChangedHandler = ^(SFNetworkStatus newStatus) {
            // Handle your network changes here.
        if (newStatus){
        
                UIAlertView* alert;
                alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MSG.TITLE.Alert.Warning", @"Warning")
                                           message:NSLocalizedString(@"MSG.TEXT.Alert.NoConection", @"No Internet connection to refresh data") delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"MSG.BTN.OK", @"OK") otherButtonTitles: nil];
                [alert show];
        }else{
            [self querySFData];
        }
    };
 **/
}

- (IBAction)filterData:(id)sender {
    
}

- (IBAction)locateFriend:(id)sender {

    UITabBarController *tabController = [[UITabBarController alloc] init];
    MapViewController  *mapVC = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapVC.tabBarItem.title = NSLocalizedString(@"MSG.TITLE.Map", @"Map");
    [mapVC.tabBarItem setImage:[UIImage imageNamed:@"active-marker"]];
    
    ContactTableViewController  *contactVC = [[ContactTableViewController alloc] initWithNibName:@"ContactTableViewController" bundle:nil];
    contactVC.tabBarItem.title = NSLocalizedString(@"MSG.TITLE.List", @"List");
    [contactVC.tabBarItem setImage:[UIImage imageNamed:@"menu"]];
    
    NSArray *controllers = [NSArray arrayWithObjects:contactVC, mapVC, nil];
    
    [tabController setViewControllers:controllers];
    tabController.selectedViewController = controllers[0];
    tabController.title = NSLocalizedString(@"MSG.TITLE.Friends", @"Friends");

    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:tabController animated:YES];

}

- (void)initSpinner {
    //self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //self.spinner.center = self.request_spinner.center;
    //self.spinner.frame = self.request_spinner.frame;
    //self.spinner.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    //self.spinner.frame = CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2, 80, 80);
    //self.spinner.frame = CGRectMake(self.backgroundImageView.bounds.origin.x, self.backgroundImageView.bounds.origin.y, 80, 80);
    //[UIScreen mainScreen].bounds.size.width
    //self.spinner.hidesWhenStopped = YES;
    //self.spinner.opaque = NO;
    //[self.view addSubview:self.spinner];
    
    //[self.spinner startAnimating];
    
    [self.request_spinner startAnimating];
}

- (void)stopSpinner{
    //self.spinner.hidesWhenStopped = YES;
    // Stop spinner
    //[self.spinner stopAnimating];
    
    [self.request_spinner stopAnimating];
    //[self.request_spinner removeFromSuperview];
}


#pragma mark - SFRestAPIDelegate

- (void)querySFData {
    //Here we use a query that should work on either Force.com or Database.com
    //SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Name FROM User LIMIT 10"];
    //NSString *qry = @"SELECT Id,LastName,FirstName,Name,MailingState,MailingCountry,MailingCity,MailingPostalCode,MobilePhone,Email,Title,HasOptedOutOfEmail,DoNotCall,Employee_Number__c,pse__Is_Resource_Active__c FROM Contact WHERE Employee_Number__c != null LIMIT 100";
    NSString *qry = @"SELECT Id,Username,Name,FirstName,LastName, UserType,Title,Street,City,State,PostalCode,Country,Email,Phone,MobilePhone,IsActive,FullPhotoUrl,SmallPhotoUrl FROM User WHERE isActive = true AND UserType = 'Standard' ORDER BY Name ASC NULLS LAST LIMIT 2000"; //WHERE isActive = true
    
    [self.smartStoreIntf deleteUsersSoup];
    [self.smartStoreIntf createUsersSoup];
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:qry];
    [self initSpinner];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    //NSArray *records = [jsonResponse objectForKey:@"records"];
    NSArray *records = jsonResponse[@"records"];
    NSLog(@"request:didLoadResponse: #records: %lu", (unsigned long)records.count);
    self.dataRows = records;
    
    // Store data locally
    //[LocalStoreManager saveApplicationData:records];
    
    [self.smartStoreIntf insertUsers:records];
    
    //[self stopSpinner];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.request_spinner stopAnimating];
        
    });
}


- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}

@end
