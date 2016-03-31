//
//  NewsListCell.m
//  AtlantasBravs
//
//  Created by Zain Raza on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsListCell.h"

@implementation NewsListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellTitle:(NSString *)title detail:(NSString *)detail andDate:(NSString *)date
{
    [titleLbl setText:title];
    [detailText setText:detail];
    [dateLbl setText:date];
}

@end
