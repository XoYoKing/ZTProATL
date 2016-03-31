//
//  SetAlertsViewController.h
//  AtlantasBravs
//
//  Created by Ying on 4/23/15.
//
//

#import <UIKit/UIKit.h>

@class SetAlertsViewController;

@protocol SetAlertsViewControllerDelegate <NSObject>

-(void)addAlert:(SetAlertsViewController *)viewController minute:(int)minute;

@end

@interface SetAlertsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *timeField;
@property (weak, nonatomic) IBOutlet UIPickerView *picTime;

@property (weak,nonatomic) id<SetAlertsViewControllerDelegate> delegate;

- (IBAction)addButtonClicked:(id)sender;
@end
