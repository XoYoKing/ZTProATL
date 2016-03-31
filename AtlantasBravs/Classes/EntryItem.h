//
//  EntryItem.h
//  AtlantasBravs
//
//  Created by Anton Gubarenko on 29.04.13.
//
//

#import <Foundation/Foundation.h>

@interface EntryItem : NSObject
@property (nonatomic, copy) NSDate *entryPublished;
@property (nonatomic, copy) NSDate *entryUpdated;
@property (nonatomic, copy) NSString *entryTitle;
@property (nonatomic, copy) NSString *entryContent;
@property (nonatomic, copy) NSString *entryLink;
@property (nonatomic, copy) NSString *entryAuthor;
@property (nonatomic, copy) NSString *entryID;
@end
