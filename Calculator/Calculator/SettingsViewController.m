//
//  SettingsViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 03.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "SettingsViewController.h"

//константы: теги полей (нужны для определения полей)
enum {
    
    MANAGER_NAME        =   504,
    MANAGER_PHONE       =   505,
    MANAGER_EMAIL       =   506,
    MANUFACTORY_PHONE   =   507,
    MANUFACTORY_EMAIL   =   508
    
};


@interface SettingsViewController ()

@end


@implementation SettingsViewController


// скрываем клавиатуру по нажатию кнопки
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //пользовательские поля
    [userNameField resignFirstResponder];
    [userPhoneField resignFirstResponder];
    [userEmailField resignFirstResponder];
    
    //поля контактов менеджера
    [managerNameField resignFirstResponder];
    [managerPhoneField resignFirstResponder];
    [managerEmailField resignFirstResponder];
    
    //поля контактов цеха
    [manufactoryPhoneField resignFirstResponder];
    [manufactoryEmailField resignFirstResponder];
    return YES;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //запускаем скроллер
    [settingsScroller setScrollEnabled:YES];
    [settingsScroller setContentSize:CGSizeMake(320, 750)];
    
    // скрываем клавиатуру по нажатию кнопки
    userNameField.delegate = self;
    userPhoneField.delegate = self;
    userEmailField.delegate = self;
    
    managerNameField.delegate = self;
    managerPhoneField.delegate = self;
    managerEmailField.delegate = self;
    
    manufactoryPhoneField.delegate = self;
    manufactoryEmailField.delegate = self;
    
    
    //создаем новый объект SettingsOptionsModel для помещения в него сохраненных настроек из класса SettingsServise (метода Read)
    SettingsOptionsModel * settingsModal = [SettingsOptionsModel new];
    SettingsService * settingsService = [SettingsService new];
    
    //присваеваем объекту settingsServise то что возвращает функция Read в классе SettingsServise (то есть сохраненные настройки)
    settingsModal = settingsService.Read;
    
    //загружаем данные в поля
    userNameField.text = [settingsModal userName];
    userPhoneField.text = [settingsModal userPhone];
    userEmailField.text = [settingsModal userEmail];
    
    managerNameField.text = [settingsModal managerName];
    managerPhoneField.text = [settingsModal managerPhone];
    managerEmailField.text = [settingsModal managerEmail];
    
    manufactoryPhoneField.text = [settingsModal manufactoryPhone];
    manufactoryEmailField.text = [settingsModal manufactoryEmail];

    
    //скрываем клавиатуру по нажатию на фон
    UITapGestureRecognizer *tapOnScrolView = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(dismissKeyboard)
                                              ];
    
    [self.view addGestureRecognizer:tapOnScrolView];
	
    // Do any additional setup after loading the view.
}


- (IBAction)saveSettings:(id)sender {
    
    //создаем новый объект модели SettingsOptionsModel для передачи его в класс SettingsServise
    SettingsOptionsModel * settingsOptions = [SettingsOptionsModel new];
    
    [settingsOptions setUserName:userNameField.text];
    [settingsOptions setUserPhone:userPhoneField.text];
    [settingsOptions setUserEmail:userEmailField.text];
    
    [settingsOptions setManagerName:managerNameField.text];
    [settingsOptions setManagerPhone:managerPhoneField.text];
    [settingsOptions setManagerEmail:managerEmailField.text];
    
    [settingsOptions setManufactoryPhone:manufactoryPhoneField.text];
    [settingsOptions setManufactoryEmail:manufactoryEmailField.text];
    
    //передаем созданый объект settingsOptions в класс SettingsServise в функцию Save как параметр
    SettingsService * settingsServise = [SettingsService new];
    [settingsServise Save:settingsOptions];
    
}


//поднимаем View для видимости поля ввода
// Portrait Keyboard height 216 pts
// Landscape Keyboard height 162 pts
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == MANAGER_NAME || textField.tag == MANAGER_PHONE || textField.tag == MANAGER_EMAIL) {
        
        float moveSpeed = 0.2f;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:moveSpeed];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        self.view.frame = CGRectMake(0, -200.0f, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
    
    if (textField.tag == MANUFACTORY_PHONE || textField.tag == MANUFACTORY_EMAIL) {
        
        float moveSpeed = 0.2f;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:moveSpeed];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        self.view.frame = CGRectMake(0, -205.0f, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    float moveSpeed = 0.2f;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:moveSpeed];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
}


//метод скрытия клавиатуры по нажитию на background
- (void)dismissKeyboard {
    
    [userNameField resignFirstResponder];
    [userPhoneField resignFirstResponder];
    [userEmailField resignFirstResponder];
    [managerNameField resignFirstResponder];
    [managerPhoneField resignFirstResponder];
    [managerEmailField resignFirstResponder];
    [manufactoryPhoneField resignFirstResponder];
    [manufactoryEmailField resignFirstResponder];
    
}


/* метод изменения label (тестовый не определен в header файле)
 
 - (IBAction)displaySettings:(id)sender {
 
 [userSettingsLabel setText:[NSString stringWithFormat:@"hello %@",userName]];
 
 }*/

@end
