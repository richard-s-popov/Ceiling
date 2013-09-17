//
//  SettingsViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 03.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "SettingsViewController.h"
#import "ECSlidingViewController.h"
#import "CalcAppDelegate.h"


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
//@synthesize contacts;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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
    
//    CalcAppDelegate *calcAppDelegate = [[UIApplication sharedApplication] delegate];
//    _managedObjectContext = [calcAppDelegate managedObjectContext];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:_managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
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
    
    
    //создаем новый объект Contacts для помещения в него сохраненных настроек из класса SettingsServise (метода Read)
    SettingsService * settingsService = [[SettingsService alloc]init];
    
    //присваеваем объекту settingsModal то что возвращает функция Read в классе SettingsServise (то есть сохраненные настройки)
     SettingsOptionsModel *contacts = settingsService.Read;
    
    //загружаем данные в поля
    userNameField.text = [contacts userName];
    userPhoneField.text = [contacts userPhone];
    userEmailField.text = [contacts userMail];
    
    managerNameField.text = [contacts managerName];
    managerPhoneField.text = [contacts managerPhone];
    managerEmailField.text = [contacts managerMail];
    
    manufactoryPhoneField.text = [contacts manufactoryPhone];
    manufactoryEmailField.text = [contacts manufactoryMail];

    
    //скрываем клавиатуру по нажатию на фон
    UITapGestureRecognizer *tapOnScrolView = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(dismissKeyboard)
                                              ];
    
    [self.view addGestureRecognizer:tapOnScrolView];
    
    //кнопка редактирования
    UIBarButtonItem *saveButton =[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                  target:self
                                  action:@selector(saveBtn)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
}


-(void)saveBtn {
        
    //создаем новый объект модели SettingsOptionsModel для передачи его в класс SettingsServise
//    contacts = [NSEntityDescription insertNewObjectForEntityForName:@"Contacts" inManagedObjectContext:_managedObjectContext];
    SettingsOptionsModel *contacts = [[SettingsOptionsModel alloc]init];
    
    [contacts setUserName:userNameField.text];
    [contacts setUserPhone:userPhoneField.text];
    [contacts setUserMail:userEmailField.text];
    
    [contacts setManagerName:managerNameField.text];
    [contacts setManagerPhone:managerPhoneField.text];
    [contacts setManagerMail:managerEmailField.text];
    
    [contacts setManufactoryPhone:manufactoryPhoneField.text];
    [contacts setManufactoryMail:manufactoryEmailField.text];
    
    NSLog(@"name: %@", contacts.userName);
    
//    NSError *error = nil;
//    if (![_managedObjectContext save:&error]) {
//    }
    //передаем созданый объект settingsOptions в класс SettingsServise в функцию Save как параметр
    SettingsService * settingsServise = [[SettingsService alloc]init];
    [settingsServise Save:contacts];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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


@end
