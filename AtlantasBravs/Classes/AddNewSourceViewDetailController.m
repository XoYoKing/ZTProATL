//
//  AddNewSourceViewController.m
//  AtlantasBravs
//
//  Created by Sol on 5/15/15.
//
//

#import "AddNewSourceViewDetailController.h"

@interface AddNewSourceViewDetailController ()
@property (weak, nonatomic) IBOutlet UIView *view_down;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation AddNewSourceViewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"ZTPro Help";
    [self.scroll setContentSize:CGSizeMake(
                      self.view_down.frame.size.width
                                          
                                           , self.view_down.frame.size.height)];
    self.view_down.frame = CGRectMake(0, 0, self.view_down.frame.size.width, self.view_down.frame.size.height);
    
   // [self.scroll addSubview:self.view_down];
    
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
- (IBAction)onOPenLInk:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.problogger.net/what-is-rss/"]];    
}


@end
