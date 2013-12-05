//
//  SignupViewController.h
//  iCard
//
//  Created by Jayant Sani on 12/2/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

- (IBAction)signup:(id)sender;

@end
