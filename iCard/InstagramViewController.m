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
    
    // initialize webview
    NSString *fullURL = @"https://instagram.com/oauth/authorize?client_id=967199972f2f47ca9e722f87b8105045&redirect_uri=http://localhost:8888/MAMP/&response_type=token&scope=basic+relationships";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.webView.delegate = self;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString* urlString = [[request URL] absoluteString];
    NSURL *Url = [request URL];
    NSArray *UrlParts = [Url pathComponents];
    // do any of the following here
    if ([[UrlParts objectAtIndex:(1)] isEqualToString:@"MAMP"])
    {
        //if ([urlString hasPrefix: @"localhost"]) {
        NSRange tokenParam = [urlString rangeOfString: @"access_token="];
        if (tokenParam.location != NSNotFound)
        {
            NSString* token = [urlString substringFromIndex: NSMaxRange(tokenParam)];
            
            // If there are more args, don't include them in the token:
            NSRange endRange = [token rangeOfString: @"&"];
            if (endRange.location != NSNotFound)
                token = [token substringToIndex: endRange.location];
            
            // DEBUGGING
            NSLog(@"access token %@", token);
            
            // configure the Instagram API URL appropriately
            NSString *instagramString = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/?access_token=%@",token];
            NSURL *instagramURL = [NSURL URLWithString:instagramString];
            
            // Parse the JSON data provided by the Instagram API to find the user's username
            NSData *jsonData = [NSData dataWithContentsOfURL:instagramURL];
            NSError *error = nil;
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
            NSDictionary *data = dataDictionary[@"data"];
            NSString *instagramID = data[@"id"];
            NSString *instagramHandle = data[@"username"];
            NSLog(@"%@ %@", instagramID, instagramHandle);
            
            // query the backend to update the Instagram username and access token accordingly
            PFUser *currentUser = [PFUser currentUser];
            PFQuery *query = [PFQuery queryWithClassName:@"_User"];
            [query whereKey:@"username" equalTo:currentUser.username];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                // display the appropriate message
                if (!error) {
                    for (PFObject *object in objects) {
                        object[@"InstagramAccessToken"] = token;
                        object[@"InstagramID"] = instagramID;
                        object[@"InstagramHandle"] = instagramHandle;
                        [object saveInBackground];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congrats!"
                                                                        message:@"Your account has been successfully connected to Instagram!"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
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
            // Handle the access rejected case here.
            NSLog(@"rejected case, user denied request");
        }
        return NO;
    }
    return YES;
}

@end
