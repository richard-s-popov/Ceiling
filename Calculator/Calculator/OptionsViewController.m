//
//  OptionsViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 13.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "OptionsViewController.h"
#import "ECSlidingViewController.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController

@synthesize menuBtn;


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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
//    CustomNavigationBar
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//экшн на нажинтие кнопки меню

- (IBAction)optMenuBtn:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}

@end
