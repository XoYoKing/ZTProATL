//
//  ScheduleItem.h
//  AtlantasBravs
//
//  Created by Zain Raza on 12/16/11.
//  Copyright (c) 2011 __Creative Gamers__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleItem : NSObject

@property (nonatomic, copy) NSString *matchId;
@property (nonatomic, copy) NSString *teamAname;
@property (nonatomic, copy) NSString *teamAshortname;
@property (nonatomic, copy) NSString *teamBname;
@property (nonatomic, copy) NSString *teamBshortname;
@property (nonatomic, copy) NSString *hometeam;
@property (nonatomic, copy) NSString *localTV;
@property (nonatomic, copy) NSString *localRadio;
@property (nonatomic, copy) NSString *probableStarters;
@property (nonatomic, assign) int score1;
@property (nonatomic, assign) int score2;
@property (nonatomic, assign) int status;

//@property (nonatomic, copy) NSString *matchDate;
//@property (nonatomic, copy) NSString *matchTime;
@property (nonatomic, copy) NSDate *matchDateTimeUTC;
@property (nonatomic, copy) NSDate *matchDateTimeLocal;
@property (nonatomic, getter = isAlarmEnabled)       BOOL     alarm;

@end
