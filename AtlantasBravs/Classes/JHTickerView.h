//
// JHTickerView.h
// Ticker
//  Created by JAVED ZAHID on 03/12/2011.
//  Copyright 2011 Applausible. All rights reserved.
//
//
// CodeName: BraveBalls
// ProjectName: Atlanta Brave
// @author Syed Zain Raza
// Copyright SOFTWAREWEAVER - ATLANTA BRAVES (iphone)
//

#import <UIKit/UIKit.h>

/**
 * JHTickerView -  TickerView
 * @brief used for animating ticker on CustomUILabel
 */
@interface JHTickerView : UIView {
    
	// The ticker strings
	NSString        *tickerStrings;
	
	// The ticker speed
	float           tickerSpeed;
	
	// Should the ticker loop
	BOOL            loops;
	
	// The current state of the ticker
	BOOL            running;
	
	// The ticker label
	UILabel    *tickerLabel;
	
	// The ticker font
	UIFont          *_tickerFont;
    UIFont          *_tickerHFont;
    
    UIColor         *_tickerColor;
    
    NSTextAlignment textAlignment;
}
@property(nonatomic)                NSTextAlignment textAlignment;
@property(nonatomic, strong)        UIFont *tickerFont;
@property(nonatomic, strong)        UIFont *tickerHFont;
@property(nonatomic, strong)        UIColor *tickerColor;
@property(nonatomic, copy)          NSString *tickerStrings;
@property(nonatomic)                float tickerSpeed;
@property(nonatomic)                BOOL loops;

-(void)makeView;
-(void)start;
-(void)stop;
-(void)resume;
-(void)setTickerText:(NSString *)text;
-(void)setTickerFrame:(CGRect)rect;

@end
