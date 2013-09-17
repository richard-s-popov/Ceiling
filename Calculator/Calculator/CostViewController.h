//
//  CostViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 28.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"
#import "CalcAppDelegate.h"
#import "AddPrice.h"


@interface CostViewController : UIViewController

{
    unsigned luster, bypass, spot;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lastCost;
@property (weak, nonatomic) NSString *test;
@property (weak, nonatomic) ProjectModel *detailProjectData;

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) AddPrice *addPrice;

- (void)PutSettings:(ProjectModel *)putSettings;
@end
