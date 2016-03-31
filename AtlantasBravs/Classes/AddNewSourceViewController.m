//
//  AddNewSourceViewController.m
//  AtlantasBravs
//
//  Created by Sol on 5/15/15.
//
//

#import "AddNewSourceViewController.h"
#import "Resources.h"
#import "AddNewSourceViewDetailController.h"
@interface AddNewSourceViewController ()

@end

@implementation AddNewSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Personal Sources";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    mySourceArray = [[NSMutableArray alloc] init];
    if ([defaults objectForKey:@"mysource"] != nil) {
        mySourceArray = [NSMutableArray arrayWithArray:(NSArray *)[defaults objectForKey:@"mysource"]];
    }
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

- (IBAction)onAdd:(id)sender {
    if (self.txtSourceName.text == nil || [self.txtSourceName.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Source" message:@"Please enter source name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if (self.txtLink.text == nil || [self.txtLink.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Source" message:@"Please enter rss/xml source link" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    for (int i = 0; i < mySourceArray.count; i++) {
        NSDictionary *curSource = [mySourceArray objectAtIndex:i];
        if ([[curSource objectForKey:@"sourcename"] isEqualToString:self.txtSourceName.text] || [[curSource objectForKey:@"rsslink"] isEqualToString:self.txtLink.text]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Source" message:@"Duplicated source name or link" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    for (int i = 0; i < self.serverSources.count; i++) {
        NSDictionary *curSource = [self.serverSources objectAtIndex:i];
        if ([[curSource objectForKey:@"sourcename"] isEqualToString:self.txtSourceName.text] || [[curSource objectForKey:@"rsslink"] isEqualToString:self.txtLink.text]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Source" message:@"Duplicated source name or link" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    NSDictionary *newSource = @{@"sourcename":self.txtSourceName.text,
                                @"rsslink":self.txtLink.text};
    if (mySourceArray.count == 0) {
        [mySourceArray addObject:newSource];
    }else {
        [mySourceArray insertObject:newSource atIndex:0];
    }
    [[[Resources sharedResources] selRssList] addObject:newSource];
    [[NSUserDefaults standardUserDefaults] setObject:[Resources sharedResources].selRssList forKey:@"selRssList"];
    
    [[NSUserDefaults standardUserDefaults] setObject:mySourceArray forKey:@"mysource"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.txtLink.text = @"";
    self.txtSourceName.text = @"";
    [self.delegate doneAdd];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)on_openNewPage:(id)sender {
    
    AddNewSourceViewDetailController *viewController = [[AddNewSourceViewDetailController alloc] initWithNibName: @"AddNewSourceViewDetailController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

@end
