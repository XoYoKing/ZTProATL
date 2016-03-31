//
//  MainNewsList.m
//  AtlantasBravs
//
//  Created by Guest on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainNewsList.h"

#import "Resources.h"

#import "NewsListCell.h"
#import "LiveFeedViewController.h"
#import "NewsDetailScreen.h"
#import "EditNewsSourceViewController.h"    // added by Ying

@implementation MainNewsList

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
/*  // removed by Ying
    [[[UIActionSheet alloc] initWithTitle:@"Please choose an option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:newsType==0?@"General MLB News":@"Team News", @"Refresh Articles", nil] showFromTabBar:self.tabBarController.tabBar];
*/
    // added by Ying
    [[[UIActionSheet alloc] initWithTitle:@"Please choose an option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:newsType==0?@"General MLB News":@"Team News", @"Add/Edit News Sources", nil] showFromTabBar:self.tabBarController.tabBar];
}

-(UIBarButtonItem *)addMenuBtn
{
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 44, 44);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *menuBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    menuBtnView.bounds = CGRectOffset(menuBtnView.bounds, -10, 0);
    [menuBtnView addSubview:menuBtn];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtnView];
    return menuItem;
}

- (void)xmlParsingComplete
{
    [newsTableView setScrollEnabled:YES];
    [newsTableView reloadData];
}

-(void)xmlParsingError:(NSString *)errorMsg
{
    [newsTableView setScrollEnabled:YES];
    [newsTableView reloadData];
}

#pragma uitableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[Resources sharedResources] newsList] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    NewsListCell *cell = (NewsListCell *)[tableView dequeueReusableCellWithIdentifier:@"NewsListCell"];
    @try {
        
        NewsItem *item = [[[Resources sharedResources] newsList] objectAtIndex:indexPath.row];
        
        if (cell == NULL) {
            
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsListCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        [dateFormatter setTimeZone:nil];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"h:mm a"];
        [timeFormatter setTimeZone:nil];
        
        [cell setCellTitle:[item newsTitle]
                    detail:[item newsDesc]
                   andDate:[NSString stringWithFormat:@"%@ - %@ - %@",[item newsSource],[timeFormatter stringFromDate:item.newsDateTimeUTC], [dateFormatter stringFromDate:item.newsDateTimeUTC]]];
    }
    @catch (NSException *exception) {
        NSLog(@"Cell error: %@",exception);
    }
    @finally {
        
    }
    
    return cell;    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:TRUE animated:TRUE];
    
    if(indexPath.row != -1)
    {
        NewsDetailScreen *viewController = [[NewsDetailScreen alloc] initWithNibName:[Util isIphone5Display] ? @"NewsDetailScreen-5" : @"NewsDetailScreen" bundle:nil];
        [viewController setItemIndex:indexPath.row];
        self.navigationItem.title = @"Back";
        [self.navigationController pushViewController:viewController animated:YES];
        NSLog(@"NavigateNewsDetail");
    }
}


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = [NSString stringWithFormat:@"ZTP %@ News", CurrentAppName];
    @try {
        //[adview setHidden:YES];
        
        [newsTableView reloadData];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[Resources sharedResources] hideNetworkIndicator];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [newsTableView setDelegate:self];
    [newsTableView setDataSource:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Scores" style:UIBarButtonItemStylePlain target:self action:@selector(didTapLiveScore:)];
    self.navigationItem.rightBarButtonItem = [self addMenuBtn];//[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(refresh:)];
    
    //Team news
    newsType = 0;
    
    // added by Ying
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [newsTableView addSubview:refreshControl];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    newsTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma UIActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex!=actionSheet.cancelButtonIndex)
    {
        switch (buttonIndex) {
            case 0:
            {
                if(newsType==0)
                {
                    //General MLB
                    newsType = 1;
                    [[Resources sharedResources] RefreshGeneralData:self];
                    [newsTableView setScrollEnabled:NO];
                }
                else
                {
                    //Team News
                    newsType =0;
                    [[Resources sharedResources] RefreshData:self];
                    [newsTableView setScrollEnabled:NO];
                }
                break;
            }
/*  // removed by Ying
            case 1:
            {
                //Refreshing
                if(newsType==0)
                {
                    //General MLB
                    [[Resources sharedResources] RefreshData:self];
                    [newsTableView setScrollEnabled:NO];
                }
                else
                {
                    //Team News
                    [[Resources sharedResources] RefreshGeneralData:self];
                    [newsTableView setScrollEnabled:NO];
                }
                break;
            }
 */
            // added by Ying
            case 1:
            {
                EditNewsSourceViewController *viewController = [[EditNewsSourceViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            default:
                break;
        }
    }
    
}

// added by Ying
- (void)refreshTableView    {
    if(newsType==0)
    {
        //General MLB
        [[Resources sharedResources] RefreshData:self];
        [newsTableView setScrollEnabled:NO];
    }
    else
    {
        //Team News
        [[Resources sharedResources] RefreshGeneralData:self];
        [newsTableView setScrollEnabled:NO];
    }
    
    // End the refreshing
    if (refreshControl) {
        [refreshControl endRefreshing];
    }
}

@end
