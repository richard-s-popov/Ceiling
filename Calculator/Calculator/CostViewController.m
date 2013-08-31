//
//  CostViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 28.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.


#import "CostViewController.h"


@interface CostViewController ()

@end

@implementation CostViewController
@synthesize lastCost;
@synthesize test;
@synthesize detailProjectData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//принимаем объект проекта из ProjectDetailViewController
- (void)PutSettings:(ProjectModel *)putSettings {
    
    detailProjectData = putSettings;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    luster = [detailProjectData.clientLuster integerValue];
    bypass = [detailProjectData.clientBypass integerValue];
    spot = [detailProjectData.clientSpot integerValue];
    
    //получаем данные дополнительных настроек из AddSettingsServise 
    AddSettingsServise *saved = [[AddSettingsServise alloc] init];
    AddSettingsModel *contanerAddittionaly = [[AddSettingsModel alloc] init];
    contanerAddittionaly = saved.Read;
    
    unsigned lusterPrice = [contanerAddittionaly.lusterPrice integerValue];
    unsigned bypassPrice = [contanerAddittionaly.bypassPrice integerValue];
    unsigned spotPrice = [contanerAddittionaly.spotPrice integerValue];
    
    int lastCostInt = (luster*lusterPrice) + (bypass*bypassPrice) + (spot*spotPrice);
    
    lastCost.text = [NSString stringWithFormat:@"%u", (unsigned)lastCostInt];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
