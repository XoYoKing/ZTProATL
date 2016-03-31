//
//  ESPNView.h
//  AtlantasBravs
//
//  Created by Guest on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface ESPNView : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
}

-(IBAction)refresh:(id)sender;
@end
