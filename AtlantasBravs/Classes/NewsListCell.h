//
//  NewsListCell.h
//  AtlantasBravs
//
//  Created by Zain Raza on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListCell : UITableViewCell
{
    IBOutlet UILabel *titleLbl;
    IBOutlet UITextView *detailText;
    IBOutlet UILabel *dateLbl;
}

- (void)setCellTitle:(NSString *)title detail:(NSString *)detail andDate:(NSString *)date;

@end
