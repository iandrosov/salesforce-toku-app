//
//  ContactDetailViewController.h
//  Appirian
//
//  Created by Igor Old MAC on 1/22/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"

@interface ContactDetailViewController : UIViewController

@property (nonatomic, strong) ContactModel *contact;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *ctitle;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *addContactButton;


- (IBAction)sendEmail:(id)sender;
- (IBAction)makePhoneCall:(id)sender;
- (IBAction)addContact:(id)sender;

@end
