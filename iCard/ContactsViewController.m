//
//  ContactsViewController.m
//  iCard
//
// The friends.png image of this tab has been taken from a project on teamtreehouse.com titled "Building
// a Self-destructing Message iPhone App."
//
//  Created by Jayant Sani and Jesse Jiang on 12/1/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import "ContactsViewController.h"
#import "ViewContactViewController.h"
#import <Parse/Parse.h>

@interface ContactsViewController ()

@end

@implementation ContactsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser)
    {
        // if there is no currentUser logged in, go to the login screen
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    
    // query the backend for the friends array of the user before contacts appears
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:currentUser.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                // sort the friends array alphabetically
                self.friends = [object[@"Friends"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                // so that the tableView shows the results of the query after the asynchronous call
                [self.tableView reloadData];
            }
        }
        else {
            // Log the error
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // assign the cells' text to be the NSStrings in the friends array
    cell.textLabel.text = [self.friends objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    // go to the login screen after a user logs out
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // should not be able to see the tab bar in the login screen
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    // send the name of the friend to the ViewContactViewController to find out handles/social media information through a query
    else if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *friend = self.friends[indexPath.row];
        [[segue destinationViewController] setDetailItem:friend];
    }
}

@end
