//
//  CostViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 28.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"
#import "AddSettingsModel.h"
#import "AddSettingsServise.h"


@interface CostViewController : UIViewController

{
    unsigned luster, bypass, spot;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lastCost;
@property (weak, nonatomic) NSString *test;
@property (weak, nonatomic) ProjectModel *detailProjectData;

- (void)PutSettings:(ProjectModel *)putSettings;
@end
