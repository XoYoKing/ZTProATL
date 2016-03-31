//
//  TwitterViewController.h
//  AtlantasBravs
//
//  Created by Anton Gubarenko on 02.05.13.
//
//

#import <UIKit/UIKit.h>

@interface TwitterViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *mainWeb;

- (IBAction)didTapBack:(id)sender;
- (IBAction)didTapNext:(id)sender;
- (IBAction)didTapRefresh:(id)sender;
- (IBAction)didTapHome:(id)sender;
@end
