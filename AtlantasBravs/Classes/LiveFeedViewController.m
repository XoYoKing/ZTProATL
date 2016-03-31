//
//  LiveFeedViewController.m
//  AtlantasBravs
//
//  Created by Anton Gubarenko on 26.04.13.
//
//



#import "LiveFeedViewController.h"
#import "Resources.h"
#import "LiveItemCell.h"

#define kNoCellsPlaceholder @"There are no scores available at this time. Please check back soon.\n\nThanks,\nZT Professionals."

@interface LiveFeedViewController()
@property (nonatomic) BOOL isFeedReady;
@end

@implementation LiveFeedViewController

bool firstLoad;

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
    //updateTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(updateFeed) userInfo:nil repeats:YES];
/*  // removed by Ying
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateFeed)];
*/
    firstLoad = YES;
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Manage Alerts" style:UIBarButtonItemStylePlain target:self action:@selector(manAlerts)];
    // added by Ying
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateFeed) forControlEvents:UIControlEventValueChanged];
    [liveFeedTable addSubview:refreshControl];
}

-(void)manAlerts
{
    if (self.tabBarController.selectedIndex == 4) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.tabBarController setSelectedIndex:4];
    }
}

- (void)dealloc
{
    [adview setDelegate:NULL];
    [updateTimer invalidate],updateTimer = nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(firstLoad)
    {
        firstLoad = NO;
        //Loading Live Feed
        [self updateFeed];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[Resources sharedResources] hideNetworkIndicator];
    [super viewWillDisappear:animated];
}

-(void)updateFeed
{
    NSLog(@"Updating in progress");
    self.isFeedReady = NO;
    [[[Resources sharedResources] getXMLReader] parseXMLForLiveFeed:self];
    
    // added by Ying
    if (refreshControl) {
        [refreshControl endRefreshing];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*LiveItem *item = [[[Resources sharedResources] liveList] objectAtIndex:indexPath.row];
     if(item.isMultiLine)
     return 100.0;*/
    if([[[Resources sharedResources] liveList] count])
    {
        return 61.0;
    }
    else
        return 161.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isFeedReady ? MAX([[[Resources sharedResources] liveList] count], 1) : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReusableCell"];
    if(cell != nil) {
        cell = nil;
    }
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ReusableCell"];
    if([[[Resources sharedResources] liveList] count]==0)
    {
        [cell.textLabel setNumberOfLines:0];
        [cell.textLabel setText:kNoCellsPlaceholder];
        return cell;
    }
    
    LiveItem *item = [[[Resources sharedResources] liveList] objectAtIndex:indexPath.row];
    bool localTeam = [[item.liveTitle lowercaseString] rangeOfString:[CurrentTeamName lowercaseString]].location==NSNotFound?NO:YES;
    
    if(localTeam)
    {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    }
    else
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.textColor = [UIColor grayColor];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"h:mm a"];
    
    
    NSString *simpleTableIdentifier =  localTeam ? @"LiveItemCell-Local" : @"LiveItemCell";
    
    LiveItemCell *cellLive = (LiveItemCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cellLive == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:simpleTableIdentifier owner:self options:nil];
        cellLive = [nib objectAtIndex:0];
    }
    
    NSRange range = [item.liveTitle rangeOfString:@"  "];
    /* added by Ying */
    NSString *team2;
    if (range.length == 0) {
        range = [item.liveTitle rangeOfString:@" at "];
        team2 = [item.liveTitle substringFromIndex:range.location+4];
    }else {
        team2 = [item.liveTitle substringFromIndex:range.location+3];
    }
    ///////////////////////////////////////////////////////
    NSString *team1 = [item.liveTitle substringToIndex:range.location];
    
    NSRange rangeIn = [team2 rangeOfString:@"("];
    NSString *inning = [team2 substringFromIndex:rangeIn.location+1];
    inning = [inning substringToIndex:inning.length-1];
    team2 = [team2 substringToIndex:rangeIn.location-1];
    
    
    NSRange range1 = [team1 rangeOfString:@" " options:NSBackwardsSearch];
    NSRange range2 = [team2 rangeOfString:@" " options:NSBackwardsSearch];
    if(range1.location != NSNotFound)
    {
        /*team1 = [NSString stringWithFormat:@"%@%@",[[team1 substringToIndex:range1.location] stringByPaddingToLength:16 withString:@" " startingAtIndex:0],[team1 substringFromIndex:range1.location+1]];*/
        if ([[NSString stringWithFormat:@"%d",[[team1 substringFromIndex:range1.location + 1] intValue]] isEqualToString:[team1 substringFromIndex:range1.location + 1]]) {
            cellLive.team1.text = [team1 substringToIndex:range1.location];
            cellLive.score1.text = [team1 substringFromIndex:range1.location+1];
        }else {
            cellLive.team1.text = team1;
            cellLive.score1.text = @"";
        }
        
    }else {
        cellLive.team1.text = team1;
        cellLive.score1.text = @"";
    }
    if(range2.location != NSNotFound)
    {
        /*team2 = [NSString stringWithFormat:@"%@%@",[[team2 substringToIndex:range2.location] stringByPaddingToLength:20 withString:@" " startingAtIndex:0],[team2 substringFromIndex:range2.location+1]];*/
        
        if ([[NSString stringWithFormat:@"%d",[[team2 substringFromIndex:range2.location + 1] intValue]] isEqualToString:[team2 substringFromIndex:range2.location + 1]]) {
            cellLive.team2.text = [team2 substringToIndex:range2.location];
            cellLive.score2.text = [team2 substringFromIndex:range2.location+1];
        }else {
            cellLive.team2.text = team2;
            cellLive.score2.text = @"";
        }
    }else {
        cellLive.team2.text = team2;
        cellLive.score2.text = @"";
    }
    
    cellLive.time.text = [[inning stringByReplacingOccurrencesOfString:@"BOT" withString:@"Bottom"] stringByReplacingOccurrencesOfString:@"TOP" withString:@"Top"];
    
    return cellLive;
}

#pragma XML Delegate

- (void)xmlParsingComplete
{
    self.isFeedReady = YES;
    [liveFeedTable reloadData];
    for (LiveItem *item in [Resources sharedResources].liveList) {
        bool localTeam = [[item.liveTitle lowercaseString] rangeOfString:[CurrentTeamName lowercaseString]].location==NSNotFound?NO:YES;
        if(localTeam)
        {
            [liveFeedTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[[Resources sharedResources].liveList indexOfObject:item] inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            break;
        }
    }
}


#pragma AdBannerView Delegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    
    @try {
        [adview setHidden:NO];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
    @try {
        [adview setHidden:YES];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    @try {
        [adview setHidden:YES];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
@end
