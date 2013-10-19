//
//  PlotDataViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 29.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcAppDelegate.h"
#import "PlotCell.h"

@interface PlotDataViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSArray *sidesList;
}

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITableView *tableOfSides;
@property (strong, nonatomic) IBOutlet UITextField *angleCountOutlet;
@property (nonatomic, strong) NSString *countOfAngle;
@property (nonatomic, strong) NSArray *alphabet;

- (IBAction)sideWidthField:(id)sender;
- (IBAction)angleCount:(id)sender;
@end
