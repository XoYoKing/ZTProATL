//
//  ScheduleNotifier.h
//  AtlantasBravs
//
//  Created by MacBook on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface ScheduleNotifier : NSObject

@property (nonatomic, strong)       NSArray *documentPaths;
@property (nonatomic, strong)       NSString *documentDir;
@property (nonatomic, strong)       NSString *dataBasePath;
@property (nonatomic, strong)       NSString *dataBaseName;

@property (nonatomic, strong)       NSMutableArray *dbSchedule;

- (BOOL)schedule:(NSString *)matchId teamA:(NSString *)teamA teamB:(NSString *)teamB datetime:(NSDate*)datetime;
- (BOOL)scheduleAlert:(NSString *)matchId teamA:(NSString *)teamA teamB:(NSString *)teamB dateTime:(NSDate*)dateTime matchTime:(NSDate *)matchTime;    // added by Ying

-(void) ScheduleMatches;

- (void)checkScheduleDB;


- (BOOL)getIsMatchScheduled:(NSString *)matchId;
- (BOOL)getIsAlertScheduled:(NSString *)matchId dateTime:(NSDate *)dateTime;    // added by Ying
- (void)insertMatchForSchedule:(NSString *)matchId teamA:(NSString *)teamA teamB:(NSString *)teamB datetime:(NSDate*)datetime;

- (void)startSchedule:(NSString *)displayString MatchTime:(NSDate *) matchTime badgeNumber:(int)badge;

- (void)removeFromSchedule:(NSString *)matchId;
- (void)removeFromAlert:(NSString *)matchId matchTime:(NSDate *)matchTime;

- (void)removeFromSchedule;
- (void)removeFromScheduleOld;

- (NSInteger)getScheduleCount;

@end
