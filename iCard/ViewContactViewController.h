//
//  ViewContactViewController.h
//  iCard
//
//  Created by Jayant Sani and Jesse Jiang on 12/5/13.
//  Copyright (c) 2013 Jayant Sani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewContactViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (nonatomic, strong) NSString *twitterHandle;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, strong) NSString *instagramHandle;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *instagramButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;

- (IBAction)addOnFacebook:(id)sender;
- (IBAction)followOnInstagram:(id)sender;
- (IBAction)followOnTwitter:(id)sender;


@end
