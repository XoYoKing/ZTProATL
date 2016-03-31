//
//  Resources.h
//  AtlantasBravs
//
//  Created by Zain Raza on 12/16/11.
//  Copyright (c) 2011 __Creative Gamers__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RootViewController.h"

#import "XMLReader.h"
#import "NewsItem.h"
#import "ScheduleItem.h"
#import "LiveItem.h"
#import "ScheduleNotifier.h"
#import "EntryItem.h"
#import "Tweet.h"

#import "NetworkActivityView.h"


@interface Resources : NSObject<NSXMLParserDelegate>

@property (nonatomic, strong) NetworkActivityView *networkActivityView;


@property (nonatomic, strong) XMLReader                 *xmlReader;

@property (nonatomic, strong) ScheduleNotifier          *schedNotifier;

@property (nonatomic) int xmlTotalNews;
@property (nonatomic) int xmlTotalMatches;

@property (nonatomic, strong) NSMutableArray *newsList;
@property (nonatomic, strong) NSMutableArray *matchesList;
@property (nonatomic, strong) NSMutableArray *liveList;
@property (nonatomic, strong) NSMutableArray *nationsList;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSMutableArray *selRssList;      // added by Ying
@property (nonatomic, strong) NSMutableArray *teamList;

@property (nonatomic, retain) NSString *twitterPage;
@property (nonatomic, retain) NSString *newsPage;

@property (nonatomic, strong) UINavigationController *navigationController;

//Singleton instance return
+ (Resources *)sharedResources;

- (XMLReader *)getXMLReader;

- (ScheduleNotifier *)getScheduleNotifier;

-(UIImage *)fullNewsImage;
-(UIImage *)vsImage;
-(UIImage *)atImage;
-(UIImage *)AlarmCheck;
-(UIImage *)AlarmOff;

-(void)showNetworkingActivity;
-(void)hideNetworkIndicator;



-(UIWindow *) getCurrentWindow;

-(void)showAlertWithTitle:(NSString *)title withBody:(NSString *)body;

-(void)RefreshGeneralData:(id<XMLParserCompleteDelegate>)xdelegate;
-(void)RefreshData:(id<XMLParserCompleteDelegate>)xdelegate;
-(void)RefreshLiveFeedData:(id<XMLParserCompleteDelegate>)xdelegate;

-(NSMutableArray *)getMatchesList;

-(void)NavigateToTab;
-(void)NavigateNewsList;
-(void)NavigateNewsDetail:(int)itemIndex;
-(void)NavigateESPNView;
-(void)NavigateSchedule;
-(void)NavigateGame;
-(void)NavigateLiveFeed;


@end
