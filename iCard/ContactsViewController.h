//
//  ContactsViewController.h
//  iCard
//
//  Created by Jayant Sani on 12/1/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UITableViewController

@property (strong, nonatomic) NSArray *friends;

- (IBAction)logout:(id)sender;

@end
