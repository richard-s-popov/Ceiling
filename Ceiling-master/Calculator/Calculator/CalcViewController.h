//
//  CalcViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 30.06.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface CalcViewController : SettingsViewController {

    IBOutlet UILabel *displayLabel;
    double x, y;
    NSInteger operation;
    
    BOOL enterFlag, yFlag, dotFlag;
    
    
}

- (IBAction)clear:(id)sender;
- (IBAction)clearAll:(id)sender;

- (IBAction)digit:(id)sender;
- (IBAction)operation:(id)sender;

- (IBAction)inverseSign:(id)sender;
- (IBAction)dotDivider:(id)sender;

- (IBAction)menuBtn:(id)sender;

@end
