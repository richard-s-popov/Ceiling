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
#import "Plot.h"
#import "PlotSide.h"
#import "PlotDiagonal.h"

@interface PlotDataViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
}

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITableView *tableOfSides;
@property (strong, nonatomic) IBOutlet UITextField *angleCountOutlet;
//@property (nonatomic, strong) NSString *countOfAngle;
@property (nonatomic, strong) NSArray *alphabet;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//диагонали
@property (weak, nonatomic) IBOutlet UITextField *diagonalName;
@property (weak, nonatomic) IBOutlet UITextField *diagonalWidth;
- (IBAction)saveDiagonal:(id)sender;
- (IBAction)endDiagonal:(id)sender;



- (IBAction)generateAngle:(id)sender;
- (IBAction)sideWidthField:(id)sender;
- (IBAction)angleCount:(id)sender;
- (IBAction)doneSides:(id)sender;
- (IBAction)clearData:(id)sender;

-(IBAction)closeKeyboard:(id)sender;
@end
