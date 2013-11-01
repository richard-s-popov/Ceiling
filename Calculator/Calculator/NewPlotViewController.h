//
//  NewPlotViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 21.10.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcAppDelegate.h"
#import "PlotCell.h"
#import "Plot.h"
#import "PlotSide.h"
#import "PlotDiagonal.h"
#import "PlotDiagonalViewController.h"

@interface NewPlotViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
}

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UIView *PlotView;
@property (weak, nonatomic) IBOutlet UITableView *tableOfSides;
@property (weak ,nonatomic) PlotDiagonal *diagonal;

@end
