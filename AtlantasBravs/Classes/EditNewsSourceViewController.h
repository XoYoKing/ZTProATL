//
//  EditNewsSourceViewController.h
//  AtlantasBravs
//
//  Created by Ying on 4/18/15.
//
//

#import <UIKit/UIKit.h>

@interface EditNewsSourceViewController : UIViewController {
    NSMutableArray *mySourceArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UITextField *addNameField;
@property (weak, nonatomic) IBOutlet UITextField *addLinkField;
@property (weak, nonatomic) IBOutlet UIButton *addSourceButton;

- (IBAction)addButtonClicked:(id)sender;
@end
