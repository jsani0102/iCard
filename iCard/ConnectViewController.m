//
//  ConnectViewController.m
//  iCard
//
//  Created by Jayant Sani and Jesse Jiang on 12/3/13.
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
    
    // find out if the username is valid by querying the database and seeing if that user exists
    PFQuery *queryUsername = [PFQuery queryWithClassName:@"_User"];
    [queryUsername whereKey:@"username" equalTo:username];
    [queryUsername findObjectsInBackgroundWithBlock:^(NSArray *elements, NSError *error) {
        if (!error)
        {
            // the query returned an object
            if ([elements count] > 0)
            {
                PFUser *currentUser = [PFUser currentUser];
                
                // add the friend that the user typed into the text field to the friends array in the parse backend
                PFQuery *queryFriends = [PFQuery queryWithClassName:@"_User"];
                [queryFriends whereKey:@"username" equalTo:currentUser.username];
                [queryFriends findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        for (PFObject *object in objects) {
                            if(object[@"Friends"] == nil) {
                                object[@"Friends"] = [[NSMutableArray alloc] init];
                            }
                            for (NSString *friend in object[@"Friends"])
                            {
                                if ([username isEqualToString:currentUser.username])
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"You cannot connect with yourself!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [alertView show];
                                    [self.usernameField resignFirstResponder];
                                    return;
                                }
                                // the inputted username is already in the friends array
                                else if ([friend isEqualToString:username])
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[[@"You are already connected with " stringByAppendingString:username] stringByAppendingString:@"!"] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [alertView show];
                                    [self.usernameField resignFirstResponder];
                                    return;
                                }
                            }
                            // add the friend to the friends array
                            [object[@"Friends"] addObject:username];
                            [object saveInBackground];
                            
                            // make the text field empty
                            self.usernameField.text = @"";
                            
                            // alert the user of the connection
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Great!" message:[[@"You are now connected with " stringByAppendingString:username] stringByAppendingString:@"!"] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alertView show];
                            
                        }
                    }
                    else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            else
            {
                // alert the user that the username typed is invalid
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"That username does not exist!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    // get rid of the keyboard after the user adds a friend
    [self.usernameField resignFirstResponder];
    
    // clear the text field after adding user
    self.usernameField.text = @"";

}
@end
