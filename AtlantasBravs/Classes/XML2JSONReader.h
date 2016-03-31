//
//  XML2JSONReader.h
//  AtlantasBravs
//
//  Created by Anton Gubarenko on 26.04.13.
//
//

#import <Foundation/Foundation.h>

@interface XML2JSONReader : NSObject<NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *)errorPointer;

@end
