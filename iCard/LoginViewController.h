//
//  LoginViewController.h
//  iCard
//
//  Created by Jayant Sani and Jesse Jiang on 12/2/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)login:(id)sender;

@end
