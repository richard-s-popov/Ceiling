//
//  ProjectDetailViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "ProjectDetailViewController.h"

@interface ProjectDetailViewController ()

@end

@implementation ProjectDetailViewController
@synthesize nameClient;
@synthesize viewProject;
@synthesize editCount;
@synthesize adressClient;
@synthesize explaneTextView;
@synthesize detail;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// скрываем клавиатуру по нажатию кнопки
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //вызов метода скрытия клавиатуры
    [self dismissKeyboard];
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [nameClient setDelegate:self];
    [adressClient setDelegate:self];
    
    editCount = 0;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //скрываем клавиатуру по нажатию на фон
    UITapGestureRecognizer *tapOnScrolView = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(dismissKeyboard)
                                              ];
    
    [self.view addGestureRecognizer:tapOnScrolView];
    
    [self reloadData];
    
}

- (void) setDetail:(ProjectModel *)projectSegue {
    detail = projectSegue;

}


//перехват метода viewDidLoad
- (void) reloadData {
    //изменяем titile и lable динамически
    self.navigationItem.title = [NSString stringWithFormat:@"%@", detail.clientAdress];
    nameClient.text = [NSString stringWithFormat:@"%@", detail.clientName];
    adressClient.text =[NSString stringWithFormat:@"%@", detail.clientAdress];
    
    NSString *clientId = detail.clientId;
    NSString *clientName = detail.clientName;
    NSString *clientAdress = detail.clientAdress;
    NSLog(@"editing client - %@ %@ %@",clientId, clientName, clientAdress);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    if (editing) {

        editCount = 1;
    } else {

        editCount = 0;
        
        NSString *clientId = detail.clientId;
        NSLog(@"edited clientId - %@",clientId);
        
        //сохраняем данные по нажатию на Done
        NSUserDefaults *projects = [NSUserDefaults standardUserDefaults];
        [projects setObject:nameClient.text forKey:[NSString stringWithFormat:@"clientName%@",clientId]];
        [projects setObject:adressClient.text forKey:[NSString stringWithFormat:@"clientAdress%@",clientId]];
        [projects setObject:clientId forKey:[NSString stringWithFormat:@"clientId%@",clientId]];
        
        [projects synchronize];
        
        
        
        [self dismissKeyboard];
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (editCount == 0) {
        return NO;
    }
    else {
        return YES;
    }
}


//метод скрытия клавиатуры по нажатию на фон
- (void)dismissKeyboard {
    
    [nameClient resignFirstResponder];
    [adressClient resignFirstResponder];
}

@end
