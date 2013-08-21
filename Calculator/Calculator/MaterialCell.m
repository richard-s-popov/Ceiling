//
//  MaterialCell.m
//  Calculator
//
//  Created by Александр Коровкин on 19.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "MaterialCell.h"

@implementation MaterialCell
@synthesize priceCell;

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

@end
