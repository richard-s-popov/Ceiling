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


//переменные контактов
@synthesize userName;
@synthesize userPhone;
@synthesize userEmail;

@synthesize managerName;
@synthesize managerPhone;
@synthesize managerEmail;

@synthesize manufactoryPhone;
@synthesize manufactoryEmail;



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
    
    
    // загружаем сохраненные данные из памяти
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userName = [defaults objectForKey:@"savedUserName"];
    userPhone = [defaults objectForKey:@"savedUserPhone"];
    userEmail = [defaults objectForKey:@"savedUserEmail"];
    managerName = [defaults objectForKey:@"savedManagerName"];
    managerPhone = [defaults objectForKey:@"savedManagerPhone"];
    managerEmail = [defaults objectForKey:@"savedManagerEmail"];
    manufactoryPhone = [defaults objectForKey:@"savedManufactoryPhone"];
    manufactoryEmail = [defaults objectForKey:@"savedManufactoryEmail"];
    
    //загружаем данные в поля
    [userNameField setText:userName];
    [userPhoneField setText:userPhone];
    [userEmailField setText:userEmail];
    [managerNameField setText:managerName];
    [managerPhoneField setText:managerPhone];
    [managerEmailField setText:managerEmail];
    [manufactoryPhoneField setText:manufactoryPhone];
    [manufactoryEmailField setText:manufactoryEmail];

    //скрываем клавиатуру по нажатию на фон
    UITapGestureRecognizer *tapOnScrolView = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(dismissKeyboard)
                                              ];
    
    [self.view addGestureRecognizer:tapOnScrolView];
	
    // Do any additional setup after loading the view.
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


- (IBAction)saveSettings:(id)sender {
    
    userName = userNameField.text;
    userPhone = userPhoneField.text;
    userEmail = userEmailField.text;
    
    managerName = managerEmailField.text;
    managerPhone = managerPhoneField.text;
    managerEmail = managerEmailField.text;
    
    manufactoryPhone = manufactoryPhoneField.text;
    manufactoryEmail = manufactoryEmailField.text;
    
    
    // сохраняем данные о пользователе, менеджере и цехе
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:@"savedUserName"];
    [defaults setObject:userPhone forKey:@"savedUserPhone"];
    [defaults setObject:userEmail forKey:@"savedUserEmail"];
    [defaults setObject:managerName forKey:@"savedManagerName"];
    [defaults setObject:managerPhone forKey:@"savedManagerPhone"];
    [defaults setObject:managerEmail forKey:@"savedManagerEmail"];
    [defaults setObject:manufactoryPhone forKey:@"savedManufactoryPhone"];
    [defaults setObject:manufactoryEmail forKey:@"savedManufactoryEmail"];
    
    [defaults synchronize];
    
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
