//
//  InstagramViewController.m
//  iCard
//
//  Created by Jayant Sani on 1/21/14.
//  Copyright (c) 2014 Jayant Sani. All rights reserved.
//

#import "InstagramViewController.h"
#import <Parse/Parse.h>

@implementation InstagramViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// create a webview
    UIWebView* mywebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height)];
    NSString *fullURL = @"https://instagram.com/oauth/authorize/?client_id=967199972f2f47ca9e722f87b8105045&redirect_uri=http://jelled.com/instagram/access-token&response_type=token";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [mywebview loadRequest:requestObj];
    mywebview.delegate = self;
    [self.view addSubview:mywebview];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *access_token = @"194847131.9671999.c5f1eec9ab9c48eb95c47efae8eb481c";
    NSString *user_id = @"194847131";
    
    // configure the Instagram API URL appropriately
    NSString *instagramAPI = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/users/%@/?access_token=%@", user_id, access_token];
    NSURL *instagramAPICall = [NSURL URLWithString:instagramAPI];
    
    // Parse the JSON data provided by the Instagram API to find the user's username
    NSData *jsonData = [NSData dataWithContentsOfURL:instagramAPICall];
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    NSDictionary *data = dataDictionary[@"data"];
    NSString *username = data[@"username"];
    
    // query the backend to update the facebook username accordingly
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username" equalTo:currentUser.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // display the appropriate message
        if (!error) {
            for (PFObject *object in objects) {
                object[@"InstagramHandle"] = username;
                [object saveInBackground];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats!"
                                                                message:@"Your account has been successfully connected to Instagram!"
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
    return YES;
}
@end
