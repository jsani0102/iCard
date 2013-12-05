//
//  ConnectViewController.m
//  iCard
//
//  Created by Jayant Sani on 12/3/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import "ConnectViewController.h"

@interface ConnectViewController ()

@end

@implementation ConnectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)addUser:(id)sender {
    // adds user to the parse backend database to show up in the contacts viewController
    NSString *username = self.usernameField.text;
    
    // TODO - save PFRelation to parse between the two users and somehow navigate to the contactsViewController
}
@end
