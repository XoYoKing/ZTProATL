//
//  JHTickerView.m
//  Ticker
//
//  Created by JAVED ZAHID on 03/12/2011.
//  Copyright 2011 Applausible. All rights reserved.
//
//
// CodeName: BraveBalls
// ProjectName: Atlanta Brave
// @author Syed Zain Raza
// Copyright SOFTWAREWEAVER - ATLANTA BRAVES (iphone)
//

#import "JHTickerView.h"
#import <QuartzCore/QuartzCore.h>



@interface JHTickerView(Private)
-(void)setupView;
-(void)animateCurrentTickerString;
-(void)pauseLayer:(CALayer *)layer;
-(void)resumeLayer:(CALayer *)layer;
@end

@implementation JHTickerView

@synthesize tickerStrings;
@synthesize tickerSpeed;
@synthesize loops;

@synthesize tickerFont = _tickerFont;
@synthesize tickerHFont = _tickerHFont;
@synthesize tickerColor = _tickerColor;
@synthesize textAlignment;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	if( (self = [super initWithCoder:aDecoder]) ) {
		// Initialization code
	}
	return self;
}

-(void)setupView {
	// Set background color to white
	[self setBackgroundColor:[UIColor clearColor]];
	
	// Set a corner radius
	[self setClipsToBounds:YES];
	
	// Set the font

	
    if (_tickerColor == NULL && _tickerColor == nil) {
        _tickerColor = [UIColor blackColor];
    }
    
	tickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	[tickerLabel setBackgroundColor:[UIColor clearColor]];
	[tickerLabel setNumberOfLines:1];
	[tickerLabel setFont:_tickerFont];
    [tickerLabel setTextColor:_tickerColor];
    [tickerLabel setTextAlignment:textAlignment];
	[self addSubview:tickerLabel];
	[tickerLabel setText:tickerStrings];
	// Set that it loops by default
	loops = YES;
}

-(void)animateCurrentTickerString
{
    if (running == YES) {
        
        
        // Calculate the size of the text and update the frame size of the ticker label
        CGSize maximumSize = CGSizeMake(9999, 9999);
        UIFont *myFont = [tickerLabel font];
        CGSize myStringSize = [tickerStrings sizeWithFont:myFont
                                        constrainedToSize:maximumSize 
                                            lineBreakMode:tickerLabel.lineBreakMode];
        
        if(myStringSize.width > self.frame.size.width)
        {
            // Move off screen
            [tickerLabel setFrame:CGRectMake(300, 0, myStringSize.width*1.5, self.frame.size.height)];
            
            // Set the string
            [tickerLabel setText:tickerStrings];
            
            // Calculate a uniform duration for the item	
            float duration = (myStringSize.width + self.frame.size.width) / tickerSpeed; //
            //float duration = 5;
            
            // Create a UIView animation
            [UIView beginAnimations:@"" context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationDuration:duration];
            [UIView setAnimationRepeatCount:20];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(tickerMoveAnimationDidStop:finished:context:)];
            
            [tickerLabel setFrame:CGRectMake(-myStringSize.width, 0, myStringSize.width*2, self.frame.size.height)];
            
            [UIView commitAnimations];
        }
        
    }
    else {
        [tickerLabel setFrame:CGRectMake(300, 0, self.frame.size.width, self.frame.size.height)];
    }
}
-(void)setTickerText:(NSString *)text {
    [self setTickerStrings:text];
    [tickerLabel setText:text];
}

-(void)tickerMoveAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	[tickerLabel.layer removeAllAnimations];
    [self.layer removeAllAnimations];
    running = NO;
	// Animate
}

#pragma mark - Ticker Animation Handling

-(void)makeView {
    
    [self setupView];
}
-(void)start {
	
	// Set the index to 0 on starting
	//currentIndex = 0;
	
	// Set running
	running = YES;
	
	// Start the animation
	[self animateCurrentTickerString];
}

-(void)setTickerFrame:(CGRect)rect {
    [tickerLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

-(void)stop {
	
	// Check if running
	if(running) {
		// Pause the layer
        // Set the string
        [tickerLabel setText:tickerStrings];
        [tickerLabel.layer removeAllAnimations];
		[self.layer removeAllAnimations];
        //[self pauseLayer:self.layer];
        
		running = NO;
	}
    running = FALSE;
}

-(void)resume {
    
	// Check not running
	if(!running) { 
		// Resume the layer
		[self resumeLayer:self.layer];
		
		running = YES;
	}
}

#pragma mark - UIView layer animations utilities
//-(void)pauseLayer:(CALayer *)layer
//{
//    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
//    layer.speed = 0.0;
//    layer.timeOffset = pausedTime;
//}
//
//-(void)resumeLayer:(CALayer *)layer
//{
//    CFTimeInterval pausedTime = [layer timeOffset];
//    layer.speed = 0.2;
//    layer.timeOffset = 0.0;
//    layer.beginTime = 0.0;
//    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
//    layer.beginTime = timeSincePause;
//}

/**
 deallocates the class and its members
 @override overridden method
 */
- (void)dealloc
{
    running = NO;
	
}

@end
