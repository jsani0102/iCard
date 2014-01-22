//
//  SignupViewController.m
//  iCard
//
//  Created by Jayant Sani and Jesse Jiang on 12/2/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)signup:(id)sender {
    
    // assign inputs to variable names, trim the username of any whitespace
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = self.passwordField.text;
    NSString *confirmPassword = self.confirmPasswordField.text;
    
    // check for valid inputs
    if ([username length] == 0 || [password length] == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Please enter a username and password!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if (![password isEqualToString:confirmPassword])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Passwords do not match!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else if ([password length] < 5)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Passwords must be at least 5 characters" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    // sign up user - all inputs are valid
    else
    {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error)
            {
                // if there is an error signing up
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                // no errors in signing up - send user to root view
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
    
}
@end
