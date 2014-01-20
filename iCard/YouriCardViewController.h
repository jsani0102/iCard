//
//  YouriCardViewController.h
//  iCard
//
//  Created by Jayant Sani and Jesse Jiang on 12/4/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouriCardViewController : UIViewController

@property (nonatomic, strong) NSString *twitterHandle;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *instagramHandle;
@property (weak, nonatomic) IBOutlet UITextField *instagramHandleField;

- (IBAction)enterInstagram:(id)sender;

- (IBAction)connectToTwitter:(id)sender;

- (IBAction)connectToFacebook:(id)sender;



@end
