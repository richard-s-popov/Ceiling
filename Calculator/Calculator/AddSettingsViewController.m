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
    
    lusterTextField.text = contaner.lusterPrice;
    bypassTextField.text = contaner.bypassPrice;
    spotTextField.text = contaner.spotPrice;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SaveSettings:(id)sender {
    
    AddSettingsModel *exampleAddittionaly = [[AddSettingsModel alloc] init];
    
    exampleAddittionaly.lusterPrice = lusterTextField.text;
    exampleAddittionaly.bypassPrice = bypassTextField.text;
    exampleAddittionaly.spotPrice = spotTextField.text;
    
    //ПЕРЕДАЕМ ДАННЫЕ В SERVICE
    AddSettingsServise *save = [[AddSettingsServise alloc] init];
    [save Save:exampleAddittionaly];
    
}
@end
