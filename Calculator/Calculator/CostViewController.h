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
#import "Materials.h"


@interface CostViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

{
    unsigned luster, bypass, spot;
    __weak IBOutlet UITextField *lusterField;
    __weak IBOutlet UITextField *bypassField;
    __weak IBOutlet UITextField *spotField;
    __weak IBOutlet UIButton *checkBoxKant;
    
    __weak IBOutlet UIPickerView *pickerViewField;
    
    __weak IBOutlet UILabel *squareLabel;
    __weak IBOutlet UILabel *perimetrLabel;
    __weak IBOutlet UIScrollView *scrollView;
}

@property (weak, nonatomic) IBOutlet UILabel *lastCost;
@property (weak, nonatomic) NSString *test;

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) AddPrice *addPrice;
@property (nonatomic, strong) Projects *project;
@property (nonatomic, strong) Plot *plot;
@property (nonatomic, strong) Materials *material;
@property int lastCostInt;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *materialsArray;

- (IBAction)calculateTextField:(id)sender;
- (IBAction)pickMaterial:(id)sender;
- (IBAction)kantCheckBox:(id)sender;

@end
