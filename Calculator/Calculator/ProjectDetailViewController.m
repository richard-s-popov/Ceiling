//
//  ProjectDetailViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "ProjectsListViewController.h"
#import "ProjectModel.h"
#import "ProjectServise.h"

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
