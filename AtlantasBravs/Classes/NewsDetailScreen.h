//
//  NewsDetailScreen.h
//  AtlantasBravs
//
//  Created by Guest on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "XMLReader.h"

#import <FacebookSDK/FacebookSDK.h>
#import "KGModal.h"
#import <MessageUI/MessageUI.h>

@interface NewsDetailScreen : UIViewController 
<UIScrollViewDelegate,UIWebViewDelegate,ADBannerViewDelegate,
FBRequestDelegate, UIActionSheetDelegate, XMLParserCompleteDelegate, KGModalDelegate,MFMessageComposeViewControllerDelegate>
{
    IBOutlet UIImageView *mainImageView;
    NSInteger itemIndex;
    IBOutlet UIView *fullScreenView;
    UIWebView *espnWeb;
}

@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIView *fullScreenView;
@property (nonatomic, strong) UIWebView *espnWeb;
@property (nonatomic, strong) UIActivityIndicatorView *networkActivityIndicator;



@property (nonatomic) NSInteger itemIndex;

-(IBAction)popView:(id)sender;

-(IBAction)showFullNews:(id)sender;

-(IBAction)shareNewsFB:(id)sender;

- (void)showError;
-(void)showNetworkingIndicator;
-(void)hideNetworkingIndicator;


@end
