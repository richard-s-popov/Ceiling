//
//  MaterialCell.h
//  Calculator
//
//  Created by Александр Коровкин on 19.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceCell;
@property (weak, nonatomic) IBOutlet UILabel *nameCell;
@property (weak, nonatomic) IBOutlet UILabel *widthCell;
@property (strong, nonatomic) IBOutlet UILabel *labelPriceCell;

@end
