//
//  SetAlertsViewController.m
//  AtlantasBravs
//
//  Created by Ying on 4/23/15.
//
//

#import "SetAlertsViewController.h"
#import "Resources.h"

@interface SetAlertsViewController ()

@end

@implementation SetAlertsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Add Alert";
    
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = [self addBackBtn];
    self.navigationItem.rightBarButtonItem = [self addSaveBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIBarButtonItem *)addBackBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 64, 44);
    [backBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorWithRed:51 / 255.0f green:102 / 255.0f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
    backBtnView.bounds = CGRectOffset(backBtnView.bounds, 14, 0);
    [backBtnView addSubview:backBtn];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
    return backItem;
}

-(void)actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIBarButtonItem *)addSaveBtn
{
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 54, 44);
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithRed:51 / 255.0f green:102 / 255.0f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *saveBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    
    saveBtnView.bounds = CGRectOffset(saveBtnView.bounds, -10, 0);
    [saveBtnView addSubview:saveBtn];
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtnView];
    return saveItem;
}

-(void)actionSave
{
    int hour = (int)[self.picTime selectedRowInComponent:0];
    int min = (int)[self.picTime selectedRowInComponent:2];
    
    [self.delegate addAlert:self minute:(hour * 60 + min)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addButtonClicked:(id)sender {
    if ([self.timeField.text isEqualToString:@""]) {
        return;
    }

    [[Resources sharedResources] showNetworkingActivity];
    [NSThread detachNewThreadSelector:@selector(makeCustomSchedule:) toTarget:self withObject:nil];
}

- (void)makeCustomSchedule:(NSString *)indexString  {
    @autoreleasepool {
        ScheduleNotifier *schedNotifier = [[Resources sharedResources] getScheduleNotifier];
        
        [schedNotifier insertMatchForSchedule:@"-1" teamA:@"" teamB:@"" datetime:nil];
        
        if ([[[Resources sharedResources] matchesList] count] > 0) {
            NSMutableArray *curMatches = [[NSMutableArray alloc] init];
            for (int i = 0; i < [[Resources sharedResources] matchesList].count; i++) {
                ScheduleItem *item = (ScheduleItem *)[[[Resources sharedResources] matchesList] objectAtIndex:i];
                if (item.status == 0) {
                    [curMatches addObject:item];
                }
            }
            for (int i=0; i < 15 && i < [curMatches count]; i++) {
                ScheduleItem *item = [curMatches objectAtIndex:i];
                NSDate *alertTime = [item.matchDateTimeLocal dateByAddingTimeInterval:-60 * [self.timeField.text intValue]];
                
                if(![[[Resources sharedResources] getScheduleNotifier] getIsAlertScheduled:item.matchId dateTime:alertTime])
                {
                    [[[Resources sharedResources] getScheduleNotifier] scheduleAlert:[item matchId] teamA:[item teamAshortname] teamB:[item teamBshortname] dateTime:alertTime matchTime:item.matchDateTimeLocal];
                    item.alarm = YES;
                }
            }
        }
        
        [self performSelectorOnMainThread:@selector(scheduleDone:) withObject:[NSNumber numberWithInt:1] waitUntilDone:NO];
    }
}

- (void)scheduleDone:(NSNumber*)a {
    if ([a intValue] == 1) {
        [self performSelector:@selector(scheduleDone:) withObject:nil afterDelay:1.0];
    }
    else {
        [[Resources sharedResources] hideNetworkIndicator];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return 24;
    }else if (component == 1) {
        return 1;
    }
    return 60;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 1) {
        return 20.0f;
    }
    return 40.0f;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%d",(int)row];
    }else if (component == 1) {
        return @":";
    }
    return [NSString stringWithFormat:@"%02d",(int)row];
}

@end
