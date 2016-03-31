//
//  PlayerStatsViewController.m
//  AtlantasBravs
//
//  Created by Ying on 4/20/15.
//
//

#import "PlayerStatsViewController.h"
#import "Resources.h"

@interface PlayerStatsViewController () <UIWebViewDelegate>

@end

@implementation PlayerStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Braves Stats";
    
    self.navigationItem.rightBarButtonItem = [self addMenuBtn];
    
    [self.webView setDelegate:self];
    //self.webView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.theprofessionalssports.com/server/getstandinginfo.php"]];
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:requestObj];
}

-(UIBarButtonItem *)addMenuBtn
{
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 44, 44);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menu_btn.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *menuBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    
    menuBtnView.bounds = CGRectOffset(menuBtnView.bounds, -10, 0);
    [menuBtnView addSubview:menuBtn];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtnView];
    return menuItem;
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

-(IBAction)doAction:(id)sender   {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Please choose an option" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
   
    UIAlertAction *simple = [UIAlertAction actionWithTitle:@"Simple Stats View" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.webView.scalesPageToFit = NO;
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.theprofessionalssports.com/server/getstanding_simple.php"]];
        [self.webView loadRequest:requestObj];
    }];
    
    UIAlertAction *detail = [UIAlertAction actionWithTitle:@"Detailed Stats View" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.webView.scalesPageToFit = YES;
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.theprofessionalssports.com/server/getstandinginfo.php"]];
        [self.webView loadRequest:requestObj];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [sheet addAction:simple];
    [sheet addAction:detail];
    [sheet addAction:cancel];
    
    [self presentViewController:sheet animated:YES completion:nil];
}

#pragma mark - webView
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType  {
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    return  YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView   {
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error  {
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:YES];
}

@end
