//
//  SettingsViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 03.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsOptionsModel.h"
#import "SettingsService.h"

@interface SettingsViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate> {

    __weak IBOutlet UITextField *userNameField;
    __weak IBOutlet UITextField *userPhoneField;
    __weak IBOutlet UITextField *userEmailField;
    
    __weak IBOutlet UITextField *managerNameField;
    __weak IBOutlet UITextField *managerPhoneField;
    __weak IBOutlet UITextField *managerEmailField;

    __weak IBOutlet UITextField *manufactoryPhoneField;
    __weak IBOutlet UITextField *manufactoryEmailField;
    
    
    __weak IBOutlet UIScrollView *settingsScroller;
    
}


- (IBAction)saveSettings:(id)sender;

@end
