//
//  LoginViewController.m
//  iCard
//
//  Created by Jayant Sani on 12/2/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.hidesBackButton = YES;
}

- (IBAction)login:(id)sender {
    
    // assign inputs to variable names, trim the username of any whitespace
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = self.passwordField.text;
    
    // check for valid inputs
    if ([username length] == 0 || [password length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter a username and password!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    // login user - inputs are valid
    else
    {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error)
            {
                // if there is an error while trying to log in
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                // no error while logging in - send user to root view
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }

}
@end
