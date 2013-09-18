//
//  CostViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 28.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcAppDelegate.h"
#import "AddPrice.h"
#import "Projects.h"


@interface CostViewController : UIViewController

{
    unsigned luster, bypass, spot;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lastCost;
@property (weak, nonatomic) NSString *test;

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) AddPrice *addPrice;
@property (nonatomic, strong) Projects *project;

@end
