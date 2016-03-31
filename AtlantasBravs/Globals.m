#import "Globals.h"

static Globals* _sharedGlobals;

@implementation Globals

@synthesize lastFBLink,lastTWLink;

#pragma mark NSCoding

#define kBookToken        @"BookmarksToken"
#define fileName         @"BookmarksManager.data"

+ (Globals*)sharedGlobals {
	@synchronized(self) {
		if(_sharedGlobals == nil) {
			_sharedGlobals = [[super allocWithZone:NULL] init];
            _sharedGlobals.lastFBLink = [NSURL URLWithString:@"http://www.facebook.com"];
            _sharedGlobals.lastTWLink = [NSURL URLWithString:@"http://www.twitter.com/ZTProf"];
        }       
    }
    return _sharedGlobals;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    //[encoder encodeObject:bookmarks forKey:kBookToken];
}

- (id)initWithCoder:(NSCoder *)decoder {
    //bookmarks = [decoder decodeObjectForKey:kBookToken];
    return self;
}

-(void)loadSettings
{
    //----- READ CLASS FROM FILE -----
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *myFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    NSData *settingsData = [[NSMutableData alloc] initWithContentsOfFile:myFilePath];
    
    if (settingsData)
    {
        //----- EXISTING DATA EXISTS -----
        NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:settingsData];
        //_sharedGlobals.bookmarks = [decoder decodeObjectForKey:kBookToken];
       
        [decoder finishDecoding];
    }
    else
    {
        //----- NO DATA EXISTS -----
    }
}

-(void)saveSettings
{
	NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
	NSString *myFilePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
	NSMutableData *settingsData = [NSMutableData data];
	NSKeyedArchiver *encoder =  [[NSKeyedArchiver alloc] initForWritingWithMutableData:settingsData];
    
	//Archive each instance variable/object using its name
    //[encoder encodeObject:bookmarks forKey:kBookToken];
    
	[encoder finishEncoding];
	[settingsData writeToFile:myFilePath atomically:YES];
}


@end
