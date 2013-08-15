//
//  MathSingleViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 15.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MathModel.h"

@interface MathSingleViewController : UIViewController

@property (nonatomic, strong) MathModel *detail;
@property (weak, nonatomic) IBOutlet UILabel *nameMaterialInDetail;
@property (weak, nonatomic) IBOutlet UILabel *priceMaterialInDetail;

@end
