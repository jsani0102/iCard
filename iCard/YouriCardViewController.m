//
//  YouriCardViewController.m
//  iCard
//
//  Created by Jayant Sani and Jesse Jiang on 12/4/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import "YouriCardViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Parse/Parse.h>

@interface YouriCardViewController ()

@end

@implementation YouriCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


// the following code uses the Twitter API and the ACAccountStore class on the iOS platform that accesses all the user's accounts
- (IBAction)connectToTwitter:(id)sender {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountsArray count] > 0)
            {
                // ASSUMING ONE TWITTER ACCOUNT - TODO - TRY TO HANDLE MULTIPLE ONES WITH "MODAL" VIEW - Jeremy Sabath
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                self.twitterHandle = twitterAccount.username;
                
                // query the backend to update the twitter handle accordingly
                PFUser *currentUser = [PFUser currentUser];
                PFQuery *query = [PFQuery queryWithClassName:@"_User"];
                [query whereKey:@"username" equalTo:currentUser.username];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        for (PFObject *object in objects) {
                            object[@"TwitterHandle"] = self.twitterHandle;
                            [object saveInBackground];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats!"
                                                                            message:@"Your account has been successfully connected to Twitter!"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                            [alert show];
                            return;
                        }
                    }
                    else {
                        // Log the error
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            else
            {
                // accountsArray has 0 Twitter accounts
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                               message:@"Please go to Settings to configure your Twitter account!"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
                [alert show];
                return;
            }
            
        }
    }];
}

- (IBAction)connectToFacebook:(id)sender {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{
                              @"ACFacebookAppIdKey" : @"392820127522035",
                              @"ACFacebookPermissionsKey" : @[@"basic_info"]};
    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Facebook accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountsArray count] > 0)
            {
                NSLog(@"HERE");
                // ASSUMING ONE FACEBOOK ACCOUNT - TODO - TRY TO HANDLE MULTIPLE ONES WITH "MODAL" VIEW - Jeremy Sabath
                ACAccount *facebookAccount = [accountsArray objectAtIndex:0];
                self.facebookID = facebookAccount.username;
                
                // query the backend to update the facebook username accordingly
                PFUser *currentUser = [PFUser currentUser];
                PFQuery *query = [PFQuery queryWithClassName:@"_User"];
                [query whereKey:@"username" equalTo:currentUser.username];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    // display the appropriate message
                    if (!error) {
                        for (PFObject *object in objects) {
                            object[@"FacebookID"] = self.facebookID;
                            [object saveInBackground];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats!"
                                                                            message:@"Your account has been successfully connected to Facebook!"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                            [alert show];
                            return;
                        }
                    }
                    else {
                        // Log the error
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                message:@"Please go to Settings to configure your Facebook account!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
        }
    }];
}

@end
