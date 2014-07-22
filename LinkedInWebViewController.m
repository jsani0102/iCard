//
//  LinkedInWebViewController.m
//  iCard
//
//  Created by Jayant Sani on 7/22/14.
//  Copyright (c) 2014 Jayant Sani. All rights reserved.
//

#import "LinkedInWebViewController.h"
#import "AFNetworking/AFNetworking.h"
#import <Parse/Parse.h>

@interface LinkedInWebViewController ()

@end

@implementation LinkedInWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // initialize webview
    NSString *fullURL = @"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=77dsuygh5i0zj5&scope=r_basicprofile%20w_messages&state=DCEEFWF45453sdffef424&redirect_uri=https://iCard/linkedin/auth";
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.host isEqualToString:@"icard"])
    {
        NSString *urlString = [request.URL absoluteString];
        NSRange tokenParam = [urlString rangeOfString:@"code="];
        if (tokenParam.location != NSNotFound)
        {
            NSString *code = [urlString substringFromIndex: NSMaxRange(tokenParam)];
            
            NSRange endRange = [code rangeOfString: @"&"];
            if (endRange.location != NSNotFound)
                code = [code substringToIndex:endRange.location];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSDictionary *parameters = @{@"grant_type": @"authorization_code",
                                         @"code": code,
                                         @"redirect_uri": @"https://iCard/linkedin/auth",
                                         @"client_id": @"77dsuygh5i0zj5",
                                         @"client_secret": @"GZfd6NYgpEwfI3ng"};
            
            [manager POST:@"https://www.linkedin.com/uas/oauth2/accessToken" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                PFUser *currentUser = [PFUser currentUser];
                [currentUser setObject:responseObject[@"access_token"] forKey:@"LinkedInAccessToken"];
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
