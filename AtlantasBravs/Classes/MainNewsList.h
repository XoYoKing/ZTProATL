//
//  MainNewsList.h
//  AtlantasBravs
//
//  Created by Guest on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "XMLReader.h"

@interface MainNewsList : UIViewController
<UITableViewDataSource, UITableViewDelegate, XMLParserCompleteDelegate,UIActionSheetDelegate>
{
    IBOutlet UITableView *newsTableView;
    int newsType;
    UIRefreshControl *refreshControl;   // added by Ying
}

-(IBAction)refresh:(id)sender;

@end
