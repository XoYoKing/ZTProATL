//
//  RootViewController.m
//  AtlantasBravs
//
//  Created by Zain Raza on 12/16/11.
//  Copyright (c) 2011 __Creative Gamers__. All rights reserved.
//

#import "RootViewController.h"
#import "Resources.h"

@implementation RootViewController


- (void)xmlParsingComplete
{
    [[Resources sharedResources] NavigateToTab];
}

- (void)xmlParsingError:(NSString *)errorMsg
{
    [[Resources sharedResources] NavigateToTab];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
