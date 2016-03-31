//
//  LocalWebViewController.h
//  AtlantasBravs
//
//  Created by Anton Gubarenko on 02.05.13.
//
//

#import <UIKit/UIKit.h>

@interface LocalWebViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,retain) NSURL *urlToLoad;

//0 - Facebook, 1- Twitter
@property (nonatomic) int linkType;

@property (strong, nonatomic) IBOutlet UIWebView *mainWeb;

- (IBAction)didTapBack:(id)sender;
- (IBAction)didTapNext:(id)sender;
- (IBAction)didTapRefresh:(id)sender;
- (IBAction)didTapHome:(id)sender;
@end
