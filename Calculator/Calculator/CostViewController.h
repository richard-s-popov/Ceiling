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
#import "Plot.h"


@interface CostViewController : UIViewController <UITextFieldDelegate>

{
    unsigned luster, bypass, spot;
    __weak IBOutlet UITextField *lusterField;
    __weak IBOutlet UITextField *bypassField;
    __weak IBOutlet UITextField *spotField;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lastCost;
@property (weak, nonatomic) NSString *test;

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) AddPrice *addPrice;
@property (nonatomic, strong) Projects *project;
@property (nonatomic, strong) Plot *plot;
@property int lastCostInt;

- (IBAction)calculateTextField:(id)sender;

@end
