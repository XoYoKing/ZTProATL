//
//  EditNewsSourceViewController.m
//  AtlantasBravs
//
//  Created by Ying on 4/18/15.
//
//

#import "EditNewsSourceViewController.h"
#import "Resources.h"
#import "AFNetworking.h"
#import "AddNewSourceViewController.h"
#import "RadioViewController.h"

@interface EditNewsSourceViewController () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,AddNewSourceViewControllerDelegate>  {
    NSMutableArray *dataArray;
}

@end

@implementation EditNewsSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    mySourceArray = [[NSMutableArray alloc] init];
    if ([defaults objectForKey:@"mysource"] != nil) {
        mySourceArray = [NSMutableArray arrayWithArray:(NSArray *)[defaults objectForKey:@"mysource"]];
    }
    
//    self.navigationItem.rightBarButtonItem = [self addInfoBtn];
    
    self.navigationItem.title = @"ZTP Braves Sources";
    
/*
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(addORDeleteRows)], [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewSource)]];
*/    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    dataArray = nil;
    [self getRssInfo];
}

-(UIBarButtonItem *)addInfoBtn
{
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    infoBtn.frame = CGRectMake(0, 0, 44, 44);
    [infoBtn setBackgroundImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *infoBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    infoBtnView.bounds = CGRectOffset(infoBtnView.bounds, -10, 0);
    [infoBtnView addSubview:infoBtn];
    
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtnView];
    return infoItem;
}

-(void)showInfo
{
    RadioViewController *viewController = [[RadioViewController alloc] initWithNibName:@"RadioViewController" bundle:nil];
    self.navigationItem.title = @"Back";
    viewController.radioName = @"RSS/XML Feed";
    viewController.urlString = @"http://www.problogger.net/what-is-rss/";
    [self.navigationController pushViewController:viewController animated:YES];
}

-(UIBarButtonItem *)addPlusBtn
{
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    plusBtn.frame = CGRectMake(0, 0, 44, 44);
    [plusBtn setTitle:@"Add" forState:UIControlStateNormal];
    plusBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
    [plusBtn addTarget:self action:@selector(addNewSource) forControlEvents:UIControlEventTouchUpInside];
    
    //settingsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -22, 0, 0);
    UIBarButtonItem *plusItem = [[UIBarButtonItem alloc] initWithCustomView:plusBtn];
    return plusItem;
}

-(void)actionPlus
{
    AddNewSourceViewController *viewController = [[AddNewSourceViewController alloc] initWithNibName: @"AddNewSourceViewController" bundle:nil];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)doneAdd
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    mySourceArray = [[NSMutableArray alloc] init];
    if ([defaults objectForKey:@"mysource"] != nil) {
        mySourceArray = [NSMutableArray arrayWithArray:(NSArray *)[defaults objectForKey:@"mysource"]];
    }
    [[[Resources sharedResources] getXMLReader] parseXMLForNews:nil];
    [self.tableView reloadData];
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

- (void)addORDeleteRows     {
    [self dismissKeyboard];
    [self.addView setHidden:YES];
    
    if (self.editing) {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else    {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

- (void)addNewSource    {
    [self.addView setHidden:NO];
}

- (void)getRssInfo  {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selRssList"] != nil) {
        [Resources sharedResources].selRssList = [NSMutableArray arrayWithArray:(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"selRssList"]];
    }
    [[Resources sharedResources] showNetworkingActivity];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:TeamID forKey:@"teamid"];
    
    NSURL *baseURL = [NSURL URLWithString:SERVICE_BASE_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

    [manager GET:@"getrss.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *resultData = (NSArray *)responseObject;
        if (dataArray == nil) {
            dataArray = [[NSMutableArray alloc] init];
        }
        dataArray = [NSMutableArray arrayWithArray:resultData];
        
        [self.tableView reloadData];
        
        if ([Resources sharedResources].selRssList.count == 0) {
            [Resources sharedResources].selRssList = [dataArray mutableCopy];
        }        
        NSLog(@"getRssInfo: %@", responseObject);
        [[Resources sharedResources] hideNetworkIndicator];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableView reloadData];
        [[Resources sharedResources] hideNetworkIndicator];
        NSLog(@"getRssInfo-error: %@", error);
    }];
}

- (void)dismissKeyboard     {
    [self.addNameField resignFirstResponder];
    [self.addLinkField resignFirstResponder];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    if (dataArray == nil) {
        return 0;
    }
    NSInteger count = 1 + [dataArray count] + [mySourceArray count];
/*
    if (self.editing) {
        count++;
    }
*/
    return count;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0 && indexPath.row <= mySourceArray.count) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0 && indexPath.row <= mySourceArray.count) {
        NSDictionary *source = [mySourceArray objectAtIndex:indexPath.row - 1];
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [mySourceArray removeObjectAtIndex:indexPath.row - 1];
            [[NSUserDefaults standardUserDefaults] setObject:mySourceArray forKey:@"mysource"];
            NSString *curSourceName = [source objectForKey:@"sourcename"];
            int index = 0;
            for (NSDictionary *dictionary in [Resources sharedResources].selRssList) {
                if ([dictionary[@"sourcename"] isEqualToString:curSourceName]) {
                    [[Resources sharedResources].selRssList removeObjectAtIndex:index];
                    break;
                }
                index++;
            }
            if (index < [Resources sharedResources].selRssList.count) {
                [[NSUserDefaults standardUserDefaults] setObject:[Resources sharedResources].selRssList forKey:@"selRssList"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[[Resources sharedResources] getXMLReader] parseXMLForNews:nil];
            }
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString *cellIdentifier = @"cell";
    if (indexPath.row == 0) {
        //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        UITableViewCell * cell = [[UITableViewCell alloc] init];
        NSString *btnText = @"Add Sources\n(rss/xml feeds only)";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:btnText];
        [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17.0f]} range:NSMakeRange(0, 11)];
        [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:13.0f]} range:NSMakeRange(12, btnText.length - 12)];
        cell.textLabel.attributedText = attrStr;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.numberOfLines = 2;
        return cell;
    }
    NSDictionary *source;
    if (indexPath.row <= mySourceArray.count) {
        source = [mySourceArray objectAtIndex:indexPath.row - 1];
    }else {
        source = [dataArray objectAtIndex:indexPath.row - mySourceArray.count - 1];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.editingAccessoryType = YES;
    }
    cell.textLabel.text = [source objectForKey:@"sourcename"];
    cell.detailTextLabel.text = [source objectForKey:@"rsslink"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSString *curSourceName = [source objectForKey:@"sourcename"];
    for (NSDictionary *dictionary in [Resources sharedResources].selRssList)    {
        if ([dictionary[@"sourcename"] isEqualToString:curSourceName]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
    }

    return cell;
}

/*- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath    {
    if (indexPath.row < mySourceArray.count) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}*/

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath  {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [mySourceArray removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:mySourceArray forKey:@"mysource"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath     {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        AddNewSourceViewController *viewController = [[AddNewSourceViewController alloc] initWithNibName: @"AddNewSourceViewController" bundle:nil];
        viewController.delegate = self;
        viewController.serverSources = [NSMutableArray arrayWithArray:dataArray];
        [self.navigationController pushViewController:viewController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    NSDictionary *source;
    if (indexPath.row <= mySourceArray.count) {
        source = [mySourceArray objectAtIndex:indexPath.row - 1];
    }else {
        source = [dataArray objectAtIndex:indexPath.row - mySourceArray.count - 1];
    }
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[[Resources sharedResources] selRssList] addObject:source];
    }
    else    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSUInteger index = 0;
        NSString *curSourceName = [source objectForKey:@"sourcename"];
        for (NSDictionary *dictionary in [Resources sharedResources].selRssList) {
            if ([dictionary[@"sourcename"] isEqualToString:curSourceName]) {
                [[Resources sharedResources].selRssList removeObjectAtIndex:index];
                break;
            }
            index++;
        }
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[Resources sharedResources].selRssList forKey:@"selRssList"];
    [defaults synchronize];
    
    [[[Resources sharedResources] getXMLReader] parseXMLForNews:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//////////////////////////////////////////
- (IBAction)addButtonClicked:(id)sender {
    if ([self.addNameField.text isEqualToString:@""] || [self.addLinkField.text isEqualToString:@""]) {
        return;
    }
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dic = [dataArray objectAtIndex:i];
        if ([[dic objectForKey:@"sourcename"] isEqualToString:self.addNameField.text] || [[dic objectForKey:@"rsslink"] isEqualToString:self.addLinkField.text]) {
            [self dismissKeyboard];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Duplicate" message:@"There's already such like this source name or rss link" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    //[[Resources sharedResources] showNetworkingActivity];
    [self dismissKeyboard];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setValue:@(0) forKey:@"teamid"];
    [parameters setValue:self.addNameField.text forKey:@"sourcename"];
    [parameters setValue:self.addLinkField.text forKey:@"rsslink"];
    [parameters setValue:@(1) forKey:@"rssstatus"];
    [parameters setValue:TeamID forKey:@"teamid"];
    [parameters setValue:@(0) forKey:@"selected"];
    
    [mySourceArray addObject:parameters];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:mySourceArray forKey:@"mysource"];
    [defaults synchronize];
    self.addView.hidden = YES;
    [self.tableView reloadData];
    
    /*NSURL *baseURL = [NSURL URLWithString:SERVICE_BASE_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager POST:@"addrsssource.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //[[Resources sharedResources] hideNetworkIndicator];
        //[self.addView setHidden:YES];
        //[self getRssInfo];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Add RSS-error: %@", error);
        //[[Resources sharedResources] hideNetworkIndicator];
    }];*/
}
@end
