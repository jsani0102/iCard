//
//  ConnectViewController.h
//  iCard
//
//  Created by Jayant Sani on 12/3/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

- (IBAction)addUser:(id)sender;

@end
