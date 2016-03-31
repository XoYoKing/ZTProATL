//
//  LiveItemCell.h
//  AtlantasBravs
//
//  Created by Anton Gubarenko on 20.05.13.
//
//

#import <UIKit/UIKit.h>

@interface LiveItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *team1;
@property (strong, nonatomic) IBOutlet UILabel *score1;
@property (strong, nonatomic) IBOutlet UILabel *team2;
@property (strong, nonatomic) IBOutlet UILabel *score2;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *vsLabel;
@end
