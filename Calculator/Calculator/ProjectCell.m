//
//  ProjectCell.m
//  Calculator
//
//  Created by Александр Коровкин on 18.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "ProjectCell.h"

@implementation ProjectCell
@synthesize labelName;
@synthesize labelAdress;


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
