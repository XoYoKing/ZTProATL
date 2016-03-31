//
//  TwitterViewController.m
//  AtlantasBravs
//
//  Created by Anton Gubarenko on 02.05.13.
//
//

#import "TwitterViewController.h"
#import "Resources.h"
#import "Tweet.h"
#import "LiveFeedViewController.h"
#import "AppDelegate.h"

@implementation TwitterViewController

int firstLoad;

- (void)viewDidLoad
{
    [super viewDidLoad];    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = [NSString stringWithFormat:@"ZTP %@ Tweets", CurrentAppName];
    firstLoad = YES;
    [self addNavigationItems];
}

- (void)addNavigationItems
{
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"  <  " style:UIBarButtonItemStylePlain target:self action:@selector(didTapBack:)], [[UIBarButtonItem alloc] initWithTitle:@"  >  " style:UIBarButtonItemStylePlain target:self action:@selector(didTapNext:)]];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(didTapHome:)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(didTapRefresh:)]];
}

-(void)didTapLiveScore:(id)sender
{
    //Go To Live Feed
    [[Resources sharedResources] NavigateLiveFeed];
    LiveFeedViewController *viewController = [[LiveFeedViewController alloc] initWithNibName:@"LiveFeedViewController" bundle:nil];
    self.navigationItem.title = @"Back";
    [self.navigationController pushViewController:viewController animated:YES];
    NSLog(@"LiveFeedView");
}

-(IBAction)refresh:(id)sender
{
    //Refreshing
    [[Resources sharedResources] RefreshData:nil];
}

- (void)viewDidUnload {
    [self setMainWeb:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Tweets", CurrentAppName];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setAdViewHidden:YES];
    if(firstLoad)
    {
        firstLoad = NO;
        [_mainWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:CurrentTeamTwitterLink]]];
        [[Resources sharedResources] showNetworkingActivity];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[Resources sharedResources] hideNetworkIndicator];
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setAdViewHidden:NO];
    [super viewWillDisappear:animated];
}

#pragma UIWebView Delagate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[Resources sharedResources] hideNetworkIndicator];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[Resources sharedResources] hideNetworkIndicator];
}

- (IBAction)didTapBack:(id)sender {
    if(_mainWeb.canGoBack)
        [_mainWeb goBack];
}

- (IBAction)didTapNext:(id)sender {
    if(_mainWeb.canGoForward)
        [_mainWeb goForward];
}

- (IBAction)didTapRefresh:(id)sender {
    [_mainWeb reload];
}

- (IBAction)didTapHome:(id)sender {
    [_mainWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:CurrentTeamTwitterLink]]];
    [[Resources sharedResources] showNetworkingActivity];
}
@end
