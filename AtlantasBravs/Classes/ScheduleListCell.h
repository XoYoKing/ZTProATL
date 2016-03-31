//
//  ScheduleListCell.h
//  AtlantasBravs
//
//  Created by Zain Raza on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleListCell : UITableViewCell
{
    
}
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *team1Label;
@property (nonatomic, strong) IBOutlet UILabel *team2Label;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *localTVLabel;
@property (weak, nonatomic) IBOutlet UILabel *localRadioLabel;
@property (weak, nonatomic) IBOutlet UILabel *probableStartersLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblTVRadio;

@end
