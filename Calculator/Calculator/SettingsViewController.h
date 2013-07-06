//
//  SettingsViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 03.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>

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

//создание переменных контакты пользователя
@property (nonatomic, weak) NSString * userName;
@property (nonatomic, weak) NSString * userPhone;
@property (nonatomic, weak) NSString * userEmail;

//создание переменных контакты менеджера
@property (nonatomic, weak) NSString * managerName;
@property (nonatomic, weak) NSString * managerPhone;
@property (nonatomic, weak) NSString * managerEmail;

//создание переменных контакты цеха
@property (nonatomic, weak) NSString * manufactoryPhone;
@property (nonatomic, weak) NSString * manufactoryEmail;


- (IBAction)saveSettings:(id)sender;


@end
