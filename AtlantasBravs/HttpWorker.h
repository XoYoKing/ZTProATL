//
//  HttpWorker.h
//  AutumnIphone
//
//  Created by Javed Zahid on 8/17/10.
//  Copyright 2010 tcm. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"



@interface HttpWorker : NSObject{
	
	NSString *serverAddr;
	NSString *param;
	BOOL isLive;
	NSURL *url;
	ASIHTTPRequest *httpRequest;
	NSData *data;
	UIViewController *from;
    int JOB_CODE;
    NSString *response;
    

}
@property (nonatomic) int JOB_CODE;
@property (nonatomic, strong) NSString *serverAddr;
@property (nonatomic, strong) NSString *param;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) ASIHTTPRequest *httpRequest;
@property (nonatomic, strong) UIViewController *from;
@property (nonatomic, strong) NSString *response;



-(void) start;
-(void) startHttpWorker;
-(void) setRequestParameters:(NSString *)parameters;
-(void) sendData;
-(void) dismissedAlert;
-(void) cancelRequest;
-(void) showProgressBar;
+(void) sendToken:(NSString *)token;
+(void)setScoreAlerts:(NSString *)score;
+(void)setMotivation:(BOOL)motivation;

@end
