//
//  ProjectPlotCell.m
//  Calculator
//
//  Created by Александр Коровкин on 04.11.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "ProjectPlotCell.h"

@implementation ProjectPlotCell
@synthesize namePlot;
@synthesize pricePlot;

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
