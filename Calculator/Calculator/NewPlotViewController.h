//
//  NewPlotViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 21.10.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcAppDelegate.h"
#import "Projects.h"
#import "Plot.h"
#import "PlotSide.h"
#import "PlotDiagonal.h"
#import "PlotDiagonalViewController.h"
#import "PlotVisualController.h"

#import "CalculateCurveLine.h"
#import "CurveLineModel.h"

@interface NewPlotViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
}

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSMutableArray *mutableArraySides;
@property (strong, nonatomic) IBOutlet UIView *PlotView;
@property (weak, nonatomic) IBOutlet UITableView *tableOfSides;
@property (weak ,nonatomic) PlotDiagonal *diagonal;
@property (nonatomic, strong) Plot *plotFromProject;
@property (nonatomic, strong) Projects *project;
@property (strong, nonatomic) IBOutlet UIView *sidesView;
@property (weak, nonatomic) IBOutlet UIView *sidesConteinerView;

@property (nonatomic, strong) CurveLineModel *curve;

- (IBAction)saveAll:(id)sender;

@end
