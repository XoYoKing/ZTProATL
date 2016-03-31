//
//  RadioViewController.h
//  AtlantasBravs
//
//  Created by Sol on 5/18/15.
//
//

#import <UIKit/UIKit.h>

@interface RadioViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webRadio;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *radioName;
@end
