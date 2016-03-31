//
//  Util.m
//  Created by Zain Raza.
//  Copyright (c) 2012 __SoftwareWeaver__. All rights reserved.

#import "Util.h"
#import <QuartzCore/QuartzCore.h>

@implementation Util

+ (NSString*) getDatabasePath{
	return [NSString stringWithFormat:@"%@/%@", strDocumentPath, DATABASE_NAME];
}

+ (void) createDatabaseIfNeeded {
	NSString* filePath = [NSString stringWithFormat:@"%@/%@", strDocumentPath, DATABASE_NAME];
	if (![Util checkExistingOfFileAtPath:filePath]) {
		//copy database
		NSString* sourcePath = [NSString stringWithFormat:@"%@/%@", strResourcePath, DATABASE_NAME];
		[Util copyFileFromPath:sourcePath to:filePath];
        DEBUGLog(@"copyFileFromPath");
	}
}

+ (BOOL) checkExistingOfDirectoryAtPath:(NSString*) path{
	NSFileManager* NSFm=[NSFileManager defaultManager];
	BOOL isDir = YES;
	if([NSFm fileExistsAtPath:path isDirectory:&isDir]){
		return YES;
	}
	return NO;
}

+ (BOOL) checkExistingOfFileAtPath:(NSString*) path{
	NSFileManager* NSFm=[NSFileManager defaultManager];
	BOOL isDir = NO;
	if([NSFm fileExistsAtPath:path isDirectory:&isDir]){
		return YES;
	}
	return NO;	
}

+ (void) createDirectoryAtPath:(NSString*) path{
	NSFileManager* NSFm=[NSFileManager defaultManager];
	BOOL isDir = YES;
	if([NSFm fileExistsAtPath:path isDirectory:&isDir]){
		[NSFm removeItemAtPath:path error:nil];
	}
	[NSFm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];			
}

+ (void) closeDirectoryAtPath:(NSString*) path{
	NSFileManager* NSFm=[NSFileManager defaultManager];
	BOOL isDir = YES;
	if([NSFm fileExistsAtPath:path isDirectory:&isDir]){
		[NSFm removeItemAtPath:path error:nil];
	}
}

+ (void) closeFileAtPath:(NSString*) path{
	NSFileManager* NSFm=[NSFileManager defaultManager];
	BOOL isDir = NO;
	if([NSFm fileExistsAtPath:path isDirectory:&isDir]){
		[NSFm removeItemAtPath:path error:nil];
	}
}

+ (void) copyFileFromPath:(NSString*) fromFile to:(NSString*) toFile{
	NSFileManager* NSFm=[NSFileManager defaultManager];
	[NSFm copyItemAtPath:fromFile toPath:toFile error:nil];
}

+ (void) removeOldDatabases {
    
    NSArray *documentPaths;
    NSString *documentDir;
    NSString *dataBaseName;
    NSString *dataBasePath;
    documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDir = [documentPaths objectAtIndex:0];
    dataBaseName  = DATABASE_NAME;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentDir error:nil];
    
    for (NSString *path in contents) {
        if ([path isEqualToString:dataBaseName]) {
            break;
        }
        dataBasePath = [documentDir stringByAppendingPathComponent:path];
        
        [fileManager removeItemAtPath:dataBasePath error:nil];
    }
    SAFE_RELEASE(fileManager);    
}



+ (void)displayAlertWithMessage:(NSString *)msg andTitle:(NSString *)title tag:(NSInteger) tag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil, nil];
    alert.tag = tag;
	[alert show];
    [alert release];
}

+ (void)displayAlertWithMessage:(NSString *)msg delegateObj:(id) obj tag:(NSInteger) tag{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(APP_NAME, nil) message:msg delegate:obj cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil, nil];
    alert.tag = tag;
	[alert show];
    [alert release];	
}

+ (void)displayAlertWithMessage:(NSString *)msg tag:(NSInteger) tag{
	[Util displayAlertWithMessage:msg andTitle:NSLocalizedString(APP_NAME, nil) tag:tag];
}

+ (void)displayConfirmWithMessage:(NSString *)msg delegateObj:(id) obj tag:(NSInteger) tag{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(APP_NAME, nil) message:msg delegate:obj cancelButtonTitle:NSLocalizedString(@"Yes", @"Yes") otherButtonTitles:NSLocalizedString(@"No", @"No"), nil];
	alert.tag = tag;
	[alert show];
    [alert release];	
}

+ (NSString*) genProjectPhotoName{
	NSDateFormatter* format =[[NSDateFormatter alloc] init];
	format.dateFormat=@"ddMMyyyyHHmmss";
	NSString* name = [format stringFromDate:[NSDate date]];
	[format release];
	return [NSString stringWithFormat:@"%@.png", name];
}



+ (BOOL) checkCameraAvailable{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		// If camera is avaialble
		return YES;
	}
	else {
		// If camera is NOT avaialble
		return NO;
	}
}


+ (BOOL) checkIsIPadVersion{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 30200
	BOOL deviceIsPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
	return deviceIsPad;
#endif
	return NO;
}

+ (BOOL) compareDate:(NSDate*) date1 isSmaller:(NSDate*) date2{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *dateComponents1 = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:date1];
	NSDateComponents *dateComponents2 = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:date2];
	
	//check year
	if ([dateComponents1 year] > [dateComponents2 year]) {
		return NO;
	}
	
	//check month
	if ([dateComponents1 month] > [dateComponents2 month]) {
		return NO;
	}
	
	//check day
	if ([dateComponents1 day] > [dateComponents2 day]) {
		return NO;
	}

	if ([dateComponents1 day] == [dateComponents2 day]) {
		return NO;
	}	
	
	return YES;
}

+ (BOOL) compareDate:(NSDate*) date1 isEqualTo:(NSDate*) date2{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *dateComponents1 = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:date1];
	NSDateComponents *dateComponents2 = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:date2];
	
	//check year
	if ([dateComponents1 year] == [dateComponents2 year] &&
		[dateComponents1 month] == [dateComponents2 month] &&
		[dateComponents1 day] == [dateComponents2 day]
		) {
		return YES;
	}
	
	return NO;	
}

+ (BOOL)isIPad {
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

+ (BOOL) checkStartDateAndEndDate:(NSDate*) date1 andEndDate:(NSDate*) date2{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *dateComponents1 = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:date1];
	NSDateComponents *dateComponents2 = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:date2];
	
	//check year
	if ([dateComponents1 year] > [dateComponents2 year]) {
		return NO;
	}
	else if ([dateComponents1 year] < [dateComponents2 year]) {
		return YES;
	}	
	
	
	//check month
	if ([dateComponents1 month] > [dateComponents2 month]) {
		return NO;
	}
	else if ([dateComponents1 month] < [dateComponents2 month]) {
		return YES;
	}
	
	//check day
	if ([dateComponents1 day] > [dateComponents2 day]) {
		return NO;
	}
	else if ([dateComponents1 day] < [dateComponents2 day]) {
		return YES;
	}	
	
	if ([dateComponents1 day] == [dateComponents2 day]) {
		NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];

		NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
		[outputFormatter setDateFormat:@"HH"];
		
		//get hour and minute
		int hour1 = [[f numberFromString:[outputFormatter stringFromDate:date1]] intValue];
		int hour2 = [[f numberFromString:[outputFormatter stringFromDate:date2]] intValue];
		
		[outputFormatter setDateFormat:@"mm"];
		int minute1 = [[f numberFromString:[outputFormatter stringFromDate:date1]] intValue];
		int minute2 = [[f numberFromString:[outputFormatter stringFromDate:date2]] intValue];

		[f release];
		[outputFormatter release];
				
		//check hour
		if (hour1 > hour2) {
			return NO;
		}
		if (hour1 < hour2) {
			return YES;
		}		
		
		//check hour
		if (minute1 >= minute2) {
			return NO;
		}		
	}	
	
	return YES;
}

+ (NSString *)timeinAMPMFormat:(NSString *)inputTime andInputFormat:(NSString *)tformat andOutputFormat:(NSString *)outFormat
{
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:tformat];
    
    NSDate *date = [outputFormatter dateFromString:inputTime];
    
    [outputFormatter setDateFormat:outFormat];
    
    return [outputFormatter stringFromDate:date];
}

+ (NSString*) trimString:(NSString *)string{
	return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

}

+ (BOOL) checkiOSGreaterOrEqual5_0{
    int i = [[UIDevice currentDevice].systemVersion floatValue];
    if (i >= 5.0) {
        return YES;
    }
    return NO;
}

+ (NSString*) standardizeLinkString :(NSString *)strInput
{	
	NSMutableString *escapedPath = [NSMutableString stringWithFormat:@"%@",strInput];
	[escapedPath replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escapedPath length])];
	[escapedPath replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escapedPath length])];
	[escapedPath replaceOccurrencesOfString:@"\\" withString:@"%5C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escapedPath length])];
	[escapedPath replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [escapedPath length])];
	return escapedPath;
}

+ (BOOL) checkString:(NSString *)str containSubString:(NSString *)subStr{
	NSRange textRange;
	textRange =[str rangeOfString:subStr];
	
	if(textRange.location != NSNotFound)
	{
		return YES;
	}
	else {
		return NO;
	}
}

+ (NSString *)removeSpaces:(NSString *)textLines {
	NSArray *chunks = [textLines componentsSeparatedByString:@" "];
	if( [chunks count] > 0)
	{
		textLines = [chunks objectAtIndex:0];
		for(int i = 1; i < [chunks count]; i++)
		{
			textLines = [textLines stringByAppendingFormat:@"%%20"];
			textLines = [textLines stringByAppendingString:[chunks objectAtIndex:i]];
		}		
	}
	return textLines;
}

+ (NSString *)validatePhoneNumber:(NSString *)textLines {
    
    NSCharacterSet* characters = [NSCharacterSet characterSetWithCharactersInString:@"()- "];
    textLines = [[textLines componentsSeparatedByCharactersInSet:characters] componentsJoinedByString:@""];
    
    if ([textLines hasPrefix:@"+"]) {
        textLines = [textLines stringByReplacingOccurrencesOfString:@"+" withString:@"00"];
    }
    
	return textLines;
}

+ (BOOL)isValidPhoneNumber:(NSString *)textLines {
    
    if (textLines.length < 7) {
        return FALSE;
    }
    
    NSCharacterSet* characters = [NSCharacterSet characterSetWithCharactersInString:@":/?#[]@!$&'()*, ;=\"<>%{}|\\^~`-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
    
    NSUInteger i;
    for (i = 0; i < [textLines length]; i++) {
        unichar character = [textLines characterAtIndex:i];
        if ([characters characterIsMember:character]) {
            return FALSE;
        }
    }
    return TRUE;
}

+ (BOOL)emailAddressValidation:(NSString *)emailid
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailid options:0 range:NSMakeRange(0, [emailid length])];
    if (regExMatches == 0) {
        return NO;
    } else
        return YES;
}

+ (NSString *)encodeURL:(NSString *)url {    
    
   NSString *newString = NSMakeCollectable([(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)url, NULL, CFSTR(":/?#[]@!$&'()*+, ;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease]);
	if (newString) {
		return [self trimString:newString];
	}
	return @"";
}

+ (BOOL)isStringValid:(NSString *)textToValidate stringToCheck:(NSString *)stringToCheck {
    
    NSCharacterSet* characters = [NSCharacterSet characterSetWithCharactersInString:stringToCheck];
    
    NSUInteger i;
    for (i = 0; i < [textToValidate length]; i++) {
        unichar character = [textToValidate characterAtIndex:i];
        if ([characters characterIsMember:character]) {
            return FALSE;
        }
    }
    return TRUE;
}

+ (NSString*) standardizeQuestionString:(NSString *)strInput{
	strInput = [strInput stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	strInput = [strInput stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	while ([self checkString:strInput containSubString:@"  "]) {
		strInput = [strInput stringByReplacingOccurrencesOfString:@"  " withString:@" "];
	}
	return strInput;
}

+ (NSString *)trimContactLabel:(NSString *)labelstr {
    
    NSCharacterSet* characters = [NSCharacterSet characterSetWithCharactersInString:@"_$!<>"];
    
    labelstr = [labelstr stringByTrimmingCharactersInSet:characters];
    
    return labelstr;
}

+ (NSString*) imagesPath
{
    if([self isIPad])
       return @"IPad.bundle";
    else
       return @"IPhone.bundle";
}

+ (int)fontSizeMenus
{
    if([self isIPad])
        return 28;
    else
        return 17; 
}

+ (int)fontSizeFlashCards
{
    if([self isIPad])
        return 15;
    else
        return 12;
}

+ (int)heightForMenuCell
{
    if([self isIPad])
        return 96;
    else
        return 52;
}

+ (int)heightForYieldMenuCell
{
    if([self isIPad])
        return 96;
    else
        return 60;
}

+ (int)WidthForMenuCell
{
    if([self isIPad])
        return 545;
    else
        return 273;
}

+ (int)heightForTopBar
{
    if([self isIPad])
        return 64;
    else
        return 44;
}

+ (int)UIHeight
{
    if([self isIPad])
        return 1024;
    else
        return 480;
}

+ (int)UIWidth
{
    if([self isIPad])
        return 768;
    else
        return 320;
}

+ (BOOL)isIphone5Display
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height >= 568) {
        return TRUE;
    }
    else
        return FALSE;
}

+ (UIImage *)captureView:(UIView *)view {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
