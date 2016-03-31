//  Created by Zain Raza.
//  Copyright (c) 2012 __SoftwareWeaver__. All rights reserved.


#import "Tools.h"
/*
 * add extended information on a classical NSLog command
 */
void extendedLog(NSString* extendedInfo, NSString* format, ...)
{
    NSString* formattedMessage;
    
	va_list argumentList;
	va_start(argumentList, format);
	
	NSLogv([extendedInfo stringByAppendingString:format], argumentList);
	
    formattedMessage = [[NSString alloc] initWithFormat:[extendedInfo stringByAppendingString:format] arguments: argumentList];
    
	va_end(argumentList);
    
    //[[MyLogUploader sharedInstance] addLog:formattedMessage];
    
    
}
