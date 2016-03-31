//
//  fmdbQueries.m
//  Persistence
//
//  Created by zain raza on 28/04/11.
//  Copyright 2011 TCM. All rights reserved.
//



//@implementation fmdbQueries

/*
 //Open DB:
 FMDatabase* db = [FMDatabase databaseWithPath:[self dbFilePath]];
 if (![db open]) {
 NSLog(@"Error: Could not open db.");
 }
 else if([db open])
 NSLog(@"Database Opened successfully: %@.",[self dbFilePath]);
 //CREATE TABLE:
 [db executeUpdate:@"CREATE TABLE IF NOT EXISTS NAMES (ROW INTEGER PRIMARY KEY, FIRSTNAME text, LASTNAME text)"];
 if ([db hadError]) {
 NSLog(@"Error: %d: %@", [db lastErrorCode], [db lastErrorMessage]);
 }
 
 
 //Execute Delete Statement:
 
 int i = 0;
 while (i++ < 20) {
 [db executeUpdate:@"DELETE FROM NAMES WHERE ROW = ?",[NSNumber numberWithInt:i]];
 }
 
 if ([db hadError]) {
 NSLog(@"Error: %d: %@", [db lastErrorCode], [db lastErrorMessage]);
 }
 
 //Execure Insert/Update Statement:
 [db beginTransaction];
 i = 0;
 while (i++ < 20) {
 [db executeUpdate:@"INSERT INTO NAMES (ROW,FIRSTNAME,LASTNAME) values (?, ?, ?)" ,
 [NSNumber numberWithInt:i],
 [NSString stringWithFormat:@"Zain"],
 [NSString stringWithFormat:@"Raza %d",i]];
 }
 [db commit];
 if ([db hadError]) {
 NSLog(@"Error: %d: %@", [db lastErrorCode], [db lastErrorMessage]);
 }
 
 //UPDATE QUERY:
 int j=15;
 [db beginTransaction];
 [db executeUpdate:@"UPDATE NAMES SET FIRSTNAME = ?, LASTNAME = ? WHERE ROW=?" ,
 [NSString stringWithFormat:@"Tricast"],
 [NSString stringWithFormat:@"Media",i],
 [NSNumber numberWithInt:j]];
 [db commit];
 //Execute Select statement:
 FMResultSet *rs = [db executeQuery:@"SELECT * FROM NAMES"];
 if ([db hadError]) {
 NSLog(@"Error: %d: %@", [db lastErrorCode], [db lastErrorMessage]);
 }
 
 while ([rs next]) {
 // just print out what we've got in a number of formats.
 NSLog(@"%d %@ %@",
 [rs intForColumn:@"ROW"],
 [rs stringForColumn:@"FIRSTNAME"],
 [rs stringForColumn:@"LASTNAME"]);
 
 
 if (!([[rs columnNameForIndex:0] isEqualToString:@"ROW"] &&
 [[rs columnNameForIndex:1] isEqualToString:@"FIRSTNAME"])
 ) {
 NSLog(@"WHOA THERE BUDDY, columnNameForIndex ISN'T WORKING!");
 }
 }
 // close the result set.
 // it'll also close when it's dealloc'd, but we're closing the database before
 // the autorelease pool closes, so sqlite will complain about it.
 [rs close];
 
 //--in text fields:
 //Execute Select statement:
 FMResultSet *rs1 = [db executeQuery:@"SELECT * FROM NAMES WHERE ROW=15"];
 if ([db hadError]) {
 NSLog(@"Error: %d: %@", [db lastErrorCode], [db lastErrorMessage]);
 }
 
 while ([rs1 next]) {
 // just print out what we've got in a number of formats.
 NSLog(@"%d %@ %@",
 [rs1 intForColumn:@"ROW"],
 [rs1 stringForColumn:@"FIRSTNAME"],
 [rs1 stringForColumn:@"LASTNAME"]);
 
 firstName.text = [rs1 stringForColumn:@"FIRSTNAME"];
 lastName.text = [rs1 stringForColumn:@"LASTNAME"];
 }
 // close the result set.
 // it'll also close when it's dealloc'd, but we're closing the database before
 // the autorelease pool closes, so sqlite will complain about it.
 [rs1 close];
 
 [db close];
 
 
 */

//@end
