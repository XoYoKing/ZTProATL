//
//  ScheduleScreen.m
//  AtlantasBravs
//
//  Created by Guest on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduleScreen.h"
#import "Resources.h"
#import "ScheduleNotifier.h"
#import "LiveFeedViewController.h"
#import "ScheduleListCell.h"
#import "SetAlertsViewController.h"     // added by Ying
#import "DetailAlert.h"
#import "AlertsViewController.h"

#define kNoCellsPlaceholder @"The schedule is not available at this time. Please check back soon.\n\nThanks,\nZT Professionals."

@interface ScheduleScreen()
@end

@implementation ScheduleScreen

@synthesize ListIndx;


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
    [schedTable setScrollEnabled:NO];
    [[Resources sharedResources] RefreshData:self];
}

- (void)xmlParsingComplete
{
    [schedTable setScrollEnabled:YES];
    [self reloadSchedule];
}

-(void)xmlParsingError:(NSString *)errorMsg
{
    [schedTable setScrollEnabled:YES];
    [self reloadSchedule];
}

- (IBAction)alarmSwitched:(id)sender
{
    [[Resources sharedResources] showNetworkingActivity];
    
    //    ScheduleNotifier *schedNotifier = [[Resources sharedResources] getScheduleNotifier];
    //
    //    if(alarmSwitch.on) {
    //        [schedNotifier insertMatchForSchedule:@"-1" teamA:@"" teamB:@"" date:@"" time:@""];
    //
    //        if ([[[Resources sharedResources] matchesList] count] > 0) {
    //            for (int i=0; i<15; i++) {
    //                ScheduleItem *item = [[[Resources sharedResources] matchesList] objectAtIndex:i];
    //
    //                [[[Resources sharedResources] getScheduleNotifier] schedule:[item matchId] teamA:[item teamAshortname] teamB:[item teamBshortname] date:[item matchDate] time:[item matchTime]];
    //            }
    //        }
    //    }
    //    else {
    //        [schedNotifier removeFromSchedule];
    //    }
    
    [NSThread detachNewThreadSelector:@selector(makeSchedule) toTarget:self withObject:nil];
}

// added by Ying
- (IBAction)setAlertsClicked:(id)sender {
    /*UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Please choose an option" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *startTime = [UIAlertAction actionWithTitle:@"When Game Starts" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[Resources sharedResources] showNetworkingActivity];
        [NSThread detachNewThreadSelector:@selector(makeAlertSchedule:) toTarget:self withObject:@"start"];
    }];
    
    UIAlertAction *secondTime = [UIAlertAction actionWithTitle:@"15 mins Before Game Starts" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[Resources sharedResources] showNetworkingActivity];
        [NSThread detachNewThreadSelector:@selector(makeAlertSchedule:) toTarget:self withObject:@"fifteen"];
    }];
    
    UIAlertAction *customTime = [UIAlertAction actionWithTitle:@"Set Custom Time" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        SetAlertsViewController *viewController = [[SetAlertsViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
    UIAlertAction *noAlerts = [UIAlertAction actionWithTitle:@"No Alerts" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[Resources sharedResources] showNetworkingActivity];
        [NSThread detachNewThreadSelector:@selector(makeAlertSchedule:) toTarget:self withObject:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [sheet addAction:startTime];
    [sheet addAction:secondTime];
    [sheet addAction:customTime];
    [sheet addAction:noAlerts];
    [sheet addAction:cancel];
    
    [self presentViewController:sheet animated:YES completion:nil];*/
    /*AlertsViewController *viewController = [[AlertsViewController alloc] initWithNibName:[Util isIphone5Display] ? @"AlertsViewController-5" : @"AlertsViewController" bundle:nil];
    self.navigationItem.title = @"Back";
    [self.navigationController pushViewController:viewController animated:YES];*/
}

- (void)makeAlertSchedule:(NSString *)indexString   {
    @autoreleasepool {
        ScheduleNotifier *schedNotifier = [[Resources sharedResources] getScheduleNotifier];
        
        if ([indexString isEqualToString:@"start"]) {
            [schedNotifier insertMatchForSchedule:@"-1" teamA:@"" teamB:@"" datetime:nil];
            
            if ([[[Resources sharedResources] matchesList] count] > 0) {
                for (int i=0; i < 15 && i < [[[Resources sharedResources] matchesList] count] ; i++) {
                    ScheduleItem *item = [[[Resources sharedResources] matchesList] objectAtIndex:i];
                    if (item.status == 1) {
                        continue;
                    }
                    
                    if(![[[Resources sharedResources] getScheduleNotifier] getIsMatchScheduled:item.matchId])
                    {
                        [[[Resources sharedResources] getScheduleNotifier] schedule:[item matchId] teamA:[item teamAshortname] teamB:[item teamBshortname] datetime:[item matchDateTimeLocal]];
                        item.alarm = YES;
                    }
                }
            }
        }
        else if ([indexString isEqualToString:@"fifteen"])    {
            [schedNotifier insertMatchForSchedule:@"-1" teamA:@"" teamB:@"" datetime:nil];
            
            if ([[[Resources sharedResources] matchesList] count] > 0) {
                for (int i=0; i < 15 && i < [[[Resources sharedResources] matchesList] count] ; i++) {
                    ScheduleItem *item = [[[Resources sharedResources] matchesList] objectAtIndex:i];
                    if (item.status == 1) {
                        continue;
                    }
                    
                    NSDate *alertTime = [item.matchDateTimeLocal dateByAddingTimeInterval:-60 * 15];
                    
                    if(![[[Resources sharedResources] getScheduleNotifier] getIsAlertScheduled:item.matchId dateTime:alertTime])
                    {
                        [[[Resources sharedResources] getScheduleNotifier] scheduleAlert:[item matchId] teamA:[item teamAshortname] teamB:[item teamBshortname] dateTime:alertTime matchTime:item.matchDateTimeLocal];
                        item.alarm = YES;
                    }
                }
            }
        }
        else    {
            [schedNotifier removeFromSchedule];
        }
        
        [self performSelectorOnMainThread:@selector(scheduleDone:) withObject:[NSNumber numberWithInt:1] waitUntilDone:NO];
    }
}
//////////////////////////////////////////

- (void)makeSchedule
{
    @autoreleasepool {
        ScheduleNotifier *schedNotifier = [[Resources sharedResources] getScheduleNotifier];
        
        if(alarmSwitch.on) {
            [schedNotifier insertMatchForSchedule:@"-1" teamA:@"" teamB:@"" datetime:nil];
            
            if ([[[Resources sharedResources] matchesList] count] > 0) {
                for (int i=0; i < 15 && i < [[[Resources sharedResources] matchesList] count] ; i++) {
                    ScheduleItem *item = [[[Resources sharedResources] matchesList] objectAtIndex:i];
                    
                    if(![[[Resources sharedResources] getScheduleNotifier] getIsMatchScheduled:item.matchId])
                    {
                        
                        [[[Resources sharedResources] getScheduleNotifier] schedule:[item matchId] teamA:[item teamAshortname] teamB:[item teamBshortname] datetime:[item matchDateTimeLocal]];
                        item.alarm = YES;
                    }
                }
            }
        }
        else {
            [schedNotifier removeFromSchedule];
            //[schedTable reloadData];
        }
        
        
        [self performSelectorOnMainThread:@selector(scheduleDone:) withObject:[NSNumber numberWithInt:1] waitUntilDone:NO];
    }
}

- (void)scheduleDone:(NSNumber*)a {
    [self reloadSchedule];
    if ([a intValue] == 1) {
        [self performSelector:@selector(scheduleDone:) withObject:nil afterDelay:1.0];
    }
    else {
        [[Resources sharedResources] hideNetworkIndicator];
    }
}

- (void)scheduleLocalNotify:(id)sender;
{
    UIButton *btn = (UIButton *)sender;
    
    NSInteger tagger = btn.tag;
    
    ListIndx = tagger;
    
    ScheduleItem *item = [[[Resources sharedResources] matchesList] objectAtIndex:ListIndx];
    
    BOOL alreadyScheduled = [[[Resources sharedResources] getScheduleNotifier] schedule:[item matchId] teamA:[item teamAshortname] teamB:[item teamBshortname] datetime:item.matchDateTimeLocal];
    
    if(alreadyScheduled)
    {
    }
    [[Resources sharedResources] getMatchesList];
    [self reloadSchedule];
}

-(void)reloadSchedule
{
    prevMatches = [[NSMutableArray alloc] init];
    curMatches = [[NSMutableArray alloc] init];
    for (int i = 0; i < [[Resources sharedResources] matchesList].count; i++) {
        ScheduleItem *item = (ScheduleItem *)[[[Resources sharedResources] matchesList] objectAtIndex:i];
        if (item.status == 1) {
            [prevMatches addObject:item];
        }else {
            [curMatches addObject:item];
        }
    }
    [schedTable reloadData];
    if (prevMatches.count > 0 && curMatches.count > 0) {
        [schedTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma uitableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (prevMatches.count == 0 || curMatches.count == 0) {
        return 1;
    }
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(prevMatches.count == 0 && curMatches == 0) {
        return nil;
    }
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    viewHeader.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithRed:240 / 255.0f green:240 / 255.0f blue:240 / 255.0f alpha:1.0f];
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, viewHeader.frame.size.width - 10, viewHeader.frame.size.height)];
    if (section == 0) {
        if (prevMatches.count == 0) {
            lblHeader.text = @"Upcoming Games";
        }else {
            lblHeader.text = @"Previous Games";
        }
    }else if (section == 1) {
        lblHeader.text = @"Upcoming Games";
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(prevMatches.count == 0 && curMatches == 0) {
        return 0.01f;
    }
    return 30.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (curMatches.count == 0 && prevMatches == 0) {
        return 1;
    }
    if (section == 0) {
        if (prevMatches.count == 0) {
            return curMatches.count;
        }else {
            return prevMatches.count;
        }
    }else {
        return curMatches.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (curMatches.count == 0 && prevMatches.count == 0) {
        return 161.0f;
    }
    return 60.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EmptyScheduleListCell"];
    
    if(curMatches.count == 0 && prevMatches.count == 0)
    {
        [emptyCell.textLabel setNumberOfLines:0];
        [emptyCell.textLabel setText:kNoCellsPlaceholder];
        return emptyCell;
    }
    ScheduleItem *item;
    if (indexPath.section == 0) {
        if (prevMatches.count == 0) {
            item = [curMatches objectAtIndex:indexPath.row];
        }else {
            item = [prevMatches objectAtIndex:indexPath.row];
        }
    }else {
        item = [curMatches objectAtIndex:indexPath.row];
    }
    NSString *cellIdentifier = @"ScheduleListCell";
    ScheduleListCell *cell = (ScheduleListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        if (item.status == 0) {
            cell = [topLevelObjects objectAtIndex:0];
        }else {
            cell = [topLevelObjects objectAtIndex:1];
        }
        
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MM/dd/yyyy EEEE"];     // removed by Ying
    [dateFormatter setTimeZone:nil];
//    [[cell dateLabel] setText:[dateFormatter stringFromDate:item.matchDateTimeUTC]];      // removed by Ying
    /* added by Ying */
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *todayString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *tomorrowString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24]];
    NSString *dateString = [dateFormatter stringFromDate:item.matchDateTimeLocal];
    
    if ([dateString isEqualToString:todayString]) {
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        [[cell dateLabel] setText:[NSString stringWithFormat:@"%@ Today", [dateFormatter stringFromDate:item.matchDateTimeLocal]]];
    }
    else if ([dateString isEqualToString:tomorrowString])  {
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        [[cell dateLabel] setText:[NSString stringWithFormat:@"%@ Tomorrow", [dateFormatter stringFromDate:item.matchDateTimeLocal]]];
    }
    else    {
        [dateFormatter setDateFormat:@"MM/dd/yyyy EEE."];
        [[cell dateLabel] setText:[dateFormatter stringFromDate:item.matchDateTimeLocal]];
    }
    ///////////////////
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h:mm a"];
    [timeFormatter setTimeZone:nil];
    [[cell timeLabel] setText:[timeFormatter stringFromDate:item.matchDateTimeLocal]];
    
    if (item.status == 0) {
        [[cell team1Label] setText:item.teamAshortname];
        [[cell team2Label] setText:item.teamBshortname];
    }else {
        [[cell team1Label] setText:[NSString stringWithFormat:@"%@ - %d",item.teamAshortname,item.score1]];
        [[cell team2Label] setText:[NSString stringWithFormat:@"%@ - %d",item.teamBshortname,item.score2]];
    }
    /*if (item.localTV != nil && ![item.localTV isEqualToString:@""]) {
        [cell.localTVLabel setText:[NSString stringWithFormat:@"Local TV : %@", item.localTV]];
    }else {
        cell.localTVLabel.text = @"";
    }
    
    if (item.localRadio != nil && ![item.localRadio isEqualToString:@""]) {
        [cell.localRadioLabel setText:[NSString stringWithFormat:@"Local Radio : %@", item.localRadio]];
    }else {
        cell.localRadioLabel.text = @"";
    }
    
    if (item.probableStarters != nil && ![item.probableStarters isEqualToString:@""]) {
        [cell.probableStartersLabel setText:[item.probableStarters stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
    }else {
        cell.probableStartersLabel.text = @"";
    }*/
    
    cell.lblTVRadio.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTVRadio:)];
    [tap setCancelsTouchesInView:YES];
    [cell addGestureRecognizer:tap];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)showTVRadio:(UITapGestureRecognizer *)gesture
{
    UIView *sender = gesture.view;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:schedTable];
    NSIndexPath *selectedIndex = [schedTable indexPathForRowAtPoint:buttonPosition];
    if (selectedIndex.section == 0) {
        return;
    }
    ScheduleItem *item;
    if (prevMatches.count == 0 || curMatches.count == 0) {
        if (prevMatches.count == 0) {
            item = [curMatches objectAtIndex:selectedIndex.row];
        }else {
            item = [prevMatches objectAtIndex:selectedIndex.row];
        }
    }else {
        item = [curMatches objectAtIndex:selectedIndex.row];
    }
    UILabel *lblStarters = (UILabel *)[detailAlert viewWithTag:10];
    lblStarters.text = [item.probableStarters stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    if ([lblStarters.text isEqualToString:@""]) {
        lblStarters.text = @"Unknown";
    }
    UILabel *lblLocalTV = (UILabel *)[detailAlert viewWithTag:11];
    lblLocalTV.text = [item.localTV stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    if ([lblLocalTV.text isEqualToString:@""]) {
        lblLocalTV.text = @"Unknown";
    }
    UILabel *lblLocalRadio = (UILabel *)[detailAlert viewWithTag:12];
    lblLocalRadio.text = [item.localRadio stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    if ([lblLocalRadio.text isEqualToString:@""]) {
        lblLocalRadio.text = @"Unknown";
    }
    
    /*NSString *msg = [NSString stringWithFormat:@"Probable Starters\n%@\n\nLocal TV\n%@\n\nLocal Radio\n%@",[item.probableStarters stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"], item.localTV,[item.localRadio stringByReplacingOccurrencesOfString:@"," withString:@"\n"]];
    [[Resources sharedResources] showAlertWithTitle:@"" withBody:msg];*/
    [self.view bringSubviewToFront:shadowView];
    [self.view bringSubviewToFront:detailAlert];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*ScheduleItem *item = [[[Resources sharedResources] getMatchesList] objectAtIndex:indexPath.row];
    
    NSString *msg = [NSString stringWithFormat:@"%@\n%@\n\n%@\n%@",item.teamAshortname,item.teamAname, item.teamBshortname, item.teamBname];
    if (item.score1 > 0 || item.score2 > 0) {
        msg = [NSString stringWithFormat:@"%@\n\nPrevous Score\n%d:%d",msg,item.score1,item.score2];
    }
    [[Resources sharedResources] showAlertWithTitle:@"Info" withBody:msg];*/
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Scores" style:UIBarButtonItemStylePlain target:self action:@selector(didTapLiveScore:)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = [self addMoreBtn];
    
    [[Resources sharedResources] getMatchesList];
    [super viewDidLoad];
    
    [self.btnSet setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btnSet.layer.cornerRadius = 5.0f;
    self.btnSet.layer.borderColor = [UIColor blackColor].CGColor;
    self.btnSet.layer.borderWidth = 1.0f;
    
    alarmSwitch.transform = CGAffineTransformMakeScale(1.1, 1.1);
    
    detailAlert = (DetailAlert *)[[[NSBundle mainBundle] loadNibNamed:@"DetailAlertView" owner:nil options:nil] objectAtIndex:0];
    detailAlert.clipsToBounds = YES;
    detailAlert.layer.cornerRadius = 5.0f;
    [self.view addSubview:detailAlert];
    shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
    shadowView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopup)];
    [tap setCancelsTouchesInView:YES];
    [shadowView addGestureRecognizer:tap];
    [self.view addSubview:shadowView];
    
    //NSLog(@"Curent datetime: %@",[NSDate date]);
    [self reloadSchedule];
}

-(IBAction)doAction:(id)sender   {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Please choose an option" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *simple = [UIAlertAction actionWithTitle:@"Refresh Schedule" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self refresh:nil];
    }];
    
    UIAlertAction *detail = [UIAlertAction actionWithTitle:@"ZTPro Schedule Alerts" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        /*if (self.tabBarController.selectedIndex == 4) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self.tabBarController setSelectedIndex:4];
        }*/
        AlertsViewController *viewController = [[AlertsViewController alloc] initWithNibName:[Util isIphone5Display] ? @"AlertsViewController-5" : @"AlertsViewController" bundle:nil];
        self.navigationItem.title = @"Back";
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [sheet addAction:simple];
    [sheet addAction:detail];
    [sheet addAction:cancel];
    
    [self presentViewController:sheet animated:YES completion:nil];
}


-(UIBarButtonItem *)addMoreBtn
{
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 44, 44);
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *moreBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    moreBtnView.bounds = CGRectOffset(moreBtnView.bounds, -10, 0);
    [moreBtnView addSubview:moreBtn];
    
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtnView];
    return moreItem;
}

-(void)hidePopup
{
    [self.view sendSubviewToBack:detailAlert];
    [self.view sendSubviewToBack:shadowView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.view sendSubviewToBack:detailAlert];
    [self.view sendSubviewToBack:shadowView];
    detailAlert.frame = CGRectMake(self.view.frame.size.width / 2 - 150, 20, 300, 286);
    self.navigationItem.title = [NSString stringWithFormat:@"ZTP %@ Schedule", CurrentAppName];
    
    // Do any additional setup after loading the view from its nib.
    //ScheduleNotifier *schedNotifier = [[Resources sharedResources] getScheduleNotifier];
    
    /*if ([schedNotifier getIsMatchScheduled:@"-1"]) {
        alarmSwitch.on = TRUE;
        
        if ([[[Resources sharedResources] matchesList] count] > 0) {
            for (int i=0; i < 15 && i < [[[Resources sharedResources] matchesList] count]; i++) {
                ScheduleItem *item = [[[Resources sharedResources] matchesList] objectAtIndex:i];
                
                [[[Resources sharedResources] getScheduleNotifier] schedule:[item matchId] teamA:[item teamAshortname] teamB:[item teamBshortname] datetime:item.matchDateTimeLocal];
            }
        }
    }
    else {
        alarmSwitch.on = FALSE;
        
        [[[Resources sharedResources] getScheduleNotifier] removeFromSchedule];
        
    }*/
    
    [super viewWillAppear:animated];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
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

@end
