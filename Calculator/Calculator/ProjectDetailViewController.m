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
    _detail = projectSegue;

}


//перехват метода viewDidLoad
- (void) reloadData {
    //изменяем titile и lable динамически
    self.navigationItem.title = [NSString stringWithFormat:@"%@", _detail.clientAdress];
    nameClient.text = [NSString stringWithFormat:@"%@", _detail.clientName];
    adressClient.text =[NSString stringWithFormat:@"%@", _detail.clientAdress];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    if (editing) {
        NSLog(@"editing");
        editCount = 1;
    } else {
        NSLog(@"not editing");
        editCount = 0;
        
        //сохраняем данные по нажатию на Done
        NSUserDefaults *projects = [NSUserDefaults standardUserDefaults];
        [projects setObject:nameClient.text forKey:[NSString stringWithFormat:@"clientName%@",_detail.clientId]];
        [projects setObject:adressClient.text forKey:[NSString stringWithFormat:@"clientAdress%@",_detail.clientId]];
        
        NSLog(@"new name in detail - %@",[projects objectForKey:[NSString stringWithFormat:@"clientName%@",_detail.clientId]]);
        [projects synchronize];
        
        [self dismissKeyboard];
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    NSLog(@"Hello");
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
