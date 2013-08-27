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
@synthesize settingsScroller;
@synthesize lusterClient;
@synthesize bypassClient;
@synthesize spotClient;

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
    
    [settingsScroller setScrollEnabled:YES];
    [settingsScroller setContentSize:CGSizeMake(320, 850)];
    
    [nameClient setDelegate:self];
    [adressClient setDelegate:self];
    [explaneTextView setDelegate:self];
    [lusterClient setDelegate:self];
    [bypassClient setDelegate:self];
    [spotClient setDelegate:self];
    
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
    lusterClient.text = [NSString stringWithFormat:@"%@", detail.clientLuster];
    bypassClient.text = [NSString stringWithFormat:@"%@", detail.clientBypass];
    spotClient.text = [NSString stringWithFormat:@"%@", detail.clientSpot];
    explaneTextView.text = detail.clientExplane.text;
    
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
        [projects setObject:explaneTextView.text forKey:[NSString stringWithFormat:@"clientExplane%@", clientId]];
        [projects setObject:lusterClient.text forKey:[NSString stringWithFormat:@"clientLuster%@",clientId]];
        [projects setObject:bypassClient.text forKey:[NSString stringWithFormat:@"clientBypass%@",clientId]];
        [projects setObject:spotClient.text forKey:[NSString stringWithFormat:@"clientSpot%@",clientId]];

        
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


//РЕДАКТИРОВАНИЕ  textView TRUE or FALSE В ФУНКЦИИ
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
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
    [explaneTextView resignFirstResponder];
    [lusterClient resignFirstResponder];
    [bypassClient resignFirstResponder];
    [spotClient resignFirstResponder];
}

@end
