//
//  Global.h
//  Created by Zain Raza.
//  Copyright (c) 2012 __SoftwareWeaver__. All rights reserved.
//


#import <Foundation/Foundation.h>


#define APP_NAME		@"ATLBaseball"


#define DATABASE_NAME   @"123"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

extern BOOL g_is_showing_popup;


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;
static const CGFloat IPAD_LANDSCAPE_KEYBOARD_HEIGHT = 370;
//static CGFloat animatedDistance = 0.0;