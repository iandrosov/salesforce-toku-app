//
//  ContactTableViewController.m
//  Appirian
//
//  Created by Igor Old MAC on 1/24/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import "ContactTableViewController.h"
#import "LocalStoreManager.h"
#import "ContactDetailViewController.h"
#import "ContactModel.h"
#import "AttributesFacade.h"

@interface ContactTableViewController ()

@end

@implementation ContactTableViewController

@synthesize filteredPersonArray;
@synthesize personSearchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"MSG.TITLE.People", @"People");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
    self.dataRows = [LocalStoreManager getCantactsModel];
    self.filteredPersonArray = [NSMutableArray arrayWithCapacity:[self.dataRows count]];
    self.view.backgroundColor = [AttributesFacade contanerBackgroundColor];
    self.navigationController.navigationBar.hidden = NO;
        
    // instead of self.tableView.dataSource = self; use:
    //self.autoSectionDataSource = [[AutoSectionTableViewDataSource alloc] initWithDataSource:self];
    //self.tableView.dataSource = self.autoSectionDataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredPersonArray count];
    }else{
        return [self.dataRows count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];

    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }
    // set default
    cell.textLabel.text = @"No Name";
    // Configure the cell to show the data.
    //NSDictionary *obj = [self.dataRows objectAtIndex:indexPath.row];
    //NSArray *obj = [self.dataRows objectAtIndex:indexPath.row];
    ContactModel *contact = [self.dataRows objectAtIndex:indexPath.row];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contact = [filteredPersonArray objectAtIndex:indexPath.row];
    }
    
    if (contact != nil) {
        //ContactModel *contact = [[ContactModel alloc] init];
        //[contact initWithDictionary:obj];
        //[contact initWithArray:obj];
        if (contact.name && ![contact.name isKindOfClass:[NSNull class]]) {
            cell.textLabel.text = contact.name;
        }
        if (contact.title && ![contact.title isKindOfClass:[NSNull class]]) {
            cell.detailTextLabel.text = contact.title;
        }
        if (contact.isActive) {
            cell.imageView.image = [UIImage imageNamed:@"active-marker"];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"not-active-marker"];
        }
        
    }
        //this adds the arrow to the right hand side.
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    ContactDetailViewController *detailViewController = [[ContactDetailViewController alloc] initWithNibName:@"ContactDetailViewController" bundle:nil];
    
    // Pass the selected object to the new view controller.
    //NSDictionary *obj = [self.dataRows objectAtIndex:indexPath.row];
    //NSArray *obj = [self.dataRows objectAtIndex:indexPath.row];
    ContactModel *contact = [self.dataRows objectAtIndex:indexPath.row];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contact = [filteredPersonArray objectAtIndex:indexPath.row];
    }
    
    //ContactModel *contact = [[ContactModel alloc] init];
    //[contact initWithDictionary:obj];
    //[contact initWithArray:obj];
    
    detailViewController.contact = contact; //[self.dataRows objectAtIndex:indexPath.row];
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark Search Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Clean objects from the filtered search array
    [self.filteredPersonArray removeAllObjects];
    // Filter the array using NSPredicate
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.Name beginswith[c] %@",searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name beginswith[c] %@",searchText];
    filteredPersonArray = [NSMutableArray arrayWithArray:[self.dataRows filteredArrayUsingPredicate:predicate]];
    
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Rekload the table data source when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
@end
