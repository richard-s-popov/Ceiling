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
@synthesize scrollView;

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
    [settingsScroller setContentSize:CGSizeMake(320, 900)];
    
    [nameClient setDelegate:self];
    [adressClient setDelegate:self];
    [explaneTextView setDelegate:self];
    [lusterClient setDelegate:self];
    [bypassClient setDelegate:self];
    [spotClient setDelegate:self];
    
    editCount = 0;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //СОЗДАНИЕ BUTTONS В TOOLBAR
//    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"DATE" style:UIBarButtonItemStyleDone target:self action:@selector(dateToolbardoneButtonAction)];
//    UIBarButtonItem *button2=[[UIBarButtonItem alloc]initWithTitle:@"TIME" style:UIBarButtonItemStyleDone target:self action:@selector(timeToolbarbuttonAction)];
//    
//    NSArray *items = [NSArray arrayWithObjects:button1, button2, nil];
//    
//    self.toolbarItems = items;
    
        
    //скрываем клавиатуру по нажатию на фон
    UITapGestureRecognizer *tapOnScrolView = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(dismissKeyboard)
                                              ];
    
    [self.view addGestureRecognizer:tapOnScrolView];
    
    [self reloadData];
    
}

//принимаем объект проекта из  ProjectListViewController
- (void) setDetail:(ProjectModel *)projectSegue {
    detail = projectSegue;

}

//передаем данные по segue в CostViewController для расчета стоимости
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //получаем объект проекта в котором находимся через ProjectService
    ProjectServise *contaner = [[ProjectServise alloc] init];
    ProjectModel *newData = [contaner changeDetailProject];
    
    //передаем данные в метод PutSettings класса CostViewController
    [segue.destinationViewController PutSettings:newData];
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
    
    NSUserDefaults *projects = [NSUserDefaults standardUserDefaults];
    [projects setObject:detail.clientId forKey:@"lustProject"];
    
    [projects synchronize];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    if (editing) {
        
        //УВЕЛИЧИВАЕТ SCROLLVIEW ДЛЯ УДОБСТВА РЕДАКТИРОВАНИЯ
        [settingsScroller setContentSize:CGSizeMake(320, 1100)];
        editCount = 1;
    } else {

        editCount = 0;
        [settingsScroller setContentSize:CGSizeMake(320, 900)];
//        NSString *clientId = detail.clientId;
        
        //сохраняем данные по нажатию на Done в новый объект
        ProjectModel *newData = [[ProjectModel alloc] init];
        newData.clientName = nameClient.text;
        newData.clientAdress = adressClient.text;
        
        newData.clientExplane = explaneTextView;
        newData.clientLuster = lusterClient.text;
        newData.clientBypass = bypassClient.text;
        newData.clientSpot = spotClient.text;
        newData.clientId = detail.clientId;

        
        ProjectServise *containerProject = [[ProjectServise alloc] init];
        [containerProject SaveDetail:newData];
        

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


- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    scrollView.contentOffset = (CGPoint){
        0, // ось x нас не интересует
        CGRectGetMinY(explaneTextView.frame) - 50 // Скроллим скролл к верхней границе текстового поля - Вы можете настроить эту величину по своему усмотрению
    };
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    scrollView.contentOffset = (CGPoint){0, 0}; // Возвращаем скролл в начало, так как редактирование текстового поля закончено
}


//ПОДНИМАЕМ SCROLLVIEW КОГДА ПОДНИМАЕТСЯ КЛАВИАТУРА
- (void)textFieldDidBeginEditing:(UITextField *)textField {

    scrollView.contentOffset = (CGPoint) {
        0, CGRectGetMinY(textField.frame) - 20
    };
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    scrollView.contentOffset = (CGPoint) {
        0,0
    };
}

- (IBAction)Cost:(id)sender {
    
    [self performSegueWithIdentifier:@"Cost" sender:self];
}
@end
