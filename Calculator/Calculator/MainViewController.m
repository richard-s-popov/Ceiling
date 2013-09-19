//
//  MainViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 10.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "MainViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"

@interface MainViewController ()

@end


@implementation MainViewController
@synthesize navigationBar;

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

    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//экшн на нажинтие кнопки меню



- (IBAction)menuBtn:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}


@end
