//
//  LocalWebViewController.m
//  AtlantasBravs
//
//  Created by Anton Gubarenko on 02.05.13.
//
//

#import "LocalWebViewController.h"
#import "Resources.h"
#import "Globals.h"

@implementation LocalWebViewController

@synthesize urlToLoad, mainWeb,linkType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = CurrentTeamHeader;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMainWeb:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    if(linkType==0)
        urlToLoad = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=506294257"];
    else
        urlToLoad = linkType==1?[Globals sharedGlobals].lastFBLink:[Globals sharedGlobals].lastTWLink;
    //NSLog(@"%@",urlToLoad);
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mainWeb loadRequest:[NSURLRequest requestWithURL:urlToLoad]];
    [[Resources sharedResources] showNetworkingActivity];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[Resources sharedResources] hideNetworkIndicator];
   
    if(linkType==1)
        [Globals sharedGlobals].lastFBLink = mainWeb.request.URL;
    else
    if(linkType==2)
        [Globals sharedGlobals].lastTWLink = mainWeb.request.URL;
    
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
    if(mainWeb.canGoBack)
        [mainWeb goBack];
}

- (IBAction)didTapNext:(id)sender {
    if(mainWeb.canGoForward)
        [mainWeb goForward];
}

- (IBAction)didTapRefresh:(id)sender {
    [mainWeb reload];
}

- (IBAction)didTapHome:(id)sender {
    
    if(linkType==0)
        [mainWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.facebook.com"]]];
    else
        [mainWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.twitter.com/ZTProf"]]];
    
    [[Resources sharedResources] showNetworkingActivity];
}

@end
