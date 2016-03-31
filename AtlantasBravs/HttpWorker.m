//
//  HttpWorker.m
//  AutumnIphone
//
//  Created by Javed Zahid on 8/17/10.
//  Copyright 2010 tcm. All rights reserved.
//

#import "HttpWorker.h"
#import "Resources.h"
#import "AFNetworking.h"

@implementation HttpWorker
@synthesize param;
@synthesize url;
@synthesize httpRequest;
@synthesize data;
@synthesize from;
@synthesize serverAddr;
@synthesize JOB_CODE;
@synthesize response;

-(id) init
{ 
	self = [super init];
    serverAddr = @"http://63.142.251.208/server";
	return self;
}

-(void) start{
    [NSThread detachNewThreadSelector:@selector(showProgressBar) toTarget:self withObject:nil];
    @autoreleasepool {
		[self performSelectorOnMainThread:@selector(startHttpWorker) withObject:nil waitUntilDone:NO];
	}
}
-(void) showProgressBar
{
//    [[Resources sharedResources] showNetworkingActivity:self.from];
}
-(void) cancelRequest {
    if(httpRequest != NULL && httpRequest != nil) {    
        NSLog(@"Canceling HttpReq");
        if([httpRequest isExecuting] == TRUE) {
            [httpRequest cancel];
        }
    }
    
}
-(void) startHttpWorker {
	@try {
        
        
        NSString *finalURL = [serverAddr stringByAppendingString:param];
		url = [NSURL URLWithString:finalURL];
        
        NSLog(@"Final URL: %@",url);
        
		httpRequest = [ASIHTTPRequest requestWithURL:url];	
		[httpRequest setTimeOutSeconds:60];
		[httpRequest setAllowCompressedResponse:YES];
		[httpRequest setDelegate:self];
		[httpRequest startSynchronous];
	}
	@catch (NSException * e) {
	}
	@finally {
	}
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
	@try {
        int responsecode = [request responseStatusCode];
        if(responsecode == 200)
        {
            data = [request responseData];
            [self sendData];
            //            [self.from.navigationController pushViewController:[[Resources getResources] getMyAlertScreen] animated:YES];
        }
        else
        {
            [self dismissedAlert];
//            [[Resources sharedResources] hideNetworkIndicator];
//            [[Resources sharedResources] showAlertWithTitle:@"Error" withBody:@"Connection failure. Try again later."];
        }
	}
	@catch (NSException * e) {
		
	}
	@finally {
	}
}

-(void)requestFailed:(ASIHTTPRequest *)request{
	@try {
        NSLog(@"%@",request.error);
		[self dismissedAlert];
//		[[Resources sharedResources] hideNetworkIndicator];
//                    [[Resources sharedResources] showAlertWithTitle:@"Error" withBody:@"Connection failure. Please check your internet connectivity and try again."];
    }
	@catch (NSException * e) {
	}
	@finally {
	}
}


-(void) setRequestParameters:(NSString *)parameters{
	@try {
        self.param = parameters;
	}
	@catch (NSException * e) {
		
	}
	@finally {
		
	}
}

-(void)sendData
{
	@try {
        NSString *serverResponse =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response from server %@",serverResponse);
      
	}
	@catch (NSException * e) {
	}
	@finally {
		
	}
}

-(void)dismissedAlert
{
	@try {		
        for (UIWindow* window in [UIApplication sharedApplication].windows) {
            for (UIView* view in window.subviews) {
                BOOL alert = [view isKindOfClass:[UIAlertView class]];
                if (alert){
                    [(UIAlertView *)view dismissWithClickedButtonIndex:0 animated:NO];
                    break;
                }
            }
        }
	}
	@catch (NSException * e) {
	}
	@finally {
		
	}
}
+(void) sendToken:(NSString *)token
{
    NSString *paramStr;
	paramStr = @"";
	paramStr = [paramStr stringByAppendingString:@"token="];
	paramStr = [paramStr stringByAppendingString:token];
    
	NSString *url = @"/user.php?";
	url = [url stringByAppendingString:paramStr];
    
	HttpWorker *httpWorker = [[HttpWorker alloc] init];
    [httpWorker setRequestParameters:url];
	[httpWorker start];
}

+(void)setMotivation:(BOOL)motivation
{
    NSString *paramStr;
    paramStr = @"";
    paramStr = [paramStr stringByAppendingString:@"motivation="];
    if (motivation) {
        paramStr = [paramStr stringByAppendingString:@"Atlanta:1"];
    }else {
        paramStr = [paramStr stringByAppendingString:@"Atlanta:0"];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"deviceToken"]) {
        paramStr = [paramStr stringByAppendingString:@"&"];
        paramStr = [paramStr stringByAppendingString:@"token="];
        paramStr = [paramStr stringByAppendingString:[defaults objectForKey:@"deviceToken"]];
    }
    
    NSString *url = @"/setalert.php?";
    url = [url stringByAppendingString:paramStr];
    
    HttpWorker *httpWorker = [[HttpWorker alloc] init];
    [httpWorker setRequestParameters:url];
    [httpWorker start];
}

+(void)setScoreAlerts:(NSString *)score
{
    NSString *paramStr;
    paramStr = @"";
    paramStr = [paramStr stringByAppendingString:@"score="];
    paramStr = [paramStr stringByAppendingString:score];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"deviceToken"]) {
        paramStr = [paramStr stringByAppendingString:@"&"];
        paramStr = [paramStr stringByAppendingString:@"token="];
        paramStr = [paramStr stringByAppendingString:[defaults objectForKey:@"deviceToken"]];
    }
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"score":score}];
    if ([defaults objectForKey:@"deviceToken"]) {
        [params setObject:[defaults objectForKey:@"deviceToken"] forKey:@"token"];
    }
    [manager POST:@"setalert.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    /*NSString *url = @"/setalert.php?";
    url = [url stringByAppendingString:paramStr];
    
    HttpWorker *httpWorker = [[HttpWorker alloc] init];
    [httpWorker setRequestParameters:url];
    [httpWorker start];*/
}
@end
