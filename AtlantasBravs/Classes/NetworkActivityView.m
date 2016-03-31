//
//  NetworkActivityView.m
//  SIPTabApp
//
//  Created by Zain Raza on 9/26/12.
//  Copyright (c) 2012 __Software Weaver Pakistan__. All rights reserved.
//

#import "NetworkActivityView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NetworkActivityView

@synthesize activityIndicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)initIndicator
{  
    float x = self.frame.size.width/2 - 40;
    float y = self.frame.size.height/2 - 40;
    
    [self setFrame:CGRectMake(x, y, 80, 80)];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setHidesWhenStopped:NO];
    
    [self.activityIndicator setFrame:CGRectMake(22.5, 22.5, 37, 37)];
    
    [self addSubview:self.activityIndicator];
    
    x = self.frame.size.width/2 - (self.activityIndicator.bounds.size.height*1.5);
    y = self.frame.size.height/2 - (self.activityIndicator.bounds.size.height*1.5);
    
    CGFloat border = self.activityIndicator.bounds.size.height / 2;
    CGRect hudFrame = CGRectMake(0, 0, 80, 80);
    UIView *hud = [[UIView alloc] initWithFrame:hudFrame];
    hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.67];
    hud.layer.cornerRadius = border;
    [self addSubview:hud];
    [self sendSubviewToBack:hud];
    
    hud = nil;
}

- (void)dealloc
{
    //self.activityIndicator;
    
}

- (void)startAcitivity
{
    [self.activityIndicator startAnimating];
}

- (void)stopAcitivity
{
    [self.activityIndicator stopAnimating];
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
