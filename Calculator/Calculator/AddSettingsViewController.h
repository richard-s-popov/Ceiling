//
//  AddSettingsViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 31.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSettingsModel.h"
#import "AddSettingsServise.h"

@interface AddSettingsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *lusterTextField;
@property (weak, nonatomic) IBOutlet UITextField *bypassTextField;
@property (weak, nonatomic) IBOutlet UITextField *spotTextField;

@property (weak, nonatomic) AddSettingsModel *savedAddittionaly;

@end
