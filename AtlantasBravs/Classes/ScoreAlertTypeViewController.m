//
//  ScoreAlertTypeViewController.m
//  AtlantasBravs
//
//  Created by Sol on 5/26/15.
//
//

#import "ScoreAlertTypeViewController.h"
#import "AppDelegate.h"
#import "HttpWorker.h"

@interface ScoreAlertTypeViewController ()

@end

@implementation ScoreAlertTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    teamAlerts = [NSMutableArray array];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"teamAlerts"] && [[defaults objectForKey:@"teamAlerts"] objectForKey:[self.teamInfo objectForKey:@"shortname"]]) {
        teamAlerts = [NSMutableArray arrayWithArray:(NSArray *)[[defaults objectForKey:@"teamAlerts"] objectForKey:[self.teamInfo objectForKey:@"shortname"]]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"ZTPro Score Alerts";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Alert when lead changes";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"Alert when tie game";
    }else if (indexPath.row == 2) {
        cell.textLabel.text = @"Alert when team wins/loses";
    }
    UISwitch *swAlert = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 54, 6 , 49, 31)];
    if ([teamAlerts containsObject:@(indexPath.row)]) {
        [swAlert setOn:YES];
    }else {
        [swAlert setOn:NO];
    }
    [swAlert addTarget:self action:@selector(onAlertSetting:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview:swAlert];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)onAlertSetting:(UISwitch *)swAlert
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITableViewCell *cell = (UITableViewCell *)swAlert.superview.superview;
    if ([[[UIDevice currentDevice] systemVersion] intValue] == 7) {
        cell = (UITableViewCell *)swAlert.superview.superview.superview;
    }
    NSIndexPath *indexPath = [self.tblType indexPathForCell:cell];
    if (swAlert.isOn) {
        [teamAlerts addObject:@(indexPath.row)];
    }else {
        [teamAlerts removeObject:@(indexPath.row)];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *curTeamAlerts = [[NSMutableDictionary alloc] init];
    if ([defaults objectForKey:@"teamAlerts"]) {
        curTeamAlerts = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"teamAlerts"]];
    }
    if (teamAlerts.count == 0) {
        [curTeamAlerts removeObjectForKey:[self.teamInfo objectForKey:@"shortname"]];
    }else {
        [curTeamAlerts setObject:teamAlerts forKey:[self.teamInfo objectForKey:@"shortname"]];
    }
    if (curTeamAlerts.allKeys.count == 0) {
        [defaults removeObjectForKey:@"teamAlerts"];
        if ([defaults objectForKey:@"motivation"] == nil) {
            [delegate unscheduleScoreAlert];
        }
    }else {
        [defaults setObject:curTeamAlerts forKey:@"teamAlerts"];
        [delegate scheduleScoreAlert];
    }
    [defaults synchronize];
    NSString *score = @"";
    if (curTeamAlerts.allKeys.count > 0) {
        NSData *scoreData = [NSJSONSerialization dataWithJSONObject:curTeamAlerts options:NSJSONReadingAllowFragments error:nil];
        score = [[NSString alloc] initWithData:scoreData encoding:NSUTF8StringEncoding];
    }
    [HttpWorker setScoreAlerts:score];
}

@end
