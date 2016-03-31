//
//  AddNewSourceViewController.h
//  AtlantasBravs
//
//  Created by Sol on 5/15/15.
//
//

#import <UIKit/UIKit.h>

@protocol AddNewSourceViewControllerDelegate <NSObject>

-(void)doneAdd;

@end

@interface AddNewSourceViewController : UIViewController {
    NSMutableArray *mySourceArray;
}

@property (nonatomic, strong) NSMutableArray *serverSources;
@property (nonatomic, weak) id<AddNewSourceViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *txtSourceName;
@property (weak, nonatomic) IBOutlet UITextField *txtLink;
- (IBAction)onAdd:(id)sender;
@end
