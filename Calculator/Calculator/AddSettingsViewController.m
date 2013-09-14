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
@synthesize savedAddittionaly;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AddSettingsServise *saved = [[AddSettingsServise alloc] init];
    AddSettingsModel *contaner = [[AddSettingsModel alloc] init];
    
    contaner = saved.Read;
    
    lusterTextField.text = [contaner.lusterPrice stringValue];
    bypassTextField.text = [contaner.bypassPrice stringValue];
    spotTextField.text = [contaner.spotPrice stringValue];
    
    //кнопка редактирования
    UIBarButtonItem *saveButton =[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                  target:self
                                  action:@selector(saveBtn)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveBtn {
    
    AddSettingsModel *addPrice = [[AddSettingsModel alloc] init];
    
    addPrice.lusterPrice = [NSNumber numberWithInt:[lusterTextField.text intValue]];
    addPrice.bypassPrice = [NSNumber numberWithInt:[bypassTextField.text intValue]];
    addPrice.spotPrice = [NSNumber numberWithInt:[spotTextField.text intValue]];
    
    //ПЕРЕДАЕМ ДАННЫЕ В SERVICE
    AddSettingsServise *save = [[AddSettingsServise alloc] init];
    [save Save:addPrice];
    
}
@end
