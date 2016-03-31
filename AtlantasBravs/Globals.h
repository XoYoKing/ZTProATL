#import <Foundation/Foundation.h>


//Class used for shared variables and settings.
@interface Globals : NSObject <NSCoding>

@property (nonatomic,retain) NSURL *lastFBLink;

@property (nonatomic,retain) NSURL *lastTWLink;

+ (Globals*)sharedGlobals;

//Saving to fileName.data
- (void)loadSettings;

//Loading data from fileName.data
- (void)saveSettings;

@end
