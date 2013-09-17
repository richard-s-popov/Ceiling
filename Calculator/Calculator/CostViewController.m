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

@synthesize managedObjectContext;
@synthesize addPrice;
@synthesize project;

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
    
//    detailProjectData = putSettings;
    
}

-(NSManagedObjectContext *)managedObjectContext {
    return [(CalcAppDelegate *)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    luster = [project.projectLuster integerValue];
    bypass = [project.projectBypass integerValue];
    spot = [project.projectSpot integerValue];
    
    //получаем данные по AddPrice из Core Data
    NSFetchRequest *fetchRequestAddPrice = [NSFetchRequest fetchRequestWithEntityName:@"AddPrice"];
    NSError *error = nil;
    NSArray *addPriceArray = [self.managedObjectContext executeFetchRequest:fetchRequestAddPrice error:&error];
    
    if (addPriceArray.count != 0) {
        addPrice = [addPriceArray objectAtIndex:0];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Пожалуста, отредактируйте цены в дополнительных настройках" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    unsigned lusterPrice = [addPrice.lusterPrice integerValue];
    unsigned bypassPrice = [addPrice.bypassPrice integerValue];
    unsigned spotPrice = [addPrice.spotPrice integerValue];
    
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
