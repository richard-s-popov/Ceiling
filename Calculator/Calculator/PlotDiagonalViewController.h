//
//  PlotDiagonalViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 01.11.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiagonalTmp.h"
#import "Plot.h"
#import "PlotSide.h"
#import "PlotDiagonal.h"
#import "CalcAppDelegate.h"


@interface PlotDiagonalViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) PlotSide *side;
@property (nonatomic, strong) PlotSide *sideFor90;
@property (nonatomic, strong) Plot *plot;
@property (nonatomic, strong) PlotDiagonal *diagonal;
@property (nonatomic, strong) DiagonalTmp *diagonalTmp;
@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic) NSUInteger index;
@property (weak, nonatomic) IBOutlet UIView *diagonalConteinerView;

@property (weak, nonatomic) IBOutlet UITableView *tableOfDiagonal;

@end
