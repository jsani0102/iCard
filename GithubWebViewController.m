//
//  GithubWebViewController.m
//  iCard
//
//  Created by Jayant Sani on 7/22/14.
//  Copyright (c) 2014 Jayant Sani. All rights reserved.
//

#import "GithubWebViewController.h"
#import "AFNetworking/AFNetworking.h"
#import <Parse/Parse.h>

@interface GithubWebViewController ()

@end

@implementation GithubWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // initialize webview
    NSString *fullURL = @"https://github.com/login/oauth/authorize?client_id=8b2af7a165f812509d60&scope=user&state=DCEEFWF45453sdffef424&redirect_uri=iCard://github/auth";
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
    if ([request.URL.scheme isEqualToString:@"icard"])
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
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            NSDictionary *parameters = @{@"code": code,
                                         @"redirect_uri": @"iCard://github/auth",
                                         @"client_id": @"8b2af7a165f812509d60",
                                         @"client_secret": @"23e9f505a70764863476451d8000b039154302c4"};
            
            [manager POST:@"https://github.com/login/oauth/access_token" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                PFUser *currentUser = [PFUser currentUser];
                [currentUser setObject:responseObject[@"access_token"] forKey:@"GithubAccessToken"];
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
