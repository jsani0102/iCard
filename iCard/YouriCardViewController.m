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

- (IBAction)enterInstagram:(id)sender {
    // invalid input
    if ([self.instagramHandleField.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                        message:@"Please input an Instagram handle."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // handle the input appropriately with the parse backend
        self.instagramHandle = self.instagramHandleField.text;
        
        PFUser *currentUser = [PFUser currentUser];
        
        // put the user's inputted information into the parse backend
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        [query whereKey:@"username" equalTo:currentUser.username];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    object[@"FacebookID"] = self.facebookID;
                    object[@"InstagramHandle"] = self.instagramHandle;
                    [object saveInBackground];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"Your Facebook, Instagram, and Twitter information are now synced with your account" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        self.instagramHandleField.text = @"";
        
        // get rid of the keyboard after the user has pressed "Enter"
        [self.instagramHandleField resignFirstResponder];
    }
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
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Facebook accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountsArray count] > 0)
            {
                // ASSUMING ONE FACEBOOK ACCOUNT - TODO - TRY TO HANDLE MULTIPLE ONES WITH "MODAL" VIEW - Jeremy Sabath
                ACAccount *facebookAccount = [accountsArray objectAtIndex:0];
                self.facebookID = facebookAccount.username;
                
                // query the backend to update the facebook username accordingly
                PFUser *currentUser = [PFUser currentUser];
                PFQuery *query = [PFQuery queryWithClassName:@"_User"];
                [query whereKey:@"username" equalTo:currentUser.username];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
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
