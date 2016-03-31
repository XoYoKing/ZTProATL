//
//  ScoreAlertTypeViewController.h
//  AtlantasBravs
//
//  Created by Sol on 5/26/15.
//
//

#import <UIKit/UIKit.h>

@interface ScoreAlertTypeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *teamAlerts;
}

@property (weak, nonatomic) IBOutlet UITableView *tblType;
@property (nonatomic, strong) NSDictionary *teamInfo;
@end
