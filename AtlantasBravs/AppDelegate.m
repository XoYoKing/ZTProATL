//
//  AppDelegate.m
//  AtlantasBravs
//
//  Created by Zain Raza on 12/16/11.
//  Copyright (c) 2011 __Creative Gamers__. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

#import "Resources.h"
#import "HttpWorker.h"
#import "Util.h"

#import "MainNewsList.h"
#import "ScheduleScreen.h"
#import "ESPNView.h"
#import "GameViewController.h"
#import <iAd/iAd.h>
#import "TwitterViewController.h"
#import "Reachability.h"
#import "AFNetworking.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainViewController;
@synthesize navigationController;

@synthesize tabBarController;



-(void)applicationDidFinishLaunching:(UIApplication *)application {    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    int i = 0;
    for (i = 0; i < notifications.count; i++) {
        UILocalNotification *notification = (UILocalNotification *)[notifications objectAtIndex:i];
        NSDictionary *userInfo = notification.userInfo;
        NSLog(@"%@\n%@\n%@",userInfo,notification.fireDate, notification.alertBody);
    }
    
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"last_updated"] != nil) {
        NSDate *last_updated = (NSDate *)[defaults objectForKey:@"last_updated"];
        if ([[NSDate date] timeIntervalSinceDate:last_updated] >= 24 * 3600) {
            [application openURL:[NSURL URLWithString:@"webcal://mlb.am/tix/braves_schedule_full"]];
            [defaults setObject:[NSDate date] forKey:@"last_updated"];
            [defaults synchronize];
        }
    }else {
        [application openURL:[NSURL URLWithString:@"webcal://mlb.am/tix/braves_schedule_full"]];
        [defaults setObject:[NSDate date] forKey:@"last_updated"];
        [defaults synchronize];
    }*/
    //Creating Shared AdBanner
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.frame = CGRectOffset(adView.frame, 0, self.window.frame.size.height-99);
    adView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    adView.delegate=self;    
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert ];
    
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        // use registerUserNotificationSettings
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:notificationSettings];
        [application registerForRemoteNotifications];
        
    } else {
        // use registerForRemoteNotifications
        [application registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    
    mainViewController = [[RootViewController alloc] initWithNibName:[Util isIphone5Display] ? @"RootViewController-5" : @"RootViewController"
                                                              bundle:nil];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [self.navigationController setNavigationBarHidden:YES];
    if ([self.navigationController respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.window.rootViewController = self.navigationController;
    
    //Creating Views For the Tab
    UINavigationController *twItem = [[UINavigationController alloc] initWithRootViewController: [[TwitterViewController alloc] initWithNibName:@"TwitterViewController" bundle:nil]];
    twItem.tabBarItem.image = [UIImage imageNamed:@"tab0.png"];
    twItem.navigationBar.translucent = NO;
    [twItem.navigationBar setBarStyle:UIBarStyleBlack];
    
    
    UINavigationController *newsItem = [[UINavigationController alloc] initWithRootViewController: [[MainNewsList alloc] initWithNibName:[Util isIphone5Display] ? @"MainNewsList-5" : @"MainNewsList" bundle:nil]];
    newsItem.tabBarItem.image = [UIImage imageNamed:@"tab1.png"];
    newsItem.navigationBar.translucent = NO;
    [newsItem.navigationBar setBarStyle:UIBarStyleBlack];
    
    UINavigationController *schedItem = [[UINavigationController alloc] initWithRootViewController: [[ScheduleScreen alloc] initWithNibName:[Util isIphone5Display] ? @"ScheduleScreen-5" : @"ScheduleScreen" bundle:nil]];
    schedItem.tabBarItem.image = [UIImage imageNamed:@"tab2.png"];
    schedItem.navigationBar.translucent = NO;
    [schedItem.navigationBar setBarStyle:UIBarStyleBlack];
    
    UINavigationController *espItem = [[UINavigationController alloc] initWithRootViewController: [[ESPNView alloc] initWithNibName:[Util isIphone5Display] ? @"ESPNView-5" : @"ESPNView"
                                                                                                                             bundle:nil]];
    espItem.tabBarItem.image = [UIImage imageNamed:@"tab3.png"];
    espItem.navigationBar.translucent = NO;
    [espItem.navigationBar setBarStyle:UIBarStyleBlack];
    
    UINavigationController *gameItem = [[UINavigationController alloc] initWithRootViewController: [[GameViewController alloc] initWithNibName:[Util isIphone5Display] ? @"GameViewController-5" : @"GameViewController" bundle:nil]];
    gameItem.tabBarItem.image = [UIImage imageNamed:@"tab4.png"];
    gameItem.navigationBar.translucent = NO;
    [gameItem.navigationBar setBarStyle:UIBarStyleBlack];
    
    
    NSArray *controllers = [NSArray arrayWithObjects:newsItem,schedItem,espItem,twItem,gameItem,nil];
    
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = controllers;
    
    if ([tabBarController respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        tabBarController.tabBar.translucent = NO;
        tabBarController.edgesForExtendedLayout=UIRectEdgeNone;
        tabBarController.extendedLayoutIncludesOpaqueBars=NO;
        tabBarController.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    [[tabBarController.tabBar.items objectAtIndex:0] setTitle:@"News"];
    [[tabBarController.tabBar.items objectAtIndex:1] setTitle:@"Schedule"];
    [[tabBarController.tabBar.items objectAtIndex:2] setTitle:@"Standings"];
    [[tabBarController.tabBar.items objectAtIndex:3] setTitle:@"Tweets"];
    [[tabBarController.tabBar.items objectAtIndex:4] setTitle:@"More"];
    
    
    [tabBarController.view addSubview:adView];
    
    [self.window makeKeyAndVisible];
    
    [[Resources sharedResources] setNavigationController:self.navigationController];
    
    //parse XML:
    [[[Resources sharedResources] getXMLReader] parseXMLForNews:mainViewController];
    
    //[self getRssXmlFeed];
    
    //self.tabBarController = [[UITabBarController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)  name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:nil];
    
    [NSURLCache setSharedURLCache:sharedCache];
    NSDate *curDate = [NSDate date];
    NSTimeInterval timeInterval = -1;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"updatedAt"]) {
        NSDate *updatedAt = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"updatedAt"];
        timeInterval = [curDate timeIntervalSinceDate:updatedAt];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"teamAlerts"] != nil || ([[NSUserDefaults standardUserDefaults] objectForKey:@"motivation"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"motivation"] boolValue])) {
        [self scheduleScoreAlert];
    }else {
        [self unscheduleScoreAlert];
    }
    
    winMessages = @[@"%@ Won %d-%d against the %@! Mess with the best, die like the rest.",@"%@ Won %d-%d against the %@! Piece of cake.",@"%@ Won %d-%d against the %@! That was like playing in the peewee league.",@"%@ Won %d-%d against the %@! Kicken'ass, takin' names.", @"%@ Won %d-%d against the %@! Chuck Norris style.",@"%@ Won %d-%d against the %@! Look at those girls crying on the ground, See you next Tuesday pal. Yeah that was just said."];
    lostMessages = @[@"%@ Lost %d-%d against the %@. You're going to regret that.",@"%@ Lost %d-%d against the %@. Next time... Next time...."];
}

-(void)scheduleScoreAlert
{
    if (!scheduleAlert) {
        //scheduleAlert = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getScores) userInfo:nil repeats:YES];
    }
}

-(void)unscheduleScoreAlert
{
    if (scheduleAlert != nil && [scheduleAlert isValid]) {
        //[scheduleAlert invalidate];
        //scheduleAlert = nil;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"last_updated"] != nil) {
        NSDate *last_updated = (NSDate *)[defaults objectForKey:@"last_updated"];
        if ([[NSDate date] timeIntervalSinceDate:last_updated] >= 24 * 3600) {
            [application openURL:[NSURL URLWithString:@"webcal://mlb.am/tix/braves_schedule_full"]];
            [defaults setObject:[NSDate date] forKey:@"last_updated"];
            [defaults synchronize];
        }
    }else {
        [application openURL:[NSURL URLWithString:@"webcal://mlb.am/tix/braves_schedule_full"]];
        [defaults setObject:[NSDate date] forKey:@"last_updated"];
        [defaults synchronize];
    }*/
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {	
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
        NSLog(@"%@",userInfo);
    }
}
#endif

// Delegation methods
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceTokenString);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceTokenString forKey:@"deviceToken"];
    [defaults synchronize];
    [HttpWorker sendToken:deviceTokenString];
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive) {
        NSString *alertValue = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        [[[UIAlertView alloc] initWithTitle:@"ZTProATL" message:alertValue delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDate *notifDate = notification.fireDate;
    
    if(abs([notifDate timeIntervalSinceNow]- [[NSDate date] timeIntervalSinceNow])<5.0)
    {
        
        NSString *matchId = [[notification userInfo] objectForKey:@"MatchId"];
        
        NSLog(@"<<<<>>> NOTIFICATION RECEVIED FOR MI: %@",matchId);
        
        if (application.applicationState == UIApplicationStateActive) {
            [[[UIAlertView alloc] initWithTitle:@"ZTPro Game Alert" message:notification.alertBody delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else if(application.applicationState  == UIApplicationStateInactive){
            NSLog(@"UIApplicationStateInActive");
            //[[[UIAlertView alloc] initWithTitle:@"ZTPro Game Alert" message:notification.alertBody delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
        [[[Resources sharedResources] getScheduleNotifier] removeFromAlert:matchId matchTime:notifDate];
    }
}

#pragma AdBannerView Delegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    @try {
        [adView setHidden:NO];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    //NSLog(@"rcvd ad");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    @try {
        [adView setHidden:YES];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        NSLog(@"error ad %@",[error description]);
    }
}

- (void)orientationChanged:(NSNotification *)notification
{
    
}

- (void)setAdViewHidden:(BOOL)isHidden
{
    [adView setHidden:isHidden];
}

-(void)getRssXmlFeed
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if([reachability currentReachabilityStatus] == NotReachable){
        [Util displayAlertWithMessage:@"You are not connected to internet." tag:0];
        if(mainViewController!=nil)
            if ([mainViewController respondsToSelector:@selector(xmlParsingError:)]) {
                [mainViewController xmlParsingError:@"No Internet Connection"];
            }
        
        [[Resources sharedResources] hideNetworkIndicator];
        return;
    }
    
    [[Resources sharedResources] getXMLReader].delegate_ = mainViewController;
    
    [[Resources sharedResources] getXMLReader].parsingTag = 1;
    
    [[[Resources sharedResources] newsList] removeAllObjects];
    
    [[Resources sharedResources] showNetworkingActivity];
    
    NSMutableArray *selRssList = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selRssList"] != nil) {
        selRssList = [NSMutableArray arrayWithArray:(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"selRssList"]];
    }else {
        selRssList = [Resources sharedResources].selRssList;
    }
    for (int i = 0; i < selRssList.count; i++) {
        NSDictionary *source = [selRssList objectAtIndex:i];
        if ([source objectForKey:@"rsslink"] == nil || [[source objectForKey:@"rsslink"] isEqualToString:@""]) {
            continue;
        }
        dispatch_async(kBgQueue, ^{
            NSError *error;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[source objectForKey:@"rsslink"]]] ;
            NSData *xmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            if (!error) {
                NSString *xmlStr = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
                [[[Resources sharedResources] getXMLReader] insertNewsItemsFrom:[xmlStr dataUsingEncoding:NSUTF8StringEncoding]];
                [[[Resources sharedResources] getXMLReader] performSelectorOnMainThread:@selector(parseXMLForSchedule) withObject:xmlStr waitUntilDone:YES];
            }
        });
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"updatedAt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)getScores
{
    NSLog(@"Get Score:");
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://sports.espn.go.com/mlb/bottomline/scores"]]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultStr = operation.responseString;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *teamAlerts = [[NSMutableDictionary alloc] init];
        if ([defaults objectForKey:@"teamAlerts"]) {
            teamAlerts = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"teamAlerts"]];
        }
        NSMutableArray *prevScore = [NSMutableArray array];
        if ([defaults objectForKey:@"prevScore"] != nil) {
            prevScore = [NSMutableArray arrayWithArray:[defaults objectForKey:@"prevScore"]];
        }
        NSArray *resultArray = [resultStr componentsSeparatedByString:@"&"];
        int scoreCount = 0;
        for (NSString *resStr in resultArray) {
            NSRange range = [resStr rangeOfString:@"mlb_s_count"];
            if (range.location != NSNotFound) {
                scoreCount = [[resStr substringFromIndex:12] intValue];
            }
        }
        NSMutableArray *scores = [[NSMutableArray alloc] init];
        NSMutableDictionary *score = [[NSMutableDictionary alloc] init];
        for (NSString *content in resultArray) {
            NSRange range = [content rangeOfString:@"_left"];
            if (range.location != NSNotFound) {
                NSRange equalRange = [content rangeOfString:@"="];
                NSString *title = [content substringFromIndex:equalRange.location + 1];
                //title = [title stringByReplacingOccurrencesOfString:@"^" withString:@""];
                title = [title stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
                [score setObject:title forKey:@"title"];
                
            }
            range = [content rangeOfString:@"_url"];
            if (range.location != NSNotFound) {
                NSRange equalRange = [content rangeOfString:@"="];
                NSString *url = [content substringFromIndex:equalRange.location + 1];
                url = [url stringByReplacingOccurrencesOfString:@"^" withString:@""];
                url = [url stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
                [score setObject:url forKey:@"url"];
                
            }
            if (score.allKeys.count == 2) {
                [scores addObject:[NSMutableDictionary dictionaryWithDictionary:score]];
                [score removeObjectForKey:@"title"];
                [score removeObjectForKey:@"url"];
            }
        }
        NSMutableArray *teamScores = [[NSMutableArray alloc] init];
        for (NSDictionary *score in scores) {
            LiveItem *item = [[LiveItem alloc] init];
            item.liveTitle = [score objectForKey:@"title"];
            item.liveLink = [score objectForKey:@"url"];
            NSRange range = [item.liveTitle rangeOfString:@"  "];
            /* added by Ying */
            if (range.length == 0) {
                range = [item.liveTitle rangeOfString:@"at"];
            }
            ///////////////////////////////////////////////////////
            NSString *team1 = [item.liveTitle substringToIndex:range.location];
            NSString *team2 = [item.liveTitle substringFromIndex:range.location+3];
            
            NSRange rangeIn = [team2 rangeOfString:@"("];
            NSString *inning = [team2 substringFromIndex:rangeIn.location+1];
            inning = [inning substringToIndex:inning.length-1];
            NSString *team2Str = [team2 substringToIndex:rangeIn.location-1];
            NSString *team1Str = [NSString stringWithFormat:@"%@",team1];
            
            
            NSRange range1 = [team1Str rangeOfString:@" " options:NSBackwardsSearch];
            NSRange range2 = [team2Str rangeOfString:@" " options:NSBackwardsSearch];
            int score1 = -1, score2 = -1;
            if(range1.location != NSNotFound)
            {
                team1 = [team1Str substringToIndex:range1.location];
                score1 = [[team1Str substringFromIndex:range1.location+1] intValue];
            }
            if(range2.location != NSNotFound)
            {
                team2 = [team2Str substringToIndex:range2.location];
                score2 = [[team2Str substringFromIndex:range2.location+1] intValue];
            }
            [teamScores addObject:@{@"team1":team1,@"score1":@(score1),@"team2":team2,@"score2":@(score2)}];
        }
        
        for (NSDictionary *teamScore in teamScores) {
            NSString *team1 = [teamScore objectForKey:@"team1"];
            NSString *team2 = [teamScore objectForKey:@"team2"];
            int score1 = [[teamScore objectForKey:@"score1"] intValue];
            int score2 = [[teamScore objectForKey:@"score2"] intValue];
            NSString *shortteam1 = team1;
            NSString *shortteam2 = team2;
            if ([team1 rangeOfString:@"^"].location != NSNotFound) {
                shortteam1 = [team1 substringFromIndex:1];
            }
            if ([team2 rangeOfString:@"^"].location != NSNotFound) {
                shortteam2 = [team2 substringFromIndex:1];
            }
            
            int selectedIndex = -1;
            for (int i = 0; i < prevScore.count; i++) {
                NSMutableDictionary *oneScore = [NSMutableDictionary dictionaryWithDictionary:[prevScore objectAtIndex:i]];
                if (![[oneScore objectForKey:@"done"] boolValue]) {
                    continue;
                }
                if (([team1 rangeOfString:[oneScore objectForKey:@"team1"]].location != NSNotFound && [team2 rangeOfString:[oneScore objectForKey:@"team2"]].location != NSNotFound) || ([team1 rangeOfString:[oneScore objectForKey:@"team2"]].location != NSNotFound && [team2 rangeOfString:[oneScore objectForKey:@"team1"]].location != NSNotFound)) {
                    if ([team1 rangeOfString:@"^"].location == NSNotFound && [team2 rangeOfString:@"^"].location == NSNotFound) {
                        [oneScore setObject:@(NO) forKey:@"done"];
                    }
                    [prevScore setObject:oneScore atIndexedSubscript:i];
                    selectedIndex = i;
                    break;
                }
            }
            if (score1 > 0 || score2 > 0) {
                if ([defaults objectForKey:@"motivation"] && [[defaults objectForKey:@"motivation"] boolValue]) {
                    int i = 0;
                    for (i = 0; i < prevScore.count; i++) {
                        NSDictionary *oneScore = [prevScore objectAtIndex:i];
                        NSString *prevteam1 = [oneScore objectForKey:@"team1"];
                        NSString *prevteam2 = [oneScore objectForKey:@"team2"];
                        if ([[oneScore objectForKey:@"done"] boolValue] && [prevteam1 isEqualToString:shortteam1] && [prevteam2 isEqualToString:shortteam2]) {
                            break;
                        }
                    }
                    if (i == prevScore.count && ([team1 rangeOfString:@"^"].location != NSNotFound || [team2 rangeOfString:@"^"].location != NSNotFound)) {
                        if ((score1 > score2 || score1 < score2) && ([shortteam1 isEqualToString:@"Atlanta"] || [shortteam2 isEqualToString:@"Atlanta"])) {
                            if (selectedIndex == -1) {
                                [prevScore addObject:@{@"team1":shortteam1,@"team2":shortteam2,@"score1":@(score1),@"score2":@(score2),@"done":@(YES)}];
                            }else {
                                NSMutableDictionary *oneScore = [NSMutableDictionary dictionaryWithDictionary:[prevScore objectAtIndex:selectedIndex]];
                                [oneScore setObject:@(score1) forKey:@"score1"];
                                [oneScore setObject:@(score2) forKey:@"score2"];
                                [oneScore setObject:@(YES) forKey:@"done"];
                                [prevScore setObject:oneScore atIndexedSubscript:selectedIndex];
                            }
                            if (score1 > score2) {
                                if ([shortteam1 isEqualToString:@"Atlanta"]) {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:[winMessages objectAtIndex:(arc4random() % winMessages.count)],shortteam1,score1,score2,shortteam2] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [alertView show];
                                }else {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:[lostMessages objectAtIndex:(arc4random() % lostMessages.count)],shortteam2,score2,score1,shortteam1] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }else {
                                if ([shortteam1 isEqualToString:@"Atlanta"]) {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:[lostMessages objectAtIndex:(arc4random() % lostMessages.count)],shortteam1,score1,score2,shortteam2] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [alertView show];
                                }else {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:[winMessages objectAtIndex:(arc4random() % winMessages.count)],shortteam2,score2,score1,shortteam1] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }
                        }
                    }
                }
                for (NSString *shortName in teamAlerts.allKeys) {
                    NSArray *alertTypes = [teamAlerts objectForKey:shortName];
                    if ([alertTypes containsObject:@(0)]) {
                        for (int i = 0; i < prevScore.count; i++) {
                            NSDictionary *oneScore = [prevScore objectAtIndex:i];
                            NSString *prevteam1 = [oneScore objectForKey:@"team1"];
                            NSString *prevteam2 = [oneScore objectForKey:@"team2"];
                            int prevscore1 = [[oneScore objectForKey:@"score1"] intValue];
                            int prevscore2 = [[oneScore objectForKey:@"score2"] intValue];
                            if ([[oneScore objectForKey:@"done"] boolValue]) {
                                continue;
                            }
                            if ([prevteam1 isEqualToString:shortName] || [prevteam2 isEqualToString:shortName]) {
                                if (([shortteam1 isEqualToString:prevteam1] && [shortteam2 isEqualToString:prevteam2]) || ([shortteam1 isEqualToString:prevteam2] && [shortteam2 isEqualToString:prevteam1])) {
                                    if ((prevscore1 >= prevscore2 && score1 < score2) || (prevscore1 <= prevscore2 && score1 > score2)) {
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Change in lead between %@ and %@(%d-%d)",shortteam1,shortteam2,score1,score2] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alertView show];
                                        if (selectedIndex == -1) {
                                            [prevScore addObject:@{@"team1":shortteam1,@"team2":shortteam2,@"score1":@(score1),@"score2":@(score2),@"done":@(NO)}];
                                        }else {
                                            NSMutableDictionary *oneScore = [NSMutableDictionary dictionaryWithDictionary:[prevScore objectAtIndex:selectedIndex]];
                                            [oneScore setObject:@(score1) forKey:@"score1"];
                                            [oneScore setObject:@(score2) forKey:@"score2"];
                                            [oneScore setObject:@(NO) forKey:@"done"];
                                            [prevScore setObject:oneScore atIndexedSubscript:selectedIndex];
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    int i = 0;
                    for (i = 0; i < prevScore.count; i++) {
                        NSDictionary *oneScore = [prevScore objectAtIndex:i];
                        NSString *prevteam1 = [oneScore objectForKey:@"team1"];
                        NSString *prevteam2 = [oneScore objectForKey:@"team2"];
                        if ([[oneScore objectForKey:@"done"] boolValue] && [prevteam1 isEqualToString:shortteam1] && [prevteam2 isEqualToString:shortteam2]) {
                            break;
                        }
                    }
                    if (i == prevScore.count && ([team1 rangeOfString:@"^"].location != NSNotFound || [team2 rangeOfString:@"^"].location != NSNotFound)) {
                        if ([alertTypes containsObject:@(1)]) {
                            if (score1 == score2 && ([shortteam1 isEqualToString:shortName] || [shortteam2 isEqualToString:shortName])) {
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Tied game between %@ and %@(%d-%d)",shortteam1,shortteam2,score1,score2] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [alertView show];
                            }
                        }
                        if ([alertTypes containsObject:@(2)]) {
                            if ((score1 > score2 || score1 < score2) && ([shortteam1 isEqualToString:shortName] || [shortteam2 isEqualToString:shortName])) {
                                if (selectedIndex == -1) {
                                    [prevScore addObject:@{@"team1":shortteam1,@"team2":shortteam2,@"score1":@(score1),@"score2":@(score2),@"done":@(YES)}];
                                }else {
                                    NSMutableDictionary *oneScore = [NSMutableDictionary dictionaryWithDictionary:[prevScore objectAtIndex:selectedIndex]];
                                    [oneScore setObject:@(score1) forKey:@"score1"];
                                    [oneScore setObject:@(score2) forKey:@"score2"];
                                    [oneScore setObject:@(YES) forKey:@"done"];
                                    [prevScore setObject:oneScore atIndexedSubscript:selectedIndex];
                                }
                                if (score1 > score2) {
                                    if ([shortteam1 isEqualToString:shortName]) {
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@ Won %d-%d against the %@",shortteam1,score1,score2,shortteam2] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alertView show];
                                    }else {
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@ Lost %d-%d against the %@",shortteam2,score2,score1,shortteam1] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alertView show];
                                    }
                                }else {
                                    if ([shortteam1 isEqualToString:shortName]) {
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@ Lost %d-%d against the %@",shortteam1,score1,score2,shortteam2] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alertView show];
                                    }else {
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@ Won %d-%d against the %@",shortteam2,score2,score1,shortteam1] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [alertView show];
                                    }
                                }
                            }
                        }
                    }
                }
            }
            [defaults setObject:prevScore forKey:@"prevScore"];
            [defaults synchronize];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [operation start];
}
@end
