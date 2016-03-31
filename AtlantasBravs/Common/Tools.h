//  Created by Zain Raza.
//  Copyright (c) 2012 __SoftwareWeaver__. All rights reserved.

#import <Foundation/Foundation.h>

/*
 * add extended information on a classical NSLog command
 */
void extendedLog(NSString* extendedInfo, NSString* format, ...);


/*
 * defines custom release functions
 */
#ifndef SAFE_RELEASE
#define SAFE_RELEASE(p) if( p != nil ){ [p release]; p = nil; }
#endif

#ifndef SAFE_ENDTIMER
#define SAFE_ENDTIMER(p) if( p != nil ){ [p invalidate]; p = nil; }
#endif

#ifndef SAFE_DELETE
#define SAFE_DELETE(p) {if( p != NULL ){ delete p; p = NULL; }}
#endif

#ifndef SAFE_DELETE_ARRAY
#define SAFE_DELETE_ARRAY(p) {if( p != NULL ){ delete [] p; p = NULL; }}
#endif

#ifndef SAFE_FREE
#define SAFE_FREE(p) {if( p != NULL ){ free(p); p = NULL; }}
#endif

#define DEBUG 1

/*
 * defines a custom log tool in order to provide detailed log content with callee class name & file line number
 */
#ifdef DEBUG

#define DEBUGLog(...) extendedLog( [NSString stringWithFormat:@"%@ (Line %d): ", NSStringFromClass([self class]), __LINE__], __VA_ARGS__ )
#define DEBUGLogBegin(x) extendedLog( [NSString stringWithFormat:@"%@ BEGIN - ", NSStringFromClass([self class])], @#x ) 
#define DEBUGLogEnd(x) extendedLog( [NSString stringWithFormat:@"%@ END - ", NSStringFromClass([self class])], @#x )

#else

#define DEBUGLog(...)
#define DEBUGLogBegin(x) 
#define DEBUGLogEnd(x) 

#endif


/*
 * defines path strings
 */
#define strDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define strResourcePath [[NSBundle mainBundle] resourcePath]

