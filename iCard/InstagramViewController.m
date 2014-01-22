//
//  InstagramViewController.m
//  iCard
//
//  Created by Jayant Sani on 1/21/14.
//  Copyright (c) 2014 Jayant Sani. All rights reserved.
//

#import "InstagramViewController.h"

@implementation InstagramViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // initialize webview
    NSString *fullURL = @"https://instagram.com/oauth/authorize?client_id=967199972f2f47ca9e722f87b8105045&redirect_uri=http://localhost:8888/MAMP/&response_type=token";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    self.webView.delegate = self;
    
    NSString *scope = @"basic+relationships";
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
            
            NSLog(@"access token %@", token);
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
