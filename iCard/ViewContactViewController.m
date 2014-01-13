//
//  ViewContactViewController.m
//  iCard
//
//  Created by Jayant Sani and Jesse Jiang on 12/5/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import "ViewContactViewController.h"
#import <Parse/Parse.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface ViewContactViewController ()
- (void)configureView;
@end

@implementation ViewContactViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    self.navigationItem.title = self.detailItem;
    
    // query the backend to set properties equal to the friend's social media information that the user has selected
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:self.detailItem];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                self.facebookID = object[@"FacebookID"];
                self.instagramHandle = object[@"InstagramHandle"];
                self.twitterHandle = object[@"TwitterHandle"];
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addOnFacebook:(id)sender {
    if (self.facebookID == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"This user has not configured their Facebook account" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        // go to the friend's facebook profile on the web
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://facebook.com/%@",self.facebookID]]];
    }
}

- (IBAction)followOnInstagram:(id)sender {
    if (self.instagramHandle == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"This user has not configured their Instagram account" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        // go to the friend's instagram profile on the web
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://instagram.com/%@",self.instagramHandle]]];

    }
}

- (IBAction)followOnTwitter:(id)sender {
    if (self.twitterHandle == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"This user has not configured their Twitter account" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        // go to the friend's instagram profile on the web
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@",self.twitterHandle]]];
        
// the following code uses the Twitter API and the ACAccountStore class on the iOS platform that accesses all the user's accounts. It is the vision of this app, but we did not have enough time to perfect this across all social media. Because of this limitation, I am using the web versions above for each social media site.
        
//        // this code was adapted from http://iosameer.blogspot.com/2012/10/follow-us-on-twitter-button
//        // integration.html
//        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
//        ACAccountType *accountType = [accountStore
//                                      accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
//        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
//            if(granted) {
//                // Get the list of Twitter accounts.
//                NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
//                // here, I'll assume there is only one Twitter account present.
//                // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present. see Note section below if there are multiple accounts
//                if ([accountsArray count] > 0) {
//                    // Grab the initial Twitter account to tweet from.
//                    ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
//                    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
//                    [tempDict setValue:@"TwitterAccountName" forKey:@"screen_name"];
//                    [tempDict setValue:@"true" forKey:@"follow"];
//                    NSString *urlString = @"https://api.twitter.com/1/friendships/create.json";
//                    NSURL *url = [NSURL URLWithString:urlString];
//                    SLRequest *postRequest  = [SLRequest requestForServiceType:SLServiceTypeTwitter
//                                                              requestMethod:SLRequestMethodPOST
//                                                                        URL:url
//                                                                 parameters:tempDict];
//                    [postRequest setAccount:twitterAccount];
//                    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
//                        NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
//                        NSLog(@"%@", output);
//                        if ([urlResponse statusCode] == 200) {
//                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Awesome!" message:[[@"You are now following " stringByAppendingString:self.twitterHandle] stringByAppendingString:@" on Twitter!"]delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                            [alertView show];
//                        }
//                        else {
//                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[[@"Following " stringByAppendingString:self.twitterHandle] stringByAppendingString:@" on Twitter failed!"]delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                            [alertView show];
//                        }
//                        
//                    }];
//                }
//            }
//        }];
    }
}
@end
