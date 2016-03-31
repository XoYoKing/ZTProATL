//
//  ScoreAlertViewController.h
//  AtlantasBravs
//
//  Created by Sol on 5/26/15.
//
//

#import <UIKit/UIKit.h>

@interface ScoreAlertViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *teamsList;
    BOOL firstLoading;
}

@property (weak, nonatomic) IBOutlet UITableView *tblTeams;
@end
