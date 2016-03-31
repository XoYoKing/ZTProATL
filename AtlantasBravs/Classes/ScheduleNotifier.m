//
//  ScheduleNotifier.m
//  AtlantasBravs
//
//  Created by MacBook on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScheduleNotifier.h"

#import "ScheduleItem.h"

@implementation ScheduleNotifier

@synthesize documentPaths;
@synthesize documentDir;
@synthesize dataBasePath;
@synthesize dataBaseName;

@synthesize dbSchedule;

- (BOOL)schedule:(NSString *)matchId teamA:(NSString *)teamA teamB:(NSString *)teamB datetime:(NSDate*)datetime
{    
    /*NSString *dateString = [NSString stringWithFormat:@"%@ %@",date,time];
    //dateString = @"08/06/2012 02:36 PM";
    NSLog(@"dateString:  %@",dateString);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm a"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];*/
    
    NSTimeInterval difference = [datetime timeIntervalSinceNow];
    if (difference < 0) {
        return FALSE;
    }
    BOOL isScheduled;
    
    isScheduled = [self getIsMatchScheduled:matchId];
    if(isScheduled == FALSE)
    {
        [self insertMatchForSchedule:matchId teamA:teamA teamB:teamB datetime:datetime];
        
        NSString *string = [NSString stringWithFormat:@"Today's game has started between %@ and %@",teamA,teamB];
        [self startSchedule:string MatchTime:datetime badgeNumber:[matchId intValue]];
    }
    return isScheduled;
}

- (void)removeFromSchedule {
    [self checkScheduleDB];
    //setup the database Object
    
    //Open DB:
    FMDatabase* db = [FMDatabase databaseWithPath:dataBasePath];
    if (![db open]) {
        NSLog(@"Error: Could not open db.");
    }
    
    //Execure Insert/Update Statement:
    [db beginTransaction];
    [db executeUpdate:@"Delete from Schedule"];
    [db commit];
    
    if ([db hadError]) {
        
    }
    
    [db close];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)removeFromAlert:(NSString *)matchId matchTime:(NSDate *)matchTime {
    [self checkScheduleDB];
    //setup the database Object
    
    //Open DB:
    FMDatabase* db = [FMDatabase databaseWithPath:dataBasePath];
    if (![db open]) {
        NSLog(@"Error: Could not open db.");
    }
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Schedule WHERE MatchId='%@' AND MatchDateTime = '%f'",matchId, [matchTime timeIntervalSince1970]];
    FMResultSet *rs = [db executeQuery:query];
    NSString *alertBody = @"";
    while ([rs next]) {
        NSString *teamA = [rs stringForColumn:@"TeamA"];
        NSString *teamB = [rs stringForColumn:@"TeamB"];
        alertBody = [NSString stringWithFormat:@"Today's game will start between %@ and %@",teamA,teamB];
    }
    [db close];
    
    //Execure Insert/Update Statement:
    [db beginTransaction];
    [db executeUpdate:[NSString stringWithFormat:@"Delete from Schedule WHERE MatchId='%@' AND MatchDateTime = '%f'",matchId,[matchTime timeIntervalSince1970]]];
    [db commit];
    
    if ([db hadError]) {
        
    }
    
    [db close];
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    int i = 0;
    for (i = 0; i < notifications.count; i++) {
        UILocalNotification *notification = (UILocalNotification *)[notifications objectAtIndex:i];
        NSDictionary *userInfo = notification.userInfo;
        if ([notification.fireDate isEqualToDate:matchTime] && [[userInfo objectForKey:@"MatchId"] isEqualToString:matchId]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            break;
        }
    }
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)removeFromSchedule:(NSString *)matchId
{
    if ([matchId isEqualToString:@"-1"]) {
        return;
    }
    
    [self checkScheduleDB];
    //setup the database Object
    
    //Open DB:
    FMDatabase* db = [FMDatabase databaseWithPath:dataBasePath];
    if (![db open]) {
        NSLog(@"Error: Could not open db.");
    }
    
    //Execure Insert/Update Statement:
    [db beginTransaction];
    [db executeUpdate:@"Delete from Schedule WHERE MatchId <= ? and MatchId <> -1",matchId];
    [db commit];
    
    if ([db hadError]) {
        
    }
    
    [db close];
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self ScheduleMatches];
}

- (void)removeFromScheduleOld
{
    [self checkScheduleDB];
    //setup the database Object
    
    //Open DB:
    FMDatabase* db = [FMDatabase databaseWithPath:dataBasePath];
    if (![db open]) {
        NSLog(@"Error: Could not open db.");
    }
    
    //Execure Insert/Update Statement:
    [db beginTransaction];
    [db executeUpdate:@"Delete from Schedule WHERE MatchDateTime <= NOW() "];
    [db commit];
    
    if ([db hadError]) {
        
    }
    
    [db close];
    
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //[self ScheduleMatches];
}

- (NSInteger)getScheduleCount
{
    [self checkScheduleDB];
    
	NSUInteger rows = 0;
	
	FMDatabase* db = [FMDatabase databaseWithPath:dataBasePath];
    if([db open])
    {return 0;}
    
	rows = [db intForQuery:@"SELECT COUNT(*) FROM Schedule"];
    
	[db close];
    
	return rows;
}

-(void) checkScheduleDB
{
    
    /*
     CREATE TABLE Schedule (ScheduleId integer NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,MatchId text, TeamA text,TeamB text,MatchDate text,MatchTime text)
     */
    
	// get the path to the documents directory and append the database name
	documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	documentDir = [documentPaths objectAtIndex:0];
	dataBaseName  = @"bbschedudledb.sqlite";
	dataBasePath = [documentDir stringByAppendingPathComponent:dataBaseName];
	BOOL success;
	NSFileManager *fileManager = [[NSFileManager alloc] init];
    
	success = [fileManager fileExistsAtPath:dataBasePath];
	if(success) {
        fileManager = nil;
        return;
    }
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dataBaseName];
	[fileManager copyItemAtPath:databasePathFromApp toPath:dataBasePath error:nil];
    fileManager = nil;
}

-(void) ScheduleMatches {
    
    [self checkScheduleDB];
    
	FMDatabase* db = [FMDatabase databaseWithPath:dataBasePath];
    if([db open])
    {}
	
    NSMutableArray *listMatches = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Schedule"];
	FMResultSet *rs = [db executeQuery:query];
    while ([rs next]) {
		
        ScheduleItem *item = [[ScheduleItem alloc] init];
        
        [item setMatchId:[rs stringForColumn:@"MatchId"]];
        [item setTeamAshortname:[rs stringForColumn:@"TeamA"]];
        [item setTeamBshortname:[rs stringForColumn:@"TeamB"]];
        [item setMatchDateTimeUTC:[NSDate dateWithTimeIntervalSince1970:[rs doubleForColumn:@"MatchDateTime"]]];
        [item setMatchDateTimeLocal:[NSDate dateWithTimeIntervalSince1970:[rs doubleForColumn:@"MatchDateTime"]]];
        
        //[item setMatchDate:[rs stringForColumn:@"MatchDate"]];
        //[item setMatchTime:[rs stringForColumn:@"MatchTime"]];
        
        [listMatches addObject:item];
        
        item = nil;
        
    }
    
	[db close];
    
    
    for (ScheduleItem *item in listMatches) {
        
        //NSString *dateString = [NSString stringWithFormat:@"%@ %@",[item matchDate],[item matchTime]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm a"];
        //NSDate *dateFromString = [[NSDate alloc] init];
        // voila!
        //dateFromString = [dateFormatter dateFromString:dateString];
        
        //NSTimeInterval difference = [item.matchDateTimeUTC timeIntervalSinceNow];
        
        
        NSString *string = [NSString stringWithFormat:@"Today's game has started between %@ and %@",[item teamAshortname],[item teamBshortname]];
        [self startSchedule:string MatchTime:item.matchDateTimeUTC badgeNumber:[[item matchId] intValue]];
    }
    
    
}

- (BOOL)getIsMatchScheduled:(NSString *)matchId {
    
    [self checkScheduleDB];
    
	BOOL isScheduled = FALSE;
    
	FMDatabase* db = [FMDatabase databaseWithPath:dataBasePath];
    if([db open])
    {}
	
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Schedule WHERE MatchId='%@'",matchId];
	FMResultSet *rs = [db executeQuery:query];
    while ([rs next]) {
		isScheduled = TRUE;
    }
	[db close];
    
    return isScheduled;
    
}

- (void)insertMatchForSchedule:(NSString *)matchId teamA:(NSString *)teamA teamB:(NSString *)teamB datetime:(NSDate*)datetime {
    
    [self checkScheduleDB];	
    //setup the database Object
    
    int counter = [self getScheduleCount];
    if (counter >= 64) {
        return;
    }
    
    //Open DB:
    FMDatabase* db = [FMDatabase databaseWithPath:dataBasePath];
    if (![db open]) {
        NSLog(@"Error: Could not open db.");
    }
    
    //Execure Insert/Update Statement:
    [db beginTransaction];
    bool res = [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO Schedule (MatchId,TeamA,TeamB, MatchDateTime) VALUES(%@,\'%@\',\'%@\',%f)" ,
     matchId,
     teamA,
     teamB,[datetime timeIntervalSince1970]]];
    NSLog(@"Insert res: %@",res==YES?@"YES":@"NO");
    [db commit];
    if ([db hadError]) {
        NSLog(@"insert error");
    }
    [db close];
}

- (void)startSchedule:(NSString *)displayString MatchTime:(NSDate *)matchTime badgeNumber:(int)badge {
    
    //NSDate *now = [NSDate dateWithTimeIntervalSinceNow:(matchTime)];
    //NSDate *scheduled = now ;
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    if (localNotif == nil)
        return;
    localNotif.fireDate = matchTime;
    localNotif.timeZone = [NSTimeZone localTimeZone];
    NSLog(@"%d fireDate:  %@",badge, localNotif.fireDate);
    
    localNotif.alertBody = displayString;
    localNotif.alertAction = NSLocalizedString(@"More", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 0;    
    [localNotif setRepeatInterval:0];
    
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",badge] forKey:@"MatchId"];
    localNotif.userInfo = infoDict;
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    int i = 0;
    for (i = 0; i < notifications.count; i++) {
        UILocalNotification *notification = (UILocalNotification *)[notifications objectAtIndex:i];
        NSDictionary *userInfo = notification.userInfo;
        if ([notification.fireDate isEqualToDate:localNotif.fireDate] && [[userInfo objectForKey:@"MatchId"] isEqualToString:[NSString stringWithFormat:@"%d",badge]]) {
            break;
        }
    }
    if (i == notifications.count) {
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    }
}

// added by Ying
- (BOOL)getIsAlertScheduled:(NSString *)matchId dateTime:(NSDate *)dateTime     {
    [self checkScheduleDB];
    
    BOOL isScheduled = FALSE;
    
    FMDatabase* db = [FMDatabase databaseWithPath:dataBasePath];
    if([db open])
    {}
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Schedule WHERE MatchId='%@' AND MatchDateTime = '%f'",matchId, [dateTime timeIntervalSince1970]];
    FMResultSet *rs = [db executeQuery:query];
    while ([rs next]) {
        isScheduled = TRUE;
    }
    [db close];
    
    return isScheduled;
}

- (BOOL)scheduleAlert:(NSString *)matchId teamA:(NSString *)teamA teamB:(NSString *)teamB dateTime:(NSDate *)dateTime matchTime:(NSDate *)matchTime  {
    NSTimeInterval difference = [dateTime timeIntervalSinceNow];
    
    if (difference < 0) {
        return FALSE;
    }
    
    BOOL isScheduled;
    
    isScheduled = [self getIsAlertScheduled:matchId dateTime:dateTime];
    
    if(isScheduled == FALSE)
    {
        [self insertMatchForSchedule:matchId teamA:teamA teamB:teamB datetime:dateTime];
        NSString *string = @"";
        if ([dateTime isEqualToDate:matchTime]) {
            string = [NSString stringWithFormat:@"Today's game has started between %@ and %@",teamA,teamB];
        }else {
            NSTimeInterval diff = [matchTime timeIntervalSinceDate:dateTime];
            if (diff < 0) {
                return NO;
            }
            int hour = (int)(diff / 3600);
            int minute = (int)(diff / 60) % 60;
            if (hour == 1) {
                string = [NSString stringWithFormat:@"%@1 hour",string];
            }else if (hour > 1) {
                string = [NSString stringWithFormat:@"%@%d hours",string, hour];
            }
            if (minute == 1) {
                if (![string isEqualToString:@""]) {
                    string = [NSString stringWithFormat:@"%@ ",string];
                }
                string = [NSString stringWithFormat:@"%@1 minute",string];
            }else if (minute > 1) {
                if (![string isEqualToString:@""]) {
                    string = [NSString stringWithFormat:@"%@ ",string];
                }
                string = [NSString stringWithFormat:@"%@%d minutes",string,minute];
            }
            string = [NSString stringWithFormat:@"Today's game between %@ and %@ will start in %@",teamA,teamB,string];
        }
        [self startSchedule:string MatchTime:dateTime badgeNumber:[matchId intValue]];
    }
    
    return isScheduled;
}
/////////////////

@end



