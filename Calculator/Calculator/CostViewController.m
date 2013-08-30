//
//  CostViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 28.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "CostViewController.h"

@interface CostViewController ()

@end

@implementation CostViewController
@synthesize lastCost;

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
    
    
    //ИЗВЛЕКАЕМ СОХРАНЕННЫЕ ДАННЫЕ
    
    ProjectModel *projectExemplar = [[ProjectModel alloc] init];
    
    NSUserDefaults *projects = [NSUserDefaults standardUserDefaults];
    [projectExemplar setClientId:[projects objectForKey:@"lustProject"]];
    [projectExemplar setClientLuster:[projects objectForKey:[NSString stringWithFormat:@"clientLuster%@",projectExemplar.clientId]]];
    [projectExemplar setClientBypass:[projects objectForKey:[NSString stringWithFormat:@"clientBypass%@",projectExemplar.clientId]]];
    [projectExemplar setClientSpot:[projects objectForKey:[NSString stringWithFormat:@"clientSpot%@",projectExemplar.clientId]]];

    
    //калькулятор
    luster = [projectExemplar.clientLuster integerValue];
    bypass = [projectExemplar.clientBypass integerValue];
    spot = [projectExemplar.clientSpot integerValue];
    
    int lastCostInt = (luster*350) + (bypass*150) + (spot*200);
    
    lastCost.text = [NSString stringWithFormat:@"%u", (unsigned)lastCostInt];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
