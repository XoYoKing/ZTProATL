//
//  ESPNView.m
//  AtlantasBravs
//
//  Created by Guest on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ESPNView.h"
#import "Resources.h"
#import "LiveFeedViewController.h"

@implementation ESPNView

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
    [[Resources sharedResources] RefreshData:NULL];
    
    // added by Ying
    [webView reload];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Scores" style:UIBarButtonItemStylePlain target:self action:@selector(didTapLiveScore:)];
/*
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
*/
    // updated by Ying
    self.navigationItem.rightBarButtonItem = [self addMenuBtn];//[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(doAction:)];
    ///////////////////
/*  // removed by Ying
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.theprofessionalssports.com/server/standing_2.php"]];
*/
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.theprofessionalssports.com/server/standing_2.php"]];   // added by Ying
    
    [[Resources sharedResources] showNetworkingActivity];
    [webView setDelegate:self];
    webView.scalesPageToFit = YES;
    [webView loadRequest:requestObj];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(UIBarButtonItem *)addMenuBtn
{
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 44, 44);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *menuBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    menuBtnView.bounds = CGRectOffset(menuBtnView.bounds, -10, 0);
    [menuBtnView addSubview:menuBtn];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtnView];
    return menuItem;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [[Resources sharedResources] hideNetworkIndicator];
    [webView setHidden:NO];     // added by Ying
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[Resources sharedResources] hideNetworkIndicator];
    [webView setHidden:NO];     // added by Ying
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = [NSString stringWithFormat:@"ZTP %@ Standings", CurrentAppName];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[Resources sharedResources] hideNetworkIndicator];
    [super viewWillDisappear:animated];
}

// added by Ying
-(IBAction)doAction:(id)sender{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Please choose an option" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *refresh = [UIAlertAction actionWithTitle:@"Refresh Standings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self refresh:nil];
    }];
    
    UIAlertAction *simple = [UIAlertAction actionWithTitle:@"Simple Standings View" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        webView.scalesPageToFit = NO;
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.theprofessionalssports.com/server/standing_2_simple.php"]];
        
        [[Resources sharedResources] showNetworkingActivity];
        [webView setHidden:YES];
        [webView loadRequest:requestObj];
    }];
    
    UIAlertAction *detail = [UIAlertAction actionWithTitle:@"Detailed Standings View" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        webView.scalesPageToFit = YES;
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.theprofessionalssports.com/server/standing_2.php"]];
        
        [[Resources sharedResources] showNetworkingActivity];
        [webView loadRequest:requestObj];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [sheet addAction:refresh];
    [sheet addAction:simple];
    [sheet addAction:detail];
    [sheet addAction:cancel];
    
    [self presentViewController:sheet animated:YES completion:nil];
}
@end
