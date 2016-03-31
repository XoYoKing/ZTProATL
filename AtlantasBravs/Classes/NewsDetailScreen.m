//
//  NewsDetailScreen.m
//  AtlantasBravs
//
//  Created by Guest on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsDetailScreen.h"
#import "Resources.h"
//#import "JHTickerView.h"
#import "Reachability.h"
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import "Resources.h"
#import <FacebookSDK/FacebookSDK.h>
#import "JSON.h"

@implementation NewsDetailScreen

@synthesize mainImageView;
@synthesize fullScreenView;

@synthesize itemIndex;
@synthesize espnWeb;
@synthesize networkActivityIndicator;

bool firstLoad;

-(IBAction)refresh:(id)sender
{
    [[Resources sharedResources] hideNetworkIndicator];
    [self hideNetworkingIndicator];
    [[Resources sharedResources] RefreshData:NULL];
}

-(IBAction)popView:(id)sender
{
    [espnWeb setDelegate:nil];
    [[Resources sharedResources] hideNetworkIndicator];
    [self hideNetworkingIndicator];
    //[[Resources sharedResources] NavigateNewsList];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)xmlParsingComplete
{
    
}

- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"doesNotRecognizeSelector: %@",NSStringFromSelector(aSelector));
}


-(IBAction)showFullNews:(id)sender
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if([reachability currentReachabilityStatus] == NotReachable){
        [Util displayAlertWithMessage:@"You are not connected to internet." tag:0];
        return;
    }
    
    [[Resources sharedResources] showNetworkingActivity];
    
    float width = fullScreenView.frame.size.width;
    float height = fullScreenView.frame.size.height;
    
    UIScrollView *zoomScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    zoomScroller.minimumZoomScale=1.0;
    zoomScroller.maximumZoomScale=6.0;
    zoomScroller.delegate=self;
    espnWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [espnWeb setBackgroundColor:[UIColor clearColor]];
    NewsItem *item = [[[Resources sharedResources] newsList] objectAtIndex:itemIndex];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:item.newsLink]];
    [espnWeb setTag:105];
    [espnWeb setDelegate:self];
    [espnWeb loadRequest:requestObj];
    [espnWeb setScalesPageToFit:YES];
    [espnWeb setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [leftSwipeRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [espnWeb addGestureRecognizer:leftSwipeRecognizer];
    
    UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDetected:)];
    [rightSwipeRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
    [espnWeb addGestureRecognizer:rightSwipeRecognizer];
    
    [self showNetworkingIndicator];
    
    [zoomScroller addSubview:espnWeb];
    [zoomScroller setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    //    [espnWeb release];
    //    espnWeb = nil;
    [fullScreenView setHidden:NO];
    [fullScreenView addSubview:zoomScroller];
    //[[KGModal sharedInstance] showWithContentView:zoomScroller andAnimated:YES andParent:fullScreenView andDelegate:self];
}

- (void)windowClosed
{
    [fullScreenView setHidden:YES];
    [[KGModal sharedInstance] setKGDelegate:NULL];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIWebView *childWebView = (UIWebView *)[scrollView viewWithTag:105];
    
    return childWebView;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[Resources sharedResources] hideNetworkIndicator];
    [self hideNetworkingIndicator];
    [webView setDelegate:NULL];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] != NSURLErrorCancelled)
    {
        NSLog(@"Error %@",error);
        //    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self hideNetworkingIndicator];
        [[Resources sharedResources] hideNetworkIndicator];
        [webView setDelegate:NULL];
        //[self performSelector:@selector(showError) withObject:NULL afterDelay:0.2];
        [self showError];
    }
}

- (void)showError
{
    [[Resources sharedResources] showAlertWithTitle:@"Info" withBody:@"Network error occured, Please try later."];
    [[Resources sharedResources] hideNetworkIndicator];
}

-(IBAction)shareNewsFB:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What would you like us to do?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook",@"Email Article to a Friend",@"Share on Twitter",@"SMS Article to a Friend", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NewsItem *item = [[[Resources sharedResources] newsList] objectAtIndex:itemIndex];
    
    switch (buttonIndex) {
        case 0:
        {
            
            SBJSON *jsonWriter = [SBJSON new];
            
            // The action links to be shown with the post in the feed
            NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              @"Get Started",@"name",[item newsLink],@"link", nil], nil];
            NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
            // Dialog parameters
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [item newsTitle], @"name",
                                           @"ATL Baseball", @"caption",
                                           /*[item newsDesc], @"description",*/
                                           [item newsLink], @"link",
                                           //@"http://www.facebookmobileweb.com/hackbook/img/facebook_icon_large.png", @"picture",
                                           actionLinksStr, @"actions",
                                           nil];
            
            [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                   parameters:params
                                                      handler:
             ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                 if (error) {
                     // Error launching the dialog or publishing a story.
                     NSLog(@"Error publishing story.");
                 } else {
                     if (result == FBWebDialogResultDialogNotCompleted) {
                         // User clicked the "x" icon
                         NSLog(@"User canceled story publishing.");
                     } else {
                         // Handle the publish feed callback
                         NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                         if (![urlParams valueForKey:@"post_id"]) {
                             // User clicked the Cancel button
                             NSLog(@"User canceled story publishing.");
                         } else {
                             // User clicked the Share button
                             NSString *msg = [NSString stringWithFormat:
                                              @"Posted story, id: %@",
                                              [urlParams valueForKey:@"post_id"]];
                             NSLog(@"%@", msg);
                         }
                     }
                 }
             }];
            
            break;
        }
        case 1:
        {
            // Launches the Mail application on the device.
            NSString *recipients = @"mailto:?";
            NSString *subject = [item newsTitle];
            NSString *body = [NSString stringWithFormat:@"%@",/*[item newsDesc],*/[item newsLink]];
            
            NSString *email = [NSString stringWithFormat:@"%@&subject=%@&body=%@", recipients, subject, body];
            email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *emailURL = [NSURL URLWithString:email];
            
            [[UIApplication sharedApplication] openURL:emailURL];
            break;
        }
        case 2:
        {
            Class tweeterClass = NSClassFromString(@"TWTweetComposeViewController");
            if (tweeterClass == nil) {
                [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Twitter Integration is not supported" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            }
            else
                if ([TWTweetComposeViewController canSendTweet]) {
                    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
                    //Composing Body
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
                    NSString *body = [NSString stringWithFormat:@"%@\n\n%@\n\nPosted on: %@", [item newsTitle],[item newsLink],[dateFormatter stringFromDate:[item newsDateTimeLocal]] ];
                    [tweetViewController setInitialText:body];
                    
                    tweetViewController.completionHandler = ^(TWTweetComposeViewControllerResult result) {
                        if (result == TWTweetComposeViewControllerResultDone) {
                        } else if (result == TWTweetComposeViewControllerResultCancelled) {
                        }
                        [self dismissViewControllerAnimated:YES completion:nil];
                    };
                    [self presentViewController:tweetViewController animated:YES completion:nil];
                }
                else
                    [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Sorry. You are can't send tweets." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            
            break;
        }
        case 3:
        {
            if ([MFMessageComposeViewController canSendText]) {
                MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
                //Composing Body
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
                [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
                NSString *body = [NSString stringWithFormat:@"%@\n\n%@\n\nPosted on: %@", [item newsTitle],[item newsLink],[dateFormatter stringFromDate:[item newsDateTimeLocal]] ];
                controller.body = body;
                controller.recipients = [NSArray arrayWithObjects: nil];
                controller.messageComposeDelegate = self;
                [self presentViewController:controller animated:YES completion:nil];
            }
        }
            
        default:
            break;
    }
    
    if(buttonIndex == 0)
    {    }
    else if(buttonIndex == 1)
    {
        
        
    }
}
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


#pragma MFMessage Composer Delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [super viewWillAppear:animated];
    
    self.navigationItem.title = CurrentTeamHeader;
    
    if(firstLoad)
    {
        firstLoad = NO;
        [self showFullNews:nil];
    }
    [self setupNavigationItems];
}

- (void)setupNavigationItems
{
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"  <  " style:UIBarButtonItemStylePlain target:self action:@selector(didTapBack)],[[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(navBack)],[[UIBarButtonItem alloc] initWithTitle:@"  >  " style:UIBarButtonItemStylePlain target:self action:@selector(didTapNext)]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(shareNewsFB:)];
    
}

#pragma mark - Actions

- (void)didTapBack
{
    if(espnWeb.canGoBack)
        [espnWeb goBack];
}

- (void)didTapNext
{
    if(espnWeb.canGoForward)
        [espnWeb goForward];
}

- (void)swipeDetected:(UISwipeGestureRecognizer*)recognizer
{
    if([recognizer direction] == UISwipeGestureRecognizerDirectionLeft)
    {
        [self loadNext];
        // added by Ying
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setDuration:1.0];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [espnWeb.layer addAnimation:animation forKey:kCATransition];
        //////////////////////////////////////////////////////////////////////
    }
    else
    {
        [self loadPrev];
        // added by Ying
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setDuration:1.0];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [espnWeb.layer addAnimation:animation forKey:kCATransition];
        //////////////////////////////////////////////////////////////////////
    }
}

- (void)loadPrev
{
    if(itemIndex > 0)
    {
        itemIndex--;
        [self showFullNews:nil];
    }
}

- (void)navBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadNext
{
    if(itemIndex < [[[Resources sharedResources] newsList] count]-1)
    {
        itemIndex++;
        [self showFullNews:nil];
    }
}

#pragma mark - View lifecycle

//-(void)dealloc
//{
//    [adview setDelegate:NULL];
//
//    [super dealloc];
//}

- (void)viewDidLoad
{
    /*NewsItem *item = [[[Resources sharedResources] newsList] objectAtIndex:itemIndex];    
    
    //    JHTickerView *titleLbl = [[JHTickerView alloc] initWithFrame:CGRectMake(3, 0, 300, 20)];
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(3, 0, 300, 40)];
    [titleLbl setText:[item newsTitle]];
    [titleLbl setNumberOfLines:2];
    [titleLbl setLineBreakMode:UILineBreakModeWordWrap];
    //    [titleLbl setTickerSpeed:60.0f];
    [titleLbl setBackgroundColor:[UIColor clearColor]];
    [titleLbl setTextAlignment:UITextAlignmentLeft];
    [titleLbl setTextColor:[UIColor colorWithRed:137/256.0 green:13/256.0 blue:44/256.0 alpha:1.0]];
    [titleLbl setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    //    [titleLbl setTickerHFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    //    [titleLbl setTextAlignment:UITextAlignmentLeft];
    //    [titleLbl makeView];
    //    [titleLbl start];
    [mainImageView addSubview:titleLbl];
    titleLbl = nil;
    
    UILabel *statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(3, 40, 300, 20)];
    [statusLbl setText:[NSString stringWithFormat:@"%@ - %@ - %@",[item newsSource],[item newsTime], [item newsDate]]];
    [statusLbl setBackgroundColor:[UIColor clearColor]];
    [statusLbl setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [statusLbl setTextColor:[UIColor colorWithRed:137/256.0 green:13/256.0 blue:44/256.0 alpha:1.0]];
    [statusLbl setTextAlignment:UITextAlignmentLeft];
    [mainImageView addSubview:statusLbl];
    statusLbl = nil;
    
    int heightForDetailView = mainImageView.frame.size.height - 65;
    
    UITextView *detailLbl = [[UITextView alloc] initWithFrame:CGRectMake(-5, 60, 300, heightForDetailView)];
    [detailLbl setText:[item newsDesc]];
    [detailLbl setEditable:NO];
    [detailLbl setScrollEnabled:TRUE];
    [detailLbl setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [detailLbl setBackgroundColor:[UIColor clearColor]];
    [detailLbl setTextColor:[UIColor grayColor]];
    [detailLbl setTextAlignment:UITextAlignmentLeft];
    [mainImageView addSubview:detailLbl];
    detailLbl = nil;*/
    
    
    ////----Facebook----//
    
    //APPID FOR BRAVESBALL:  430923973599855
        
    firstLoad = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.espnWeb = nil;
    [[Resources sharedResources] hideNetworkIndicator];
    [super viewWillDisappear:animated];
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

-(void)showNetworkingIndicator
{
    if(self.networkActivityIndicator == nil)
    {
        self.networkActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(279, 3, 40, 40)];
        
    }
    [self.networkActivityIndicator startAnimating];
    [self.view addSubview:self.networkActivityIndicator];
    
}
-(void)hideNetworkingIndicator
{
    if(self.networkActivityIndicator != nil)
	{
        [self.networkActivityIndicator stopAnimating];
	}
}


@end
