//
//  MainViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 10.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcAppDelegate.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
- (IBAction)menuBtn:(id)sender;

@end
