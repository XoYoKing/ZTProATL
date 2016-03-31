//
//  AlertsViewController.m
//  AtlantasBravs
//
//  Created by Sol on 5/20/15.
//
//

#import "AlertsViewController.h"
#import "SetAlertsViewController.h"
#import "Resources.h"
#import "ScheduleItem.h"

@interface AlertsViewController () <SetAlertsViewControllerDelegate>

@end

@implementation AlertsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Alerts";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    customAlerts = [[NSMutableArray alloc] init];
    selAlerts = [[NSMutableArray alloc] init];
    if ([defaults objectForKey:@"customAlerts"] != nil) {
        customAlerts = [NSMutableArray arrayWithArray:(NSArray *)[defaults objectForKey:@"customAlerts"]];
    }
    if ([defaults objectForKey:@"selAlerts"] != nil) {
        selAlerts = [NSMutableArray arrayWithArray:(NSArray *)[defaults objectForKey:@"selAlerts"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = NO;
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
    return 3 + customAlerts.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAdd.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, 10, 200, 34);
        [btnAdd setTitle:@"Add Custom Alert" forState:UIControlStateNormal];
        [btnAdd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnAdd.layer.cornerRadius = 5.0f;
        btnAdd.layer.borderColor = [UIColor blackColor].CGColor;
        btnAdd.layer.borderWidth = 1.0f;
        [cell.contentView addSubview:btnAdd];
        [btnAdd addTarget:self action:@selector(onCustomAlert) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AlertCell" owner:nil options:nil] objectAtIndex:0];
    NSString *alertMsg = @"";
    int alertType = 0;
    int alertMin = 0;
    if (indexPath.row == 1) {
        alertMsg = @"Alert when game starts";
        alertType = 0;
        alertMin = 0;
    }else if (indexPath.row == 2) {
        alertMsg = @"Alert 15 minutes before game starts";
        alertType = 0;
        alertMin = 15;
    }else {
        NSDictionary *customAlert = [customAlerts objectAtIndex:indexPath.row - 3];
        alertMsg = [customAlert objectForKey:@"message"];
        alertType = 1;
        alertMin = [[customAlert objectForKey:@"minute"] intValue];
    }
    UILabel *txtAlert = (UILabel *)[cell viewWithTag:10];
    UISwitch *swAlert = (UISwitch *)[cell viewWithTag:11];
    txtAlert.text = alertMsg;
    
    txtAlert.textAlignment = NSTextAlignmentLeft;
    int i = 0;
    for (i = 0; i < selAlerts.count; i++) {
        NSDictionary *curAlert = [selAlerts objectAtIndex:i];
        if ([[curAlert objectForKey:@"type"] intValue] == alertType && [[curAlert objectForKey:@"minute"] intValue] == alertMin) {
            break;
        }
    }
    if (i == selAlerts.count) {
        [swAlert setOn:NO animated:NO];
    }else {
        [swAlert setOn:YES animated:NO];
    }
    [swAlert addTarget:self action:@selector(onTapAlert:) forControlEvents:UIControlEventValueChanged];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)onTapAlert:(UISwitch *)swAlert
{
    UITableViewCell *cell = (UITableViewCell *)swAlert.superview.superview;
    if ([[[UIDevice currentDevice] systemVersion] intValue] == 7) {
        cell = (UITableViewCell *)swAlert.superview.superview.superview;
    }
    NSIndexPath *indexPath = [self.tblAlerts indexPathForCell:cell];
    int alertType = 0;
    int alertMin = 0;
    if (indexPath.row == 1) {
        alertType = 0;
        alertMin = 0;
    }else if (indexPath.row == 2) {
        alertType = 0;
        alertMin = 15;
    }else {
        NSDictionary *customAlert = [customAlerts objectAtIndex:indexPath.row - 3];
        alertType = 1;
        alertMin = [[customAlert objectForKey:@"minute"] intValue];
    }
    int index = -1;
    for (int i = 0; i < selAlerts.count; i++) {
        NSDictionary *curAlert = [selAlerts objectAtIndex:i];
        if ([[curAlert objectForKey:@"type"] intValue] == alertType && [[curAlert objectForKey:@"minute"] intValue] == alertMin) {
            index = i;
            break;
        }
    }
    if (swAlert.isOn) {
        if (index == -1) {
            [selAlerts addObject:@{@"type":@(alertType),@"minute":@(alertMin)}];
        }
        if ([[[Resources sharedResources] matchesList] count] > 0) {
            int index = 0;
            NSMutableArray *curMatches = [[NSMutableArray alloc] init];
            for (int i = 0; i < [[Resources sharedResources] matchesList].count; i++) {
                ScheduleItem *item = (ScheduleItem *)[[[Resources sharedResources] matchesList] objectAtIndex:i];
                if (item.status == 0) {
                    [curMatches addObject:item];
                }
            }
            for (int i = 0; i < [curMatches count]; i++) {
                ScheduleItem *item = [curMatches objectAtIndex:i];
                NSDate *alertTime = [item.matchDateTimeLocal dateByAddingTimeInterval:-60 * alertMin];
                if(![[[Resources sharedResources] getScheduleNotifier] getIsAlertScheduled:item.matchId dateTime:alertTime])
                {
                    [[[Resources sharedResources] getScheduleNotifier] scheduleAlert:item.matchId teamA:item.teamAname teamB:item.teamBname dateTime:alertTime matchTime:item.matchDateTimeLocal];
                    item.alarm = YES;
                }
                index++;
                if (index == 15) {
                    break;
                }
            }
        }
    }else {
        if (index != -1) {
            [selAlerts removeObjectAtIndex:index];
        }
        if ([[[Resources sharedResources] matchesList] count] > 0) {
            int index = 0;
            NSMutableArray *curMatches = [[NSMutableArray alloc] init];
            for (int i = 0; i < [[Resources sharedResources] matchesList].count; i++) {
                ScheduleItem *item = (ScheduleItem *)[[[Resources sharedResources] matchesList] objectAtIndex:i];
                if (item.status == 0) {
                    [curMatches addObject:item];
                }
            }
            for (int i = 0; i < [curMatches count]; i++) {
                ScheduleItem *item = [curMatches objectAtIndex:i];
                NSDate *alertTime = [item.matchDateTimeLocal dateByAddingTimeInterval:-60 * alertMin];
                if([[[Resources sharedResources] getScheduleNotifier] getIsAlertScheduled:item.matchId dateTime:alertTime])
                {
                    [[[Resources sharedResources] getScheduleNotifier] removeFromAlert:item.matchId matchTime:alertTime];
                    item.alarm = NO;
                }
                index++;
                if (index == 15) {
                    break;
                }
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:selAlerts forKey:@"selAlerts"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)onCustomAlert
{
    SetAlertsViewController *viewController = [[SetAlertsViewController alloc] initWithNibName:@"SetAlertsViewController" bundle:nil];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 3) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int alertType = 0;
        int alertMin = 0;
        if (indexPath.row == 1) {
            alertType = 0;
            alertMin = 0;
        }else if (indexPath.row == 2) {
            alertType = 0;
            alertMin = 15;
        }else {
            NSDictionary *customAlert = [customAlerts objectAtIndex:indexPath.row - 3];
            alertType = 1;
            alertMin = [[customAlert objectForKey:@"minute"] intValue];
        }
        int index = -1;
        for (int i = 0; i < selAlerts.count; i++) {
            NSDictionary *curAlert = [selAlerts objectAtIndex:i];
            if ([[curAlert objectForKey:@"type"] intValue] == alertType && [[curAlert objectForKey:@"minute"] intValue] == alertMin) {
                index = i;
                break;
            }
        }
        if (index != -1) {
            [selAlerts removeObjectAtIndex:index];
        }
        [customAlerts removeObjectAtIndex:indexPath.row - 3];
        [[NSUserDefaults standardUserDefaults] setObject:selAlerts forKey:@"selAlerts"];
        [[NSUserDefaults standardUserDefaults] setObject:customAlerts forKey:@"customAlerts"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if ([[[Resources sharedResources] matchesList] count] > 0) {
            NSMutableArray *curMatches = [[NSMutableArray alloc] init];
            for (int i = 0; i < [[Resources sharedResources] matchesList].count; i++) {
                ScheduleItem *item = (ScheduleItem *)[[[Resources sharedResources] matchesList] objectAtIndex:i];
                if (item.status == 0) {
                    [curMatches addObject:item];
                }
            }
            int index = 0;
            for (int i=0; i < 15 && i < [curMatches count]; i++) {
                ScheduleItem *item = [curMatches objectAtIndex:i];
                NSDate *alertTime = [item.matchDateTimeLocal dateByAddingTimeInterval:-60 * alertMin];
                if([[[Resources sharedResources] getScheduleNotifier] getIsAlertScheduled:item.matchId dateTime:alertTime])
                {
                    [[[Resources sharedResources] getScheduleNotifier] removeFromAlert:item.matchId matchTime:alertTime];
                    item.alarm = NO;
                }
                index++;
                if (index == 15) {
                    break;
                }
            }
        }
    }
}

-(void)addAlert:(SetAlertsViewController *)viewController minute:(int)minute
{
    if (minute == 0 || minute == 15) {
        [viewController.navigationController popViewControllerAnimated:YES];
        return;
    }
    int i = 0;
    for (i = 0; i < customAlerts.count; i++) {
        NSDictionary *curAlert = [customAlerts objectAtIndex:i];
        if ([[curAlert objectForKey:@"minute"] intValue] == minute && [[curAlert objectForKey:@"type"] intValue] == 1) {
            break;
        }
    }
    if (i == customAlerts.count) {
        NSString *alertMsg = @"";
        if (minute == 1) {
            alertMsg = @"1 minute";
        }else if (minute < 60) {
            alertMsg = [NSString stringWithFormat:@"%d minutes",minute];
        }else if (minute / 60 == 1) {
            if (minute % 60 == 0) {
                alertMsg = @"1 hour";
            }else if (minute % 60 == 1) {
                alertMsg = [NSString stringWithFormat:@"1 hour %d minute",minute % 60];
            }else {
                alertMsg = [NSString stringWithFormat:@"1 hour %d minutes",minute % 60];
            }
        }else {
            if (minute % 60 == 0) {
                alertMsg = [NSString stringWithFormat:@"%d hours",minute / 60];
            }else if (minute % 60 == 1) {
                alertMsg = [NSString stringWithFormat:@"%d hours %d minute",minute / 60, minute % 60];
            }else {
                alertMsg = [NSString stringWithFormat:@"%d hours %d minutes",minute / 60, minute % 60];
            }
        }
        [customAlerts addObject:@{@"message":alertMsg,@"minute":@(minute),@"type":@(1)}];
        [selAlerts addObject:@{@"minute":@(minute),@"type":@(1)}];
        
        [[NSUserDefaults standardUserDefaults] setObject:customAlerts forKey:@"customAlerts"];
        [[NSUserDefaults standardUserDefaults] setObject:selAlerts forKey:@"selAlerts"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tblAlerts reloadData];
        [viewController.navigationController popViewControllerAnimated:YES];
        if ([[[Resources sharedResources] matchesList] count] > 0) {
            NSMutableArray *curMatches = [[NSMutableArray alloc] init];
            for (int i = 0; i < [[Resources sharedResources] matchesList].count; i++) {
                ScheduleItem *item = (ScheduleItem *)[[[Resources sharedResources] matchesList] objectAtIndex:i];
                if (item.status == 0) {
                    [curMatches addObject:item];
                }
            }
            int index = 0;
            for (int i=0; i < 15 && i < [curMatches count]; i++) {
                ScheduleItem *item = [curMatches objectAtIndex:i];
                NSDate *alertTime = [item.matchDateTimeLocal dateByAddingTimeInterval:-60 * minute];
                if(![[[Resources sharedResources] getScheduleNotifier] getIsAlertScheduled:item.matchId dateTime:alertTime])
                {
                    [[[Resources sharedResources] getScheduleNotifier] scheduleAlert:item.matchId teamA:item.teamAname teamB:item.teamBname dateTime:alertTime matchTime:item.matchDateTimeLocal];
                    item.alarm = YES;
                }
                index++;
                if (index == 15) {
                    break;
                }
            }
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"You've already added this alert" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *viewBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    viewBorder.backgroundColor = [UIColor colorWithRed:66 / 255.0f green:153 / 255.0f blue:220 / 255.0f alpha:0.5f];
    return viewBorder;
}

@end
