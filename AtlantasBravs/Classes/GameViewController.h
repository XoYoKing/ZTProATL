//
//  GameViewController.h
//  AtlantasBravs
//
//  Created by MacBook on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface GameViewController : UIViewController <UIAlertViewDelegate,UIActionSheetDelegate,UITableViewDataSource, UITableViewDelegate>
{
}

@property (weak, nonatomic) IBOutlet UITableView *tblMenu;

@property (strong, nonatomic) IBOutlet UIScrollView *mainScroll;
- (IBAction)diaTapRate:(id)sender;
- (IBAction)didTapAbout:(id)sender;
- (IBAction)didTapFacebook:(id)sender;
- (IBAction)didTapTwitter:(id)sender;
- (IBAction)didTapStats:(id)sender;     // added by Ying
- (IBAction)didTapRadio:(id)sender;     // added by Ying
@end
