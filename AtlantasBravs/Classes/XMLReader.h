//
//  XMLReader.h
//  AtlantasBravs
//
//  Created by Zain Raza on 12/16/11.
//  Copyright (c) 2011 __Creative Gamers__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMLParserCompleteDelegate <NSObject>

- (void)xmlParsingComplete;
@optional
- (void)xmlParsingError:(NSString*)errorMsg;
@end

@interface XMLReader : NSObject <NSXMLParserDelegate>
@property (nonatomic, assign) id<XMLParserCompleteDelegate> delegate_;

@property (nonatomic) int parsingTag;

-(void) parseXMLForNews:(id<XMLParserCompleteDelegate>)xdelegate;
-(void) parseXMLForGeneralNews:(id<XMLParserCompleteDelegate>)xdelegate;
-(void) parseXMLForSchedule;
-(void) parseXMLForLiveFeed:(id<XMLParserCompleteDelegate>)xdelegate;

- (void)startWithMainThread;
- (void)insertNewsItemsFrom:(NSData*)data;

-(void)getTeams:(void (^)(void))completionHandler;

@end
