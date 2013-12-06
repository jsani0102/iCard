//
//  ConnectViewController.m
//  iCard
//
//  Created by Jayant Sani on 12/3/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import "ConnectViewController.h"
#import <Parse/Parse.h>

@interface ConnectViewController ()

@end

@implementation ConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)addUser:(id)sender {
    // adds user to the parse backend database to show up in the contacts viewController
    NSString *username = self.usernameField.text;
    
    PFUser *currentUser = [PFUser currentUser];
    
    // add the friend that the user typed into the text field to the friends array in the parse backend
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:currentUser.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Do something with the found objects
            for (PFObject *object in objects) {
                if(object[@"Friends"] == nil) {
                    object[@"Friends"] = [[NSMutableArray alloc] init];
                }
                [object[@"Friends"] addObject:username];
                [object saveInBackground];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Great!" message:[[@"You are now connected with " stringByAppendingString:username] stringByAppendingString:@"!"] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];

            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    // get rid of the keyboard after the user adds a friend
    [self.usernameField resignFirstResponder];

    
}
@end
