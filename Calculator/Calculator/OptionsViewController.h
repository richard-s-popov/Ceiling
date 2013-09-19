//
//  OptionsViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 13.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcAppDelegate.h"

@interface OptionsViewController : UIViewController

@property (strong, nonatomic) UIButton * menuBtn;

- (IBAction)optMenuBtn:(id)sender;

@end
