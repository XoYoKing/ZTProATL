//
//  Util.h
//  Created by Zain Raza.
//  Copyright (c) 2012 __SoftwareWeaver__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject {
    
}

+ (NSString*) getDatabasePath;

+ (void) createDatabaseIfNeeded;

+ (BOOL) checkExistingOfDirectoryAtPath:(NSString*) path;

+ (BOOL) checkExistingOfFileAtPath:(NSString*) path;

+ (void) createDirectoryAtPath:(NSString*) path;

+ (void) closeDirectoryAtPath:(NSString*) path;

+ (void) closeFileAtPath:(NSString*) path;

+ (void) copyFileFromPath:(NSString*) fromFile to:(NSString*) toFile;

+ (void) removeOldDatabases;


+ (void)displayAlertWithMessage:(NSString *)msg andTitle:(NSString *)title tag:(NSInteger) tag;

+ (void)displayAlertWithMessage:(NSString *)msg tag:(NSInteger) tag;

+ (void)displayAlertWithMessage:(NSString *)msg delegateObj:(id) obj tag:(NSInteger) tag;

+ (void)displayConfirmWithMessage:(NSString *)msg delegateObj:(id) obj tag:(NSInteger) tag;

+ (NSString*) genProjectPhotoName;

+ (BOOL) checkCameraAvailable;

+ (BOOL) checkIsIPadVersion;

+ (BOOL) compareDate:(NSDate*) date1 isSmaller:(NSDate*) date2;

+ (BOOL) compareDate:(NSDate*) date1 isEqualTo:(NSDate*) date2;

+ (BOOL) checkStartDateAndEndDate:(NSDate*) date1 andEndDate:(NSDate*) date2;

+ (NSString *)timeinAMPMFormat:(NSString *)inputTime andInputFormat:(NSString *)tformat andOutputFormat:(NSString *)outFormat;

+ (BOOL)isIPad; 

+ (NSString*) trimString:(NSString*) string;

+ (BOOL) checkiOSGreaterOrEqual5_0;

+ (NSString*) standardizeLinkString :(NSString *)strInput;

+ (BOOL) checkString:(NSString*) str containSubString:(NSString*) subStr;

+ (NSString *)removeSpaces:(NSString *)textLines;

+ (NSString *)validatePhoneNumber:(NSString *)textLines;

+ (BOOL)isValidPhoneNumber:(NSString *)textLines;

+ (BOOL)emailAddressValidation:(NSString *)emailid;

+ (NSString *)encodeURL:(NSString *)url;
+ (BOOL)isStringValid:(NSString *)textToValidate stringToCheck:(NSString *)stringToCheck;

+ (NSString*) standardizeQuestionString:(NSString *)strInput;

+ (NSString *)trimContactLabel:(NSString *)labelstr;

+ (NSString*) imagesPath;

+ (int)fontSizeMenus;

+ (int)fontSizeFlashCards;

+ (int)heightForMenuCell;

+ (int)heightForYieldMenuCell;

+ (int)WidthForMenuCell;

+ (int)heightForTopBar;

+ (int)UIHeight;

+ (int)UIWidth;

+ (BOOL)isIphone5Display;

+ (UIImage *)captureView:(UIView *)view;

@end
