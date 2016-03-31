//
//  XMLReader.m
//  AtlantasBravs
//
//  Created by Zain Raza on 12/16/11.
//  Copyright (c) 2011 __Creative Gamers__. All rights reserved.
//

#import "XMLReader.h"

#import "Resources.h"
#import "Reachability.h"
#import "XML2JSONReader.h"
#import "SHXMLParser.h"
#import "AFNetworking.h"
#import "TeamItem.h"

@implementation NSMutableArray (Reverse)

- (void)reverse {
    if ([self count] == 0)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

@end

@implementation XMLReader

@synthesize delegate_;
@synthesize parsingTag;

-(void) parseXMLForNews:(id<XMLParserCompleteDelegate>)xdelegate {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if([reachability currentReachabilityStatus] == NotReachable){
        [Util displayAlertWithMessage:@"You are not connected to internet." tag:0];
        if(xdelegate!=nil)
            if ([xdelegate respondsToSelector:@selector(xmlParsingError:)]) {
                [xdelegate xmlParsingError:@"No Internet Connection"];
            }
        [[Resources sharedResources] hideNetworkIndicator];
        return;
    }
    
    self.delegate_ = xdelegate;
    
    parsingTag = 1;
    
    [[[Resources sharedResources] newsList] removeAllObjects];
    
    [[Resources sharedResources] showNetworkingActivity];
    NSMutableArray *mySoureArray = [[NSMutableArray alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mysource"] != nil) {
        mySoureArray = [NSMutableArray arrayWithArray:(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"mysource"]];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selRssList"] != nil) {
        NSMutableArray *selRssList = [NSMutableArray arrayWithArray:(NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:@"selRssList"]];
        [Resources sharedResources].selRssList = selRssList;
        NSMutableArray *deletedObjects = [[NSMutableArray alloc] init];
        for (NSDictionary *source in mySoureArray) {
            int i = 0;
            for (i = 0; i < selRssList.count; i++) {
                NSDictionary *curSource = [selRssList objectAtIndex:i];
                if ([[curSource objectForKey:@"sourcename"] isEqualToString:[source objectForKey:@"sourcename"]]) {
                    break;
                }
            }
            if (i == selRssList.count) {
                [deletedObjects addObject:source];
            }
        }
        if (deletedObjects.count > 0) {
            [mySoureArray removeObjectsInArray:deletedObjects];
        }
    }else {
        [mySoureArray removeAllObjects];
    }
    [self getNewsFromList:mySoureArray];
}

- (void)getNewsFromList:(NSArray *)selRssList
{
    NSMutableArray *mutableOperations = [NSMutableArray array];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.theprofessionalssports.com/server/getnews.php?teamid=%@", TeamID]]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [mutableOperations addObject:operation];
    for (int i = 0; i < selRssList.count; i++) {
        NSDictionary *source = [selRssList objectAtIndex:i];
        if ([source objectForKey:@"rsslink"] == nil || [[source objectForKey:@"rsslink"] isEqualToString:@""]) {
            continue;
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[source objectForKey:@"rsslink"]]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [mutableOperations addObject:operation];
    }
    
    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"%ld of %ld complete",(long)numberOfFinishedOperations, (long)totalNumberOfOperations);
    } completionBlock:^(NSArray *operations) {
        for (int i = 0; i < operations.count; i++) {
            AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)[operations objectAtIndex:i];
            if (operation.error) {
                continue;
            }
            NSData *xmlData = operation.responseData;
            if (i == 0) {
                [self insertNewsItemsFrom:xmlData];
            }else {
                [self insertNewsItemsFrom1:xmlData source:[[selRssList objectAtIndex:i - 1] objectForKey:@"sourcename"]];
            }
        }
        [self performSelectorOnMainThread:@selector(parseXMLForSchedule) withObject:nil waitUntilDone:YES];
        NSLog(@"All operations ins batch complete");
    }];
    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];
}

- (void)insertNewsItemsFrom1:(NSData*)data source:(NSString *)source
{
    SHXMLParser     *parser         = [[SHXMLParser alloc] init];
    NSDictionary    *newsDoc   = [[[parser parseData:data] objectForKey:@"rss"] objectForKey:@"channel"];
    NSLog(@"%@",newsDoc);
    [[Resources sharedResources] setXmlTotalNews:[[newsDoc objectForKey:@"item"] count]];
    
    for (NSDictionary *attributeDict in [newsDoc objectForKey:@"item"]) {
        NewsItem *myItem = [[NewsItem alloc] init];
        
        [myItem setNewsTitle:[attributeDict objectForKey:@"title"]];
        [myItem setNewsDesc:[attributeDict objectForKey:@"description"]];
        [myItem setNewsSource:source];
        [myItem setNewsLink:[attributeDict objectForKey:@"link"]];
        
        NSString *pubDateStr = [attributeDict objectForKey:@"pubDate"];
        if (pubDateStr != nil) {
            pubDateStr = [pubDateStr stringByReplacingOccurrencesOfString:@"\n\t" withString:@""];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss zzz"];
            NSDate *pubDate = [formatter dateFromString:pubDateStr];
            [formatter setDateFormat:@"MM/dd/yyyy"];
            [myItem setNewsDate:[formatter stringFromDate:pubDate]];
            [formatter setDateFormat:@"h:mm a"];
            [myItem setNewsTime:[formatter stringFromDate:pubDate]];
        
            NSString *dateString = [NSString stringWithFormat:@"%@ %@",myItem.newsDate,myItem.newsTime];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // this is imporant - we set our input date format to match our input string
            // if format doesn't match you'll get nil from your string, so be careful
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm a"];
            NSDate *dateFromString = [[NSDate alloc] init];
            // voila!
            dateFromString = [dateFormatter dateFromString:dateString];
            [myItem setNewsDateTimeUTC:[dateFromString copy]];
            NSTimeZone *currentZone = [NSTimeZone localTimeZone];
            dateFromString = [dateFromString dateByAddingTimeInterval:currentZone.secondsFromGMT];
            
            
            
            [myItem setNewsDateTimeLocal:dateFromString];
        }
        
        //NSLog(@"newsItem");
        
        //        [[[Resources sharedResources] newsList] addObject:myItem];    // removed by Ying
        /* added by Ying */
        BOOL isAvailable = NO;
        if ([[Resources sharedResources].selRssList count] > 0) {
            for (NSDictionary *dictionary in [Resources sharedResources].selRssList)    {
                if ([dictionary[@"sourcename"] isEqualToString:source]) {
                    isAvailable = YES;
                    break;
                }
            }
        }
        else    {
            isAvailable = YES;
        }
        if (isAvailable) {
            int j = 0;
            for (j = 0; j < [[Resources sharedResources] newsList].count; j++) {
                NewsItem *curItem = [[[Resources sharedResources] newsList] objectAtIndex:j];
                if ([curItem.newsDateTimeUTC compare:myItem.newsDateTimeUTC] == NSOrderedAscending) {
                    break;
                }
            }
            if ([[Resources sharedResources] newsList].count == 0 || j == [[Resources sharedResources] newsList].count) {
                [[[Resources sharedResources] newsList] addObject:myItem];
            }else {
                [[[Resources sharedResources] newsList] insertObject:myItem atIndex:j];
            }
        }
        /////////////////////////////////////////////////
        
        [myItem release];
    }
}


- (void)insertNewsItemsFrom:(NSData*)data
{
    SHXMLParser     *parser         = [[SHXMLParser alloc] init];
    NSDictionary    *newsDoc   = [[[parser parseData:data] objectForKey:@"doc"] objectForKey:@"news"];
    [[Resources sharedResources] setXmlTotalNews:[[newsDoc objectForKey:@"totalnews"] intValue]];
    
    for (NSDictionary *attributeDict in [newsDoc objectForKey:@"newsitem"]) {
        NewsItem *myItem = [[NewsItem alloc] init];
        
        [myItem setNewsTitle:[attributeDict objectForKey:@"title"]];
        [myItem setNewsDesc:[attributeDict objectForKey:@"description"]];
        [myItem setNewsSource:[attributeDict objectForKey:@"source"]];
        [myItem setNewsLink:[attributeDict objectForKey:@"link"]];
        [myItem setNewsDate:[attributeDict objectForKey:@"date"]];
        [myItem setNewsTime:[attributeDict objectForKey:@"time"]];
        
        NSString *dateString = [NSString stringWithFormat:@"%@ %@",[attributeDict objectForKey:@"date"],[attributeDict objectForKey:@"time"]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm a"];
        NSDate *dateFromString = [[NSDate alloc] init];
        // voila!
        dateFromString = [dateFormatter dateFromString:dateString];
        
        NSTimeZone *currentZone = [NSTimeZone localTimeZone];
        [myItem setNewsDateTimeUTC:[dateFromString copy]];
        
        dateFromString = [dateFromString dateByAddingTimeInterval:currentZone.secondsFromGMT];
        
        
        [myItem setNewsDateTimeLocal:dateFromString];
        
        //NSLog(@"newsItem");
        
//        [[[Resources sharedResources] newsList] addObject:myItem];    // removed by Ying
        /* added by Ying */
        BOOL isAvailable = NO;
        if ([[Resources sharedResources].selRssList count] > 0) {
            for (NSDictionary *dictionary in [Resources sharedResources].selRssList)    {
                if ([dictionary[@"sourcename"] isEqualToString:[attributeDict objectForKey:@"source"]]) {
                    isAvailable = YES;
                    break;
                }
            }
        }
        else    {
            isAvailable = YES;
        }
        if (isAvailable) {
            int j = 0;
            for (j = 0; j < [[Resources sharedResources] newsList].count; j++) {
                NewsItem *curItem = [[[Resources sharedResources] newsList] objectAtIndex:j];
                if ([curItem.newsDateTimeUTC compare:myItem.newsDateTimeUTC] == NSOrderedAscending) {
                    break;
                }
            }
            if ([[Resources sharedResources] newsList].count == 0 || j == [[Resources sharedResources] newsList].count) {
                [[[Resources sharedResources] newsList] addObject:myItem];
            }else {
                [[[Resources sharedResources] newsList] insertObject:myItem atIndex:j];
            }
        }
        /////////////////////////////////////////////////
        
        [myItem release];
    }
}

-(void) parseXMLForGeneralNews:(id<XMLParserCompleteDelegate>)xdelegate {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if([reachability currentReachabilityStatus] == NotReachable){
        [Util displayAlertWithMessage:@"You are not connected to internet." tag:0];
        if(xdelegate!=nil)
            if ([xdelegate respondsToSelector:@selector(xmlParsingError:)]) {
                [xdelegate xmlParsingError:@"No Internet Connection"];
            }
        [[Resources sharedResources] hideNetworkIndicator];
        return;
    }
    
    self.delegate_ = xdelegate;
    
    parsingTag = 1;
    
    [[[Resources sharedResources] newsList] removeAllObjects];
    
    [[Resources sharedResources] showNetworkingActivity];
    NSURL *newsURL = [NSURL URLWithString:@"http://63.142.251.208/server/getnewsmlb.php"];
    dispatch_async(kBgQueue, ^{
        NSString *xmlStr = [[[NSString alloc] initWithContentsOfURL:newsURL encoding:NSUTF8StringEncoding error:nil] autorelease];
        [self insertNewsItemsFrom:[xmlStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        [self performSelectorOnMainThread:@selector(parseXMLForSchedule) withObject:xmlStr waitUntilDone:YES];
    });
}

- (void)requestCompleted:(NSString *)dataStr
{
    NSLog(@"REQ len %lu",(unsigned long)dataStr.length);
    if(parsingTag==3)
    {
        @autoreleasepool {
            
            // Parse the XML into a dictionary
            NSError *parseError = nil;
            NSDictionary *xmlDictionary = [XML2JSONReader dictionaryForXMLString:dataStr error:parseError];
            if(parseError!=nil)
            {
                NSLog(@"%@",parseError.localizedDescription);
            }
            else
            {
                NSDictionary *rss = [xmlDictionary objectForKey:@"doc"];
                if(rss!=nil)
                {
                    NSDictionary *feed = [rss objectForKey:@"scores"];
                    if(feed!=nil)
                    {
                        
                        
                    }
                }
            }
        }
        [self performSelectorOnMainThread:@selector(startWithMainThread) withObject:nil waitUntilDone:NO];
        return;
    }
    
    @try {
        if (dataStr == NULL) {
            [Util displayAlertWithMessage:@"Please check your internet connectivity." andTitle:@"Error" tag:0];
            [[Resources sharedResources] hideNetworkIndicator];
        }
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
        [xmlParser setDelegate:self];
        [xmlParser setShouldProcessNamespaces:NO];
        [xmlParser setShouldReportNamespacePrefixes:NO];
        [xmlParser setShouldResolveExternalEntities:NO];
        [xmlParser parse];
        
        [xmlParser release];
        xmlParser = nil;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %@",exception);
        //[Util displayAlertWithMessage:@"You are not connected to internet." andTitle:@"Error" tag:0];
        if(delegate_!=nil)
            if ([delegate_ respondsToSelector:@selector(xmlParsingError:)]) {
                [delegate_ xmlParsingError:@"No Internet Connection"];
            }
        [[Resources sharedResources] hideNetworkIndicator];
    }
    @finally {
        
    }
}

-(void) parseXMLForSchedule {
    
    [[[Resources sharedResources] getScheduleNotifier] removeFromSchedule];
    
    parsingTag = 2;
    
    [[[Resources sharedResources] matchesList] removeAllObjects];
    
    NSURL *scURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://63.142.251.208/server/getschedule.php?teamid=%@", TeamID]];
    
    dispatch_async(kBgQueue, ^{
        NSString *xmlStr = [[[NSString alloc] initWithContentsOfURL:scURL encoding:NSUTF8StringEncoding error:nil] autorelease];
        [self insertScheduleItemsFrom:[xmlStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        [self performSelectorOnMainThread:@selector(startWithMainThread) withObject:xmlStr waitUntilDone:YES];
    });
}

- (void)insertScheduleItemsFrom:(NSData*)data
{
    NSMutableArray *selAlerts = [NSMutableArray array];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"selAlerts"]) {
        selAlerts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"selAlerts"]];
    }
    
    SHXMLParser     *parser         = [[SHXMLParser alloc] init];
    NSDictionary    *newsDoc   = [[[parser parseData:data] objectForKey:@"doc"] objectForKey:@"schedule"];
    [[Resources sharedResources] setXmlTotalNews:[[newsDoc objectForKey:@"numberofmatches"] intValue]];
    int index = 0;
    for (NSDictionary *attributeDict in [newsDoc objectForKey:@"match"])
    {
        ScheduleItem *myItem = [[ScheduleItem alloc] init];
        
        [myItem setMatchId:[attributeDict objectForKey:@"matchid"]];
        [myItem setTeamAname:[attributeDict objectForKey:@"teamAname"]];
        [myItem setTeamAshortname:[attributeDict objectForKey:@"teamAshortname"]];
        [myItem setTeamBname:[attributeDict objectForKey:@"teamBname"]];
        [myItem setTeamBshortname:[attributeDict objectForKey:@"teamBshortname"]];
        [myItem setHometeam:[attributeDict objectForKey:@"hometeam"]];
        [myItem setLocalTV:[attributeDict objectForKey:@"local_tv"]];
        [myItem setLocalRadio:[attributeDict objectForKey:@"local_radio"]];
        [myItem setProbableStarters:[attributeDict objectForKey:@"probable_starters"]];
        [myItem setScore1:[[attributeDict objectForKey:@"score1"] intValue]];
        [myItem setScore2:[[attributeDict objectForKey:@"score2"] intValue]];
        [myItem setStatus:[[attributeDict objectForKey:@"status"] intValue]];
        
        NSString *dateString = [NSString stringWithFormat:@"%@ %@",[attributeDict objectForKey:@"date"],[attributeDict objectForKey:@"time"]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm a"];
        NSDate *dateFromString = [[NSDate alloc] init];
        
        dateFromString = [dateFormatter dateFromString:dateString];
        [myItem setMatchDateTimeUTC:dateFromString];
        NSTimeZone *currentZone = [NSTimeZone localTimeZone];
        dateFromString = [dateFromString dateByAddingTimeInterval:currentZone.secondsFromGMT];
        
        [myItem setMatchDateTimeLocal:dateFromString];
        [[[Resources sharedResources] matchesList] addObject:myItem];
        if (myItem.status == 0 && index < 15) {
            for (int j = 0; j < selAlerts.count; j++) {
                NSDictionary *selAlert = [selAlerts objectAtIndex:j];
                int minute = [[selAlert objectForKey:@"minute"] intValue];
                NSDate *alertTime = [myItem.matchDateTimeLocal dateByAddingTimeInterval:-60 * minute];
                [[[Resources sharedResources] schedNotifier] scheduleAlert:myItem.matchId teamA:myItem.teamAname teamB:myItem.teamBname dateTime:alertTime matchTime:myItem.matchDateTimeLocal];
            }
            index++;
        }
        [myItem release];
        
    }
}

-(void) parseXMLForLiveFeed:(id<XMLParserCompleteDelegate>)xdelegate {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if([reachability currentReachabilityStatus] == NotReachable){
        [Util displayAlertWithMessage:@"You are not connected to internet." tag:0];
        if(delegate_!=nil)
            if ([delegate_ respondsToSelector:@selector(xmlParsingError:)]) {
                [delegate_ xmlParsingError:@"No Internet Connection"];
            }
        [[Resources sharedResources] hideNetworkIndicator];
        return;
    }
    
    self.delegate_ = xdelegate;
    
    parsingTag = 3;
    
    [[[Resources sharedResources] liveList] removeAllObjects];
    
    [[Resources sharedResources] showNetworkingActivity];
    NSURL *newsURL = [NSURL URLWithString:@"http://63.142.251.208/server/getscores.php"];
    dispatch_async(kBgQueue, ^{
        NSString *xmlStr = [[[NSString alloc] initWithContentsOfURL:newsURL encoding:NSUTF8StringEncoding error:nil] autorelease];
        [self insertLiveFeedItemsFrom:[xmlStr dataUsingEncoding:NSUTF8StringEncoding]];
       
        [self performSelectorOnMainThread:@selector(startWithMainThread) withObject:xmlStr waitUntilDone:YES];
    });
}

- (void)insertLiveFeedItemsFrom:(NSData*)data
{
    SHXMLParser     *parser         = [[SHXMLParser alloc] init];
    NSDictionary    *newsDoc   = [[[parser parseData:data] objectForKey:@"doc"] objectForKey:@"scores"];
    
    if([[newsDoc objectForKey:@"score"] isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *item in [newsDoc objectForKey:@"score"])
        {
            LiveItem *newItem = [[LiveItem alloc] init];
            newItem.liveTitle = [item objectForKey:@"title"];
            newItem.liveLink = [item objectForKey:@"link"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // this is imporant - we set our input date format to match our input string
            // if format doesn't match you'll get nil from your string, so be careful
            [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm:ss a"];
            NSDate *dateFromString = [[NSDate alloc] init];
            // voila!
            dateFromString = [dateFormatter dateFromString:newItem.livePubDate ];
            
            NSTimeZone *currentZone = [NSTimeZone localTimeZone];
            dateFromString = [dateFromString dateByAddingTimeInterval:currentZone.secondsFromGMT];
            newItem.liveDate = dateFromString;
            
            NSRange range = [newItem.liveTitle rangeOfString:@"  "];
            newItem.isMultiLine = range.location!=NSNotFound?YES:NO;
            
            if(item)
                [[[Resources sharedResources] liveList] addObject:newItem];
        }
    }
    else
    {
        NSDictionary *item = [newsDoc objectForKey:@"score"];
        LiveItem *newItem = [[LiveItem alloc] init];
        newItem.liveTitle = [item objectForKey:@"title"];
        newItem.liveLink = [item objectForKey:@"link"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setDateFormat:@"MM/dd/yyyy h:mm:ss a"];
        NSDate *dateFromString = [[NSDate alloc] init];
        // voila!
        dateFromString = [dateFormatter dateFromString:newItem.livePubDate ];
        
        NSTimeZone *currentZone = [NSTimeZone localTimeZone];
        dateFromString = [dateFromString dateByAddingTimeInterval:currentZone.secondsFromGMT];
        newItem.liveDate = dateFromString;
        
        NSRange range = [newItem.liveTitle rangeOfString:@"  "];
        newItem.isMultiLine = range.location!=NSNotFound?YES:NO;
        
        if(item)
            [[[Resources sharedResources] liveList] addObject:newItem];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    switch (parsingTag) {
        case 1:
        {
            //NSLog(@"parserDidEndDocument: 1");
            
            [self parseXMLForSchedule];
            break;
        }
        case 2:
        {
            //NSLog(@"parserDidEndDocument: 2");
            //[self parseXMLForLiveFeed:self.delegate_];
            //Sorting News
            
            [[Resources sharedResources].newsList sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NewsItem *item1 = (NewsItem*)obj1;
                NewsItem *item2 = (NewsItem*)obj2;
                return [item1.newsDateTimeUTC compare:item2.newsDateTimeUTC];
            }];
            [[Resources sharedResources].newsList reverse];
            break;
        }
        case 3:
        {
            [[Resources sharedResources] hideNetworkIndicator];
            break;
        }
        case 4:
        {
            [[Resources sharedResources] hideNetworkIndicator];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)startWithMainThread
{
    [[Resources sharedResources] hideNetworkIndicator];
    if (delegate_ && [self.delegate_ respondsToSelector:@selector(xmlParsingComplete)]) {
        [delegate_ xmlParsingComplete];
    }
    
}

-(void)getTeams:(void (^)(void))completionHandler {
    
    [[[Resources sharedResources] teamList] removeAllObjects];
    if ([[Resources sharedResources] teamList] == nil) {
        [Resources sharedResources].teamList = [NSMutableArray array];
    }
    NSURL *newsURL = [NSURL URLWithString:@"http://63.142.251.208/server/getteamnames.php"];
    dispatch_async(kBgQueue, ^{
        NSString *xmlStr = [[[NSString alloc] initWithContentsOfURL:newsURL encoding:NSUTF8StringEncoding error:nil] autorelease];
        [self insertTeamItemsFrom:[xmlStr dataUsingEncoding:NSUTF8StringEncoding]];
        completionHandler();
    });
}

- (void)insertTeamItemsFrom:(NSData*)data
{
    SHXMLParser     *parser         = [[SHXMLParser alloc] init];
    NSDictionary    *teamsDoc   = [[[parser parseData:data] objectForKey:@"doc"] objectForKey:@"teams"];
    //[[Resources sharedResources] setXmlTotalNews:[[newsDoc objectForKey:@"total"] intValue]];
    for (NSDictionary *attributeDict in [teamsDoc objectForKey:@"team"]) {
        TeamItem *myItem = [[TeamItem alloc] init];
        
        [myItem setTeamID:[attributeDict objectForKey:@"teamid"]];
        [myItem setTeamName:[attributeDict objectForKey:@"teamname"]];
        [myItem setShortName:[attributeDict objectForKey:@"shortname"]];
        
        [[[Resources sharedResources] teamList] addObject:myItem];
        /////////////////////////////////////////////////
    }
}


@end