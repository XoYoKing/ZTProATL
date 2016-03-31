//
//  NewsItem.h
//  AtlantasBravs
//
//  Created by Zain Raza on 12/16/11.
//  Copyright (c) 2011 __Creative Gamers__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject


@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *newsDesc;
@property (nonatomic, copy) NSString *newsSource;
@property (nonatomic, copy) NSString *newsDate;
@property (nonatomic, copy) NSString *newsTime;
@property (nonatomic, copy) NSString *newsLink;
@property (nonatomic, copy) NSDate *newsDateTimeUTC;
@property (nonatomic, copy) NSDate *newsDateTimeLocal;

@end
