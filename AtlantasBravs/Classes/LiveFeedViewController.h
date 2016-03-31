//
//  LiveFeedViewController.h
//  AtlantasBravs
//
//  Created by Anton Gubarenko on 26.04.13.
//
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "XMLReader.h"

@interface LiveFeedViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,ADBannerViewDelegate,XMLParserCompleteDelegate>
{
    IBOutlet UITableView *liveFeedTable;
    IBOutlet ADBannerView *adview;
    NSTimer *updateTimer;
    UIRefreshControl *refreshControl;   // added by Ying
}
@end
