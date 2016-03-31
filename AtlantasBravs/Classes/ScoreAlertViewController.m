//
//  ScoreAlertViewController.m
//  AtlantasBravs
//
//  Created by Sol on 5/26/15.
//
//

#import "ScoreAlertViewController.h"
#import "Resources.h"
#import "TeamItem.h"
#import "ScoreAlertTypeViewController.h"

@interface ScoreAlertViewController ()

@end

@implementation ScoreAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    firstLoading = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"ZTPro Score Alerts";
    if (firstLoading) {
        //[[Resources sharedResources] showNetworkingActivity];
        //[[[Resources sharedResources] getXMLReader] getTeams:^{
            //teamsList = [NSMutableArray arrayWithArray:[[Resources sharedResources] teamList]];
        teamsList = [NSMutableArray arrayWithArray:@[@{@"teamname":@"Arizona Diamondbacks",
                                                       @"shortname":@"Arizona"},
                                                     @{@"teamname":@"Atlanta Braves",
                                                       @"shortname":@"Atlanta"},
                                                     @{@"teamname":@"Baltimore Orioles",
                                                       @"shortname":@"Baltimore"},
                                                     @{@"teamname":@"Boston Red Sox",
                                                       @"shortname":@"Boston"},
                                                     @{@"teamname":@"Chicago White Sox",
                                                       @"shortname":@"Chicago Sox"},
                                                     @{@"teamname":@"Chicago Cubs",
                                                       @"shortname":@"Chicago Cubs"},
                                                     @{@"teamname":@"Cincinnati Reds",
                                                       @"shortname":@"Cincinnati"},
                                                     @{@"teamname":@"Cleveland Indians",
                                                       @"shortname":@"Cleveland"},
                                                     @{@"teamname":@"Colorado Rockies",
                                                       @"shortname":@"Colorado"},
                                                     @{@"teamname":@"Detroit Tigers",
                                                       @"shortname":@"Detroit"},
                                                     @{@"teamname":@"Houston Astros",
                                                       @"shortname":@"Houston"},
                                                     @{@"teamname":@"Kansas City Royals",
                                                       @"shortname":@"Kansas City"},
                                                     @{@"teamname":@"Los Angeles Angels",
                                                       @"shortname":@"LA Angels"},
                                                     @{@"teamname":@"Los Angeles Dodgers",
                                                       @"shortname":@"LA Dodgers"},
                                                     @{@"teamname":@"Miami Marlins",
                                                       @"shortname":@"Miami"},
                                                     @{@"teamname":@"Milwaukee Brewers",
                                                       @"shortname":@"Milwaukee"},
                                                     @{@"teamname":@"Minnesota Twins",
                                                       @"shortname":@"Minnesota"},
                                                     @{@"teamname":@"New York Mets",
                                                       @"shortname":@"NY Mets"},
                                                     @{@"teamname":@"New York Yankees",
                                                       @"shortname":@"NY Yankees"},
                                                     @{@"teamname":@"Oakland Athletics",
                                                       @"shortname":@"Oakland"},
                                                     @{@"teamname":@"Philadelphia Phillies",
                                                       @"shortname":@"Philadelphia"},
                                                     @{@"teamname":@"Pittsburgh Pirates",
                                                       @"shortname":@"Pittsburgh"},
                                                     @{@"teamname":@"San Diego Padres",
                                                       @"shortname":@"San Diego"},
                                                     @{@"teamname":@"San Francisco Giants",
                                                       @"shortname":@"San Francisco"},
                                                     @{@"teamname":@"Seattle Mariners",
                                                       @"shortname":@"Seattle"},
                                                     @{@"teamname":@"St. Louis Cardinals",
                                                       @"shortname":@"St. Louis"},
                                                     @{@"teamname":@"Tampa Bay Rays",
                                                       @"shortname":@"Tampa Bay"},
                                                     @{@"teamname":@"Texas Rangers",
                                                       @"shortname":@"Texas"},
                                                     @{@"teamname":@"Toronto Blue Jays",
                                                       @"shortname":@"Toronto"},
                                                     @{@"teamname":@"Washington Nationals",
                                                       @"shortname":@"Washington"}]];
        //[[Resources sharedResources] hideNetworkIndicator];
            [self.tblTeams reloadData];
            //firstLoading = NO;
        //}];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (teamsList == nil) {
        return 0;
    }
    return teamsList.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (teamsList.count == 0) {
        cell.textLabel.text = @"No teams to display";
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Which team do you want to set up Score Alerts for?";
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.numberOfLines = 2;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else {
            NSDictionary *teamItem = [teamsList objectAtIndex:indexPath.row - 1];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSMutableDictionary *curTeamAlerts = [[NSMutableDictionary alloc] init];
            if ([defaults objectForKey:@"teamAlerts"]) {
                curTeamAlerts = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"teamAlerts"]];
            }
            if ([curTeamAlerts objectForKey:[teamItem objectForKey:@"shortname"]] != nil) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.textLabel.text = [teamItem objectForKey:@"teamname"];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= 0) {
        return;
    }
    ScoreAlertTypeViewController *viewController = [[ScoreAlertTypeViewController alloc] initWithNibName:[Util isIphone5Display] ? @"ScoreAlertTypeViewController-5" : @"ScoreAlertTypeViewController" bundle:nil];
    self.navigationItem.title = @"Back";
    viewController.teamInfo = [teamsList objectAtIndex:indexPath.row - 1];
    [self.navigationController pushViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
