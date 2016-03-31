//
//  NetworkActivityView.h
//  SIPTabApp
//
//  Created by Zain Raza on 9/26/12.
//  Copyright (c) 2012 __Software Weaver Pakistan__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkActivityView : UIView
{
    
    UIActivityIndicatorView *activityIndicator;
}
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

- (void)initIndicator;
- (void)startAcitivity;
- (void)stopAcitivity;
@end
