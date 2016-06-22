//
//  CloudStoreViewController.h
//  ToKu
//
//  Created by Igor Old MAC on 2/3/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SalesforceRestAPI/SFRestAPI.h>
#import "SmartStoreInterface.h"

@interface CloudStoreViewController : UIViewController <SFRestDelegate>

@property (nonatomic, strong) NSArray *dataRows;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *filterDataButton;
@property (weak, nonatomic) IBOutlet UIButton *locateFriendButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *request_spinner;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) SmartStoreInterface *smartStoreIntf;

@property (weak, nonatomic) IBOutlet UIButton *refreshDataButton;
- (IBAction)refreshData:(id)sender;
- (IBAction)filterData:(id)sender;
- (IBAction)locateFriend:(id)sender;

@end
