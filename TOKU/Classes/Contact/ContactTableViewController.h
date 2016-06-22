//
//  ContactTableViewController.h
//  Appirian
//
//  Created by Igor Old MAC on 1/24/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *dataRows;
// Search proprerty
@property (strong,nonatomic) NSMutableArray *filteredPersonArray;
@property IBOutlet UISearchBar *personSearchBar;

@end
