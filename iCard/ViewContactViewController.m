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
#import "AFHTTPRequestOperationManager.h"

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
                self.instagramID = object[@"InstagramID"];
                self.twitterHandle = object[@"TwitterHandle"];
                self.instagramAccessToken = object[@"InstagramAccessToken"];
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
        // configure the Graph API URL appropriately
        NSString *fbGraph = [@"https://graph.facebook.com/" stringByAppendingString:self.facebookID];
        NSURL *fbGraphURL = [NSURL URLWithString:fbGraph];
        
        // Parse the JSON data provided by the Graph API to find the user's ID
        NSData *jsonData = [NSData dataWithContentsOfURL:fbGraphURL];
        NSError *error = [[NSError alloc] init];
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        NSString *identifier = dataDictionary[@"id"];
        
        // configure the link to go to the correct page in the native Facebook App
        NSString *nativeURLString = [@"fb://profile/" stringByAppendingString:identifier];
        NSURL *nativeURL = [NSURL URLWithString:nativeURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:nativeURL])
        {
            // if the native link can be opened, go to that link in the native app
            [[UIApplication sharedApplication] openURL:nativeURL];
        }
        else
        {
            // go to the friend's facebook profile on Safari on the device
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://facebook.com/%@",self.facebookID]]];
        }
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
        // set up and execute HTTP request data
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"action": @"follow"};
        [manager POST:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/relationship?access_token=%@", self.instagramID, self.instagramAccessToken] parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"JSON: %@", responseObject);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Awesome!" message:[[@"You are now following " stringByAppendingString:self.instagramHandle] stringByAppendingString:@" on Instagram!"]delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"Error: %@", error);
        }];
    }
}

- (IBAction)followOnTwitter:(id)sender {
    if (self.twitterHandle == nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:@"This user has not configured their Twitter account" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    else
    {
        // the following code uses the Twitter API and the ACAccountStore class on the iOS platform that
        // accesses all the user's account this code was adapted from http://iosameer.blogspot.com/2012/10/follow-us-on-twitter-button-integration.html
        
        // access the user's Twitter accounts
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            if (granted)
            {
                NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                if ([accountsArray count] > 0)
                {
                    // grab the first Twitter account
                    ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                    
                    // create a dictionary to change the json values in the friendship
                    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                    [tempDict setValue:self.twitterHandle forKey:@"screen_name"];
                    [tempDict setValue:@"true" forKey:@"follow"];
                    NSString *urlString = @"https://api.twitter.com/1/friendships/create.json";
                    NSURL *url = [NSURL URLWithString:urlString];
                    // send a post request to update the json values
                    SLRequest *postRequest  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                 requestMethod:SLRequestMethodPOST
                                                                           URL:url
                                                                    parameters:tempDict];
                    [postRequest setAccount:twitterAccount];
                    // check that the Twitter following functionality succeeded
                    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                    {
                        if ([urlResponse statusCode] == 200)
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Awesome!" message:[[@"You are now following " stringByAppendingString:self.twitterHandle] stringByAppendingString:@" on Twitter!"]delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alertView show];
                            return;
                        }
                        else
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[[@"Following " stringByAppendingString:self.twitterHandle] stringByAppendingString:@" on Twitter failed!"]delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alertView show];
                            return;
                        }
                    }];
                }
            }
        }];
    }
}
@end
