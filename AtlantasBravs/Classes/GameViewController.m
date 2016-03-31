//
//  GameViewController.m
//  AtlantasBravs
//
//  Created by MacBook on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"

#import "Resources.h"
#import "LiveFeedViewController.h"
#import "AboutViewController.h"
#import "LocalWebViewController.h"
#import "PlayerStatsViewController.h"   // added by Ying
#import "RadioViewController.h"
#import "AppDelegate.h"
#import "AlertsViewController.h"
#import "ScoreAlertViewController.h"
#import "HttpWorker.h"

@implementation GameViewController



-(void)didTapLiveScore:(id)sender
{
    //Go To Live Feed
    [[Resources sharedResources] NavigateLiveFeed];
    LiveFeedViewController *viewController = [[LiveFeedViewController alloc] initWithNibName:@"LiveFeedViewController" bundle:nil];
    self.navigationItem.title = @"Back";
    [self.navigationController pushViewController:viewController animated:YES];
    NSLog(@"LiveFeedView");
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Scores" style:UIBarButtonItemStylePlain target:self action:@selector(didTapLiveScore:)];
    
    [_mainScroll setContentSize:CGSizeMake(300, 300)];
}

- (void)viewDidUnload
{
    [self setMainScroll:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = [NSString stringWithFormat:@"ZTPro More"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[Resources sharedResources] hideNetworkIndicator];
    [super viewWillDisappear:animated];
}

- (IBAction)diaTapRate:(id)sender
{   
    /*LocalWebViewController *viewController = [[LocalWebViewController alloc] initWithNibName:@"LocalWebViewController" bundle:nil];
    self.navigationItem.title = @"Back";
    viewController.urlToLoad = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=506294257"];
    viewController.linkType = 0;*/
    //itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=506294257&onlyLatestVersion=true&pageNumber=0&sortOrdering=1
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/atlball/id506294257?mt=8"]];
    NSLog(@"RateView");
}

- (IBAction)didTapAbout:(id)sender
{    
    AboutViewController *viewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    self.navigationItem.title = @"Back";
    [self.navigationController pushViewController:viewController animated:YES];
    NSLog(@"AboutView");
}

- (IBAction)didTapFacebook:(id)sender {    
    LocalWebViewController *viewController = [[LocalWebViewController alloc] initWithNibName:@"LocalWebViewController" bundle:nil];
    self.navigationItem.title = @"Back";
    viewController.urlToLoad = [NSURL URLWithString:@"https://www.facebook.com/ZTProfessionals"];
    viewController.linkType = 1;
    [self.navigationController pushViewController:viewController animated:YES];
    NSLog(@"FacebookView");
}

- (IBAction)didTapTwitter:(id)sender {    
    LocalWebViewController *viewController = [[LocalWebViewController alloc] initWithNibName:@"LocalWebViewController" bundle:nil];
    self.navigationItem.title = @"Back";
    viewController.urlToLoad = [NSURL URLWithString:@"http://www.twitter.com/ZTProf"];
    viewController.linkType = 2;
    [self.navigationController pushViewController:viewController animated:YES];
    NSLog(@"TwitterView");
}

// added by Ying
- (IBAction)didTapStats:(id)sender {
    PlayerStatsViewController *viewController = [[PlayerStatsViewController alloc] init];
    self.navigationItem.title = @"Back";
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)didTapRadio:(NSString *)radioName {
    RadioViewController *viewController = [[RadioViewController alloc] initWithNibName:@"RadioViewController" bundle:nil];
    self.navigationItem.title = @"Back";
    viewController.radioName = radioName;
    if ([radioName isEqualToString:@"WCNN 680"]) {
        viewController.urlString = @"http://www.680thefan.com/index.php";
    }else if ([radioName isEqualToString:@"WYAY 106.7"]) {
        viewController.urlString = @"http://www.newsradio1067.com/";
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else if (section == 2) {
        return 3;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    viewHeader.backgroundColor = [UIColor whiteColor]; 
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, viewHeader.frame.size.width - 10, viewHeader.frame.size.height)];
    if (section == 0) {
        lblHeader.text = @"General";
    }else if (section == 2) {
        lblHeader.text = @"Team Radio Stations*";
    }else {
        lblHeader.text = @"ZTPro Alerts";
    }
    lblHeader.textColor = [UIColor blackColor];//[UIColor grayColor];
    lblHeader.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f];
    /*CALayer *headerBorder = [[CALayer alloc] init];
     headerBorder.frame = CGRectMake(0, viewHeader.frame.size.height - 1.0f, viewHeader.frame.size.width, 1.0f);
     headerBorder.backgroundColor = [UIColor colorWithRed:66 / 255.0f green:153 / 255.0f blue:220 / 255.0f alpha:1.0f].CGColor;
     [viewHeader.layer addSublayer:headerBorder];*/
    [viewHeader addSubview:lblHeader];
    CALayer *bottomBorder = [[CALayer alloc] init];
    bottomBorder.frame = CGRectMake(0, 29, viewHeader.frame.size.width, 1);
    bottomBorder.backgroundColor = [UIColor colorWithRed:51 / 255.0f green:102 / 255.0f blue:1.0f alpha:0.5f].CGColor;
    [viewHeader.layer addSublayer:bottomBorder];
    if (section > 0) {
        CALayer *topBorder = [[CALayer alloc] init];
        topBorder.frame = CGRectMake(0, 0, viewHeader.frame.size.width, 1);
        topBorder.backgroundColor = [UIColor colorWithRed:51 / 255.0f green:102 / 255.0f blue:1.0f alpha:0.5f].CGColor;
        [viewHeader.layer addSublayer:topBorder];
    }
    return viewHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 &&indexPath.row == 0) {
        return 130.0f;
    }
    return 44.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Player Stats";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"About us";
        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"Like us on Facebook";
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            cell.textLabel.text = @"WCNN 680";
        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"WYAY 106.7";
        }else{
            cell.textLabel.text = @"*Due to MLB regulations, radio stations are not permitted to stream live games via their website, only over the air on the am/fm radio.  As of now, Apple does not include an am/fm radio in their devices. When an option is available to stream live games, we will include it in this app. If there are any suggestions regarding this, feel free to contact ZT Professionals at Nathan.Leone@theprofessionalssports.com.";
            cell.textLabel.frame = CGRectMake(0, 0, 200, 130);
            cell.textLabel.numberOfLines = 8;
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"ZTPro Schedule Alerts";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"ZTPro Score Alerts";
        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"ZTPro Motivation";
            UISwitch *swAlert = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 54, 6 , 49, 31)];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"motivation"] != nil && [[[NSUserDefaults standardUserDefaults] objectForKey:@"motivation"] boolValue]) {
                [swAlert setOn:YES];
            }else {
                [swAlert setOn:NO];
            }
            [swAlert addTarget:self action:@selector(onAlertSetting:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:swAlert];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    return cell;
}

-(void)onAlertSetting:(UISwitch *)swAlert
{
    UITableViewCell *cell = (UITableViewCell *)swAlert.superview.superview;
    if ([[[UIDevice currentDevice] systemVersion] intValue] == 7) {
        cell = (UITableViewCell *)swAlert.superview.superview.superview;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (swAlert.isOn) {
        [defaults setObject:@YES forKey:@"motivation"];
        [delegate scheduleScoreAlert];
    }else {
        [defaults removeObjectForKey:@"motivation"];
        if ([defaults objectForKey:@"teamAlerts"] == nil) {
            [delegate unscheduleScoreAlert];
        }
    }
    [defaults synchronize];
    [HttpWorker setMotivation:swAlert.isOn];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self didTapStats:nil];
        }else if (indexPath.row == 1) {
            [self didTapAbout:nil];
        }else if (indexPath.row == 2) {
            [self didTapFacebook:nil];
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            [self didTapRadio:@"WCNN 680"];
        }else if (indexPath.row == 2) {
            [self didTapRadio:@"WYAY 106.7"];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            AlertsViewController *viewController = [[AlertsViewController alloc] initWithNibName:[Util isIphone5Display] ? @"AlertsViewController-5" : @"AlertsViewController" bundle:nil];
            self.navigationItem.title = @"Back";
            [self.navigationController pushViewController:viewController animated:YES];
        }else if (indexPath.row == 1) {
            ScoreAlertViewController *viewController = [[ScoreAlertViewController alloc] initWithNibName:[Util isIphone5Display] ? @"ScoreAlertViewController-5" : @"ScoreAlertViewController" bundle:nil];
            self.navigationItem.title = @"Back";
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
