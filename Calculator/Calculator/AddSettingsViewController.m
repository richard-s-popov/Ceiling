//
//  AddSettingsViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 31.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "AddSettingsViewController.h"

@interface AddSettingsViewController ()

@end

@implementation AddSettingsViewController
@synthesize lusterTextField;
@synthesize bypassTextField;
@synthesize spotTextField;
@synthesize kantTextField;

@synthesize managedObjectContext;
@synthesize addPrice;
@synthesize fetchArray;
@synthesize managedObjectId;

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
    
    //пользовательские поля
    [lusterTextField resignFirstResponder];
    [bypassTextField resignFirstResponder];
    [spotTextField resignFirstResponder];
    [kantTextField resignFirstResponder];
    
    return YES;
}

-(NSManagedObjectContext *)managedObjectContext {
    return [(CalcAppDelegate *)[[UIApplication sharedApplication]delegate] managedObjectContext];
}

- (void)fetchPull {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AddPrice"];
    NSError *error = nil;
    
    fetchArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fetchPull];
    
    lusterTextField.delegate = self;
    bypassTextField.delegate = self;
    spotTextField.delegate = self;
    kantTextField.delegate = self;
    
    if (fetchArray.count == 0) {
        addPrice = [NSEntityDescription insertNewObjectForEntityForName:@"AddPrice" inManagedObjectContext:self.managedObjectContext];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
        }
        
        [self fetchPull];
    }
    
    
    addPrice = [fetchArray objectAtIndex:0];
    if (addPrice != nil) {
        lusterTextField.text = [addPrice.lusterPrice stringValue];
        bypassTextField.text = [addPrice.bypassPrice stringValue];
        spotTextField.text = [addPrice.spotPrice stringValue];
        kantTextField.text  = [addPrice.kantPrice stringValue];
    }
    else {
        lusterTextField.text = @"";
        bypassTextField.text = @"";
        spotTextField.text = @"";
        kantTextField.text = @"";
    }
    
    //скрываем клавиатуру по нажатию на фон
    UITapGestureRecognizer *tapOnScrolView = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(dismissKeyboard)
                                              ];
    
    [self.view addGestureRecognizer:tapOnScrolView];
    
    //кнопка сохранения
    UIBarButtonItem *saveButton =[[UIBarButtonItem alloc] initWithTitle:@"Сохранить" style:UIBarButtonItemStyleBordered target:self action:@selector(saveBtn)];
    [saveButton setTitleTextAttributes:redText forState:UIControlStateNormal];
    UIImage *rightButtonImage = [[UIImage imageNamed:@"rightBtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 23, 0, 6)];
    [saveButton setBackgroundImage:rightButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveBtn {
    
    addPrice = [fetchArray objectAtIndex:0];
    addPrice.lusterPrice = [NSNumber numberWithInt:[lusterTextField.text intValue]];
    addPrice.bypassPrice = [NSNumber numberWithInt:[bypassTextField.text intValue]];
    addPrice.spotPrice = [NSNumber numberWithInt:[spotTextField.text intValue]];
    addPrice.kantPrice = [NSNumber numberWithInt:[kantTextField.text intValue]];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
    }

    [self.navigationController popViewControllerAnimated:YES];
}

//метод скрытия клавиатуры по нажитию на background
- (void)dismissKeyboard {
    
    [lusterTextField resignFirstResponder];
    [bypassTextField resignFirstResponder];
    [spotTextField resignFirstResponder];
    [kantTextField resignFirstResponder];
}

@end
