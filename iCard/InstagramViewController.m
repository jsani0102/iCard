//
//  InstagramViewController.m
//  iCard
//
//  Created by Jayant Sani on 1/21/14.
//  Copyright (c) 2014 Jayant Sani. All rights reserved.
//

#import "InstagramViewController.h"
#import <Parse/Parse.h>
#import "AFNetworking.h"

@implementation InstagramViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // initialize webview
    NSString *fullURL = @"https://instagram.com/oauth/authorize?client_id=967199972f2f47ca9e722f87b8105045&redirect_uri=http://localhost:8888/MAMP/&response_type=code&scope=basic+relationships";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.webView.delegate = self;
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.host isEqualToString:@"localhost"])
    {
        NSString *urlString = [request.URL absoluteString];
        NSString *code;
        NSRange tokenParam = [urlString rangeOfString:@"code="];
        if (tokenParam.location != NSNotFound)
        {
            code = [urlString substringFromIndex: NSMaxRange(tokenParam)];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{@"grant_type": @"authorization_code",
                                         @"code": code,
                                         @"redirect_uri": @"http://localhost:8888/MAMP/",
                                         @"client_id": @"967199972f2f47ca9e722f87b8105045",
                                         @"client_secret": @"7736c9bbfd314a418d963f533658f819"};
            
            [manager POST:@"https://api.instagram.com/oauth/access_token" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                PFUser *currentUser = [PFUser currentUser];
                [currentUser setObject:responseObject[@"access_token"] forKey:@"InstagramAccessToken"];
                [currentUser setObject:responseObject[@"user"][@"id"] forKey:@"InstagramID"];
                [currentUser setObject:responseObject[@"user"][@"username"] forKey:@"InstagramHandle"];
                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    // saved, bitches --> insert cool animation here
                }];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"ERROR: %@ %@", error, error.userInfo);
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                            message:@"User denied request for iCard authentication!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    return YES;
}

@end
