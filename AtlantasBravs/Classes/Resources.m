//
//  Resources.m
//  AtlantasBravs
//
//  Created by Zain Raza on 12/16/11.
//  Copyright (c) 2011 __Creative Gamers__. All rights reserved.
//

#import "Resources.h"

#import "MainNewsList.h"
#import "NewsDetailScreen.h"
#import "ScheduleScreen.h"
#import "ESPNView.h"
#import "AppDelegate.h"

#import "GameViewController.h"
#import "LiveFeedViewController.h"

//Singleton instance of Resources
static Resources *resources;

@implementation Resources

@synthesize xmlReader;

@synthesize schedNotifier;

@synthesize xmlTotalNews;
@synthesize xmlTotalMatches;

@synthesize newsList;
@synthesize teamList;
@synthesize matchesList;
@synthesize liveList;
@synthesize nationsList;
@synthesize tweets;
@synthesize networkActivityView;
@synthesize selRssList;    // added by Ying


@synthesize navigationController;

+ (Resources *)sharedResources {
    if (resources == NULL && resources == nil) {
        resources = [[Resources alloc] init];
    }
    return resources;
}

-(id) init {
    self = [super init];
    
    
    newsList = [[NSMutableArray alloc] init];
    matchesList = [[NSMutableArray alloc] init];
    liveList = [[NSMutableArray alloc] init];
    nationsList = [NSMutableArray new];
    tweets = [NSMutableArray new];
    selRssList = [[NSMutableArray alloc] init];    // added by Ying
    return self;
}

- (XMLReader *)getXMLReader {
    if(xmlReader == NULL && xmlReader == nil) {
        xmlReader = [[XMLReader alloc] init];
    }
    
	return xmlReader;
}

- (ScheduleNotifier *)getScheduleNotifier
{
    if(schedNotifier == NULL)
    {
        schedNotifier = [[ScheduleNotifier alloc] init];
    }
    return schedNotifier;
}

-(UIImage *)fullNewsImage
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"read.png"];
    UIImage *fullNewsImg = [[UIImage alloc] initWithContentsOfFile:path];
    
    return fullNewsImg;
}
-(UIImage *)vsImage
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"vs.png"];
    UIImage *vImage = [[UIImage alloc] initWithContentsOfFile:path];
    
    return vImage;
}
-(UIImage *)atImage
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"at.png"];
    UIImage *aImage = [[UIImage alloc] initWithContentsOfFile:path];
    
    return aImage;
}

-(UIImage *)AlarmCheck
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Alarm-Check-UI-32.png"];
    UIImage *bellImge = [[UIImage alloc] initWithContentsOfFile:path];
    
    return bellImge;
}

-(UIImage *)AlarmOff
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"Alarm-Off-UI-32.png"];
    UIImage *bellImge = [[UIImage alloc] initWithContentsOfFile:path];
    
    return bellImge;
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [[Resources sharedResources] showAlertWithTitle:@"Error" withBody:@"Error occured while parsing data."];
}
-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    [[Resources sharedResources] showAlertWithTitle:@"Error" withBody:@"Error occured while validating data."];
}
-(void)showNetworkingActivity {
    
    if(self.networkActivityView == nil)
    {
        self.networkActivityView = [[NetworkActivityView alloc] initWithFrame:[self getCurrentWindow].frame];
        [self.networkActivityView initIndicator];
        
    }
    if(![[[self getCurrentWindow] subviews] containsObject:self.networkActivityView])
        [[self getCurrentWindow] addSubview:self.networkActivityView];
    [[self getCurrentWindow] bringSubviewToFront:self.networkActivityView];
    [self.networkActivityView startAcitivity];
}

-(void)hideNetworkIndicator
{
	if(self.networkActivityView != nil)
	{
        [self.networkActivityView stopAcitivity];
	}
    
}
-(UIWindow *) getCurrentWindow {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}



-(void)showAlertWithTitle:(NSString *)title withBody:(NSString *)body {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:title
                          message:body
                          delegate:nil
                          cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alert show];
    
    alert = nil;
}

-(void)RefreshGeneralData:(id<XMLParserCompleteDelegate>)xdelegate
{
    [[Resources sharedResources] showNetworkingActivity];
    [[[Resources sharedResources] getXMLReader] parseXMLForGeneralNews:xdelegate];
}

-(void)RefreshData:(id<XMLParserCompleteDelegate>)xdelegate
{
    [[Resources sharedResources] showNetworkingActivity];
    [[[Resources sharedResources] getXMLReader] parseXMLForNews:xdelegate];
}

-(void)RefreshLiveFeedData:(id<XMLParserCompleteDelegate>)xdelegate
{
    [[Resources sharedResources] showNetworkingActivity];
    [[[Resources sharedResources] getXMLReader] parseXMLForLiveFeed:xdelegate];
}

-(NSMutableArray *)getMatchesList
{
    for (ScheduleItem *item in matchesList)
    {
        BOOL isSched = [[[Resources sharedResources] getScheduleNotifier] getIsMatchScheduled:[item matchId]];
        
        [item setAlarm:isSched];
    }
    
    return matchesList;
}

-(void)NavigateToTab
{
    [self hideNetworkIndicator];
    
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    [navigationController pushViewController:app.tabBarController animated:YES];
    //NSLog(@"TabController");
}


-(void)NavigateNewsList
{
    [self hideNetworkIndicator];
    //[self.navigationController popToRootViewControllerAnimated:NO];
    MainNewsList *viewController = [[MainNewsList alloc] initWithNibName:[Util isIphone5Display] ? @"MainNewsList-5" : @"MainNewsList" bundle:nil];
    [navigationController pushViewController:viewController animated:YES];
    NSLog(@"NavigateNewsList");
    viewController = nil;
    
}
-(void)NavigateNewsDetail:(int)itemIndex
{
    [self hideNetworkIndicator];
    //[self.navigationController popToRootViewControllerAnimated:NO];
    
    NewsDetailScreen *viewController = [[NewsDetailScreen alloc] initWithNibName:[Util isIphone5Display] ? @"NewsDetailScreen-5" : @"NewsDetailScreen" bundle:nil];
    [viewController setItemIndex:itemIndex];
    
    [navigationController pushViewController:viewController animated:YES];
    NSLog(@"NavigateNewsDetail");
    viewController = nil;
}
-(void)NavigateESPNView
{
    [self hideNetworkIndicator];
    //[self.navigationController popToRootViewControllerAnimated:NO];
    
    ESPNView *viewController = [[ESPNView alloc] initWithNibName:[Util isIphone5Display] ? @"ESPNView-5" : @"ESPNView" bundle:nil];
    
    [navigationController pushViewController:viewController animated:YES];
    NSLog(@"NavigateESPNView");
    viewController = nil;
}
-(void)NavigateSchedule
{
    [self hideNetworkIndicator];
    //[self.navigationController popToRootViewControllerAnimated:NO];
    ScheduleScreen *viewController = [[ScheduleScreen alloc] initWithNibName:[Util isIphone5Display] ? @"ScheduleScreen-5" : @"ScheduleScreen" bundle:nil];
    
    [navigationController pushViewController:viewController animated:YES];
    NSLog(@"NavigateSchedule");
    viewController = nil;
}


-(void)NavigateGame
{
    [self hideNetworkIndicator];
    //[self.navigationController popToRootViewControllerAnimated:NO];
    GameViewController *viewController = [[GameViewController alloc] initWithNibName:[Util isIphone5Display] ? @"GameViewController-5" : @"GameViewController" bundle:nil];
    
    [navigationController pushViewController:viewController animated:YES];
    NSLog(@"NavigateGameView");
    viewController = nil;
}

-(void)NavigateLiveFeed
{
    [self hideNetworkIndicator];
    //[self.navigationController popToRootViewControllerAnimated:NO];
    
}



@end
