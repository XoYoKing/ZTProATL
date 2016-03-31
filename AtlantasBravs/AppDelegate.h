//
//  AppDelegate.h
//  AtlantasBravs
//
//  Created by Zain Raza on 12/16/11.
//  Copyright (c) 2011 __Creative Gamers__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class RootViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,ADBannerViewDelegate>
{
    ADBannerView *adView;
    NSTimer *scheduleAlert;
    NSArray *winMessages;
    NSArray *lostMessages;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RootViewController *mainViewController;

@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, strong) UITabBarController *tabBarController;

- (void)setAdViewHidden:(BOOL)isHidden;

-(void)scheduleScoreAlert;

-(void)unscheduleScoreAlert;

@end
