//
//  AlertsViewController.h
//  AtlantasBravs
//
//  Created by Sol on 5/20/15.
//
//

#import <UIKit/UIKit.h>

@interface AlertsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *customAlerts;
    NSMutableArray *selAlerts;
}

@property (weak, nonatomic) IBOutlet UITableView *tblAlerts;
@end
