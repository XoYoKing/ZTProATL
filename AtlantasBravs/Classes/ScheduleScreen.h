//
//  ScheduleScreen.h
//  AtlantasBravs
//
//  Created by Guest on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "XMLReader.h"

@class DetailAlert;
@interface ScheduleScreen : UIViewController
<UITableViewDataSource, UITableViewDelegate,XMLParserCompleteDelegate>

{
    IBOutlet UITableView *schedTable;
    IBOutlet UISwitch *alarmSwitch;
    
    NSMutableArray *prevMatches;
    NSMutableArray *curMatches;
    DetailAlert *detailAlert;
    UIView *shadowView;
}

@property (weak, nonatomic) IBOutlet UIButton *btnSet;
@property (nonatomic) NSInteger ListIndx;

- (IBAction)alarmSwitched:(id)sender;
- (IBAction)setAlertsClicked:(id)sender;    // added by Ying

- (void)scheduleLocalNotify:(id)sender;
- (void)makeSchedule;
- (void)scheduleDone:(NSNumber*)a;
@end
