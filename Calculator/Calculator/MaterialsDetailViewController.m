//
//  MaterialsDetailViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 16.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "MaterialsDetailViewController.h"
@interface MaterialsDetailViewController ()

@end

@implementation MaterialsDetailViewController

@synthesize matName;
@synthesize matPrice;

@synthesize editMaterialName;
@synthesize editMaterialWidth;
@synthesize editMaterialPrice;

@synthesize material;
@synthesize managedObjectContext;


// скрываем клавиатуру по нажатию кнопки
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //пользовательские поля
    [editMaterialName resignFirstResponder];
    [editMaterialWidth resignFirstResponder];
    [editMaterialPrice resignFirstResponder];
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    editMaterialName.delegate = self;
    editMaterialWidth.delegate = self;
    editMaterialPrice.delegate = self;
    
    matName.text = material.matName;
    matPrice.text = [material.matPrice stringValue];
    
    editMaterialName.text = material.matName;
    editMaterialPrice.text = [material.matPrice stringValue];
    editMaterialWidth.text = [material.matWidth stringValue];
    
    //скрываем клавиатуру по нажатию на фон
    UITapGestureRecognizer *tapOnScrolView = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(dismissKeyboard)
                                              ];
    
    [self.view addGestureRecognizer:tapOnScrolView];
        
}


//создаем helper для managedObjectContext
- (NSManagedObjectContext *)managedObjectContext {
    return [(CalcAppDelegate*)[[UIApplication sharedApplication]delegate] managedObjectContext];
}

- (IBAction)saveBtn:(id)sender {
    
    material.matName = editMaterialName.text;
    material.matWidth = [NSNumber numberWithInt:[editMaterialWidth.text intValue]];
    material.matPrice = [NSNumber numberWithInt:[editMaterialPrice.text intValue]];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//метод скрытия клавиатуры по нажитию на background
- (void)dismissKeyboard {
    
    [editMaterialName resignFirstResponder];
    [editMaterialWidth resignFirstResponder];
    [editMaterialPrice resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
