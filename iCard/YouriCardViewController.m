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

- (IBAction)enterFacebookTwitterInstagram:(id)sender {
    // invalid input
    if ([self.facebookIDField.text length] == 0 || [self.instagramHandleField.text length] == 0 || [self.twitterHandleField.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                        message:@"Please input a FacebookID, Twitter handle, and an Instagram handle."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // handle the input appropriately with the parse backend
        self.facebookID = self.facebookIDField.text;
        self.instagramHandle = self.instagramHandleField.text;
        self.twitterHandle = self.twitterHandleField.text;
        
        PFUser *currentUser = [PFUser currentUser];
        
        // put the user's inputted information into the parse backend
        PFQuery *query = [PFQuery queryWithClassName:@"_User"];
        [query whereKey:@"username" equalTo:currentUser.username];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    object[@"FacebookID"] = self.facebookID;
                    object[@"InstagramHandle"] = self.instagramHandle;
                    object[@"TwitterHandle"] = self.twitterHandle;
                    [object saveInBackground];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"Your Facebook, Instagram, and Twitter information are now synced with your account" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        self.facebookIDField.text = @"";
        self.instagramHandleField.text = @"";
        self.twitterHandleField.text = @"";
        
        // get rid of the keyboard after the user has pressed "Enter"
        [self.facebookIDField resignFirstResponder];
        [self.instagramHandleField resignFirstResponder];
        [self.twitterHandleField resignFirstResponder];
    }
}

// the following code uses the Twitter API and the ACAccountStore class on the iOS platform that accesses all the user's accounts. It is the vision of this app, but we did not have enough time to perfect this across all social media.

//- (IBAction)connectToTwitter:(id)sender {
//    // borrowed from: http://eflorenzano.com/blog/2012/04/18/using-twitter-ios5-integration-single-sign-on/
//    ACAccountStore *store = [[ACAccountStore alloc] init];
//    ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
//    [store requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
//        if(granted) {
//            // Access has been granted, now we can access the accounts
//            
//            // Remember that twitterType was instantiated above
//            NSArray *twitterAccounts = [store accountsWithAccountType:twitterType];
//            
//            // If there are no accounts, we need to pop up an alert
//            if(twitterAccounts != nil && [twitterAccounts count] == 0) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Accounts"
//                                                                message:@"There are no Twitter accounts configured. You must add or create a Twitter separately."
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
//            } else {
//                ACAccount *account = [twitterAccounts objectAtIndex:0];
//                // Do something with their Twitter account
//                NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/account/verify_credentials.json"];
//                SLRequest *req = [SLRequest requestForServiceType:SLServiceTypeTwitter
//                                                    requestMethod:SLRequestMethodPOST
//                                                              URL:url
//                                                       parameters:nil];
//                
//                // Important: attach the user's Twitter ACAccount object to the request
//                req.account = account;
//                
//                [req performRequestWithHandler:^(NSData *responseData,
//                                                 NSHTTPURLResponse *urlResponse,
//                                                 NSError *error) {
//                    
//                    // If there was an error making the request, display a message to the user
//                    if(error != nil) {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Error"
//                                                                        message:@"There was an error talking to Twitter. Please try again later."
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"OK"
//                                                              otherButtonTitles:nil];
//                        [alert show];
//                        return;
//                    }
//                    
//                    // Parse the JSON response
//                    NSError *jsonError = nil;
//                    id resp = [NSJSONSerialization JSONObjectWithData:responseData
//                                                              options:0
//                                                                error:&jsonError];
//                    
//                    // If there was an error decoding the JSON, display a message to the user
//                    if(jsonError != nil) {
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Error"
//                                                                        message:@"Twitter is not acting properly right now. Please try again later."
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"OK"
//                                                              otherButtonTitles:nil];
//                        [alert show];
//                        return;
//                    }
//                    
//                    NSString *screenName = [resp objectForKey:@"screen_name"];
//                    self.twitterHandle = screenName;
//                    
//                    PFUser *currentUser = [PFUser currentUser];
//                    
//                    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
//                    [query whereKey:@"username" equalTo:currentUser.username];
//                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                        if (!error) {
//                            // Do something with the found objects
//                            for (PFObject *object in objects) {
//                                object[@"TwitterHandle"] = self.twitterHandle;
//                                [object saveInBackground];
//                            }
//                        } else {
//                            // Log details of the failure
//                            NSLog(@"Error: %@ %@", error, [error userInfo]);
//                        }
//                    }];
//                    
//                }];
//            }
//        }
//    }];
//}

@end
