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

@synthesize viewProject;
@synthesize explaneTextView;
@synthesize scrollView;


@synthesize editCount;

@synthesize nameClient;
@synthesize adressClient;
@synthesize lusterClient;
@synthesize bypassClient;
@synthesize spotClient;

@synthesize project;
@synthesize managedObjectContext;


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

-(NSManagedObjectContext *)managedObjectContext {
    return [(CalcAppDelegate *)[[UIApplication sharedApplication]delegate] managedObjectContext];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 900)];
    
    [nameClient setDelegate:self];
    [adressClient setDelegate:self];
    [explaneTextView setDelegate:self];
    [lusterClient setDelegate:self];
    [bypassClient setDelegate:self];
    [spotClient setDelegate:self];
    
    editCount = 0;
    
    //кнопка редактирования
    //редактируем и добавляем Edit Button
    UIImage *rightButtonImage = [[UIImage imageNamed:@"rightBtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 23, 0, 6)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.title = @"Изменить";
    [self.editButtonItem setTitleTextAttributes:blackText forState:UIControlStateNormal];
    [self.editButtonItem setBackgroundImage:rightButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImage *toolbarButtonImage = [[UIImage imageNamed:@"toolbarBtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12,0,12)];
    UIImage *shareButtonImage = [[UIImage imageNamed:@"shareBtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [costBtn setBackgroundImage:toolbarButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [shareBtn setBackgroundImage:shareButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    shareBtn.title = @"";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    //скрываем клавиатуру по нажатию на фон
    UITapGestureRecognizer *tapOnScrolView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapOnScrolView];
    
    [self reloadData];
    
}

- (void) reloadData {
    
//    self.navigationItem.title = project.projectAdress;
    nameClient.text = project.projectName;
    adressClient.text = project.projectAdress;
    lusterClient.text = [project.projectLuster stringValue];
    bypassClient.text = [project.projectBypass stringValue];
    spotClient.text = [project.projectSpot stringValue];
    explaneTextView.text = project.projectExplane;
    
}

-(void)saveData {

    project.projectName = nameClient.text;
    project.projectAdress = adressClient.text;
    project.projectLuster = [NSNumber numberWithInt:[lusterClient.text intValue]];
    project.projectBypass = [NSNumber numberWithInt:[bypassClient.text intValue]];
    project.projectSpot = [NSNumber numberWithInt:[spotClient.text intValue]];
    project.projectExplane = explaneTextView.text;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
    }
}

//передаем данные по segue в CostViewController для расчета стоимости
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        
    if ([segue.identifier isEqual: @"Cost"]) {
        
        CostViewController *costViewController = segue.destinationViewController;
        costViewController.project = project;
    //щдв сщву
//        //получаем объект проекта в котором находимся через ProjectService
//        ProjectServise *contaner = [[ProjectServise alloc] init];
//        ProjectModel *newData = [contaner changeDetailProject];
//        
//        //передаем данные в метод PutSettings класса CostViewController
//        [segue.destinationViewController PutSettings:newData];
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

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    if (editing) {
        
        self.editButtonItem.title = NSLocalizedString(@"Сохранить", @"Сохранить");
        [self.editButtonItem setTitleTextAttributes:redText forState:UIControlStateNormal];
        //УВЕЛИЧИВАЕТ SCROLLVIEW ДЛЯ УДОБСТВА РЕДАКТИРОВАНИЯ
        [scrollView setContentSize:CGSizeMake(320, 1100)];
        editCount = 1;
    } else {
        self.editButtonItem.title = NSLocalizedString(@"Изменить", @"Изменить");
        [self.editButtonItem setTitleTextAttributes:blackText forState:UIControlStateNormal]; // textBlack - это макрос определенный в CalcAppDelegate.h
        editCount = 0;
        [scrollView setContentSize:CGSizeMake(320, 900)];
        
        [self saveData];
        
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


- (void)textViewDidBeginEditing:(UITextView *)textView {
    float moveSpeed = 0.4f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:moveSpeed];
    [UIView setAnimationBeginsFromCurrentState:YES];
        
    scrollView.contentOffset = (CGPoint){
        0, // ось x нас не интересует
        CGRectGetMinY(explaneTextView.frame) - 50 // Скроллим скролл к верхней границе текстового поля - Вы можете настроить эту величину по своему усмотрению
    };
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    float moveSpeed = 0.4f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:moveSpeed];
    [UIView setAnimationBeginsFromCurrentState:YES];
    scrollView.contentOffset = (CGPoint){0, 0}; // Возвращаем скролл в начало, так как редактирование текстового поля закончено
    [UIView commitAnimations];
}


//ПОДНИМАЕМ SCROLLVIEW КОГДА ПОДНИМАЕТСЯ КЛАВИАТУРА
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    float moveSpeed = 0.4f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:moveSpeed];
    [UIView setAnimationBeginsFromCurrentState:YES];
    scrollView.contentOffset = (CGPoint) {
        0, CGRectGetMinY(textField.frame) - 20
    };
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    float moveSpeed = 0.4f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:moveSpeed];
    [UIView setAnimationBeginsFromCurrentState:YES];
    scrollView.contentOffset = (CGPoint) {
        0,0
    };
    [UIView commitAnimations];
}

//переход на вспомогательные контроллеры
- (IBAction)Cost:(id)sender {
    [self performSegueWithIdentifier:@"Cost" sender:self];
}

- (IBAction)Email:(id)sender {
    [self performSegueWithIdentifier:@"Email" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
