//
//  CostViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 28.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"

@interface CostViewController : UIViewController

{
    unsigned luster, bypass, spot;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lastCost;


@end
