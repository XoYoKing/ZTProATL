//
//  LiveItem.h
//  AtlantasBravs
//
//  Created by Anton Gubarenko on 26.04.13.
//
//

#import <Foundation/Foundation.h>

@interface LiveItem : NSObject
@property (nonatomic, copy) NSString *liveTitle;
@property (nonatomic, copy) NSString *liveDesc;
@property (nonatomic, copy) NSString *livePubDate;
@property (nonatomic, copy) NSString *liveLink;
@property (nonatomic, copy) NSDate *liveDate;
@property (nonatomic) BOOL isMultiLine;
@end
