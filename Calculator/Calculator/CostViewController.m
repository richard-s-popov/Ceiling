//
//  CostViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 28.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.


#import "CostViewController.h"


@interface CostViewController () {
    unsigned lusterPrice;
    unsigned bypassPrice;
    unsigned spotPrice;
}

@end

@implementation CostViewController
@synthesize lastCost;
@synthesize test;

@synthesize managedObjectContext;
@synthesize addPrice;
@synthesize project;
@synthesize plot;
@synthesize lastCostInt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSManagedObjectContext *)managedObjectContext {
    return [(CalcAppDelegate *)[[UIApplication sharedApplication]delegate]managedObjectContext];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lusterField.delegate = self;
    bypassField.delegate = self;
    spotField.delegate = self;
    
    [self populateFields];
    
    
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
    
    lusterPrice = [addPrice.lusterPrice integerValue];
    bypassPrice = [addPrice.bypassPrice integerValue];
    spotPrice = [addPrice.spotPrice integerValue];
    
    [self calculateAll];
    
    //добвляем кнопки для NumPad
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"Отмена" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont fontWithName:@"FuturisCyrillic" size:14.0f];
//    [button.layer setCornerRadius:4.0f];
//    [button.layer setMasksToBounds:YES];
//    [button.layer setBorderWidth:1.0f];
//    [button.layer setBorderColor: [[UIColor grayColor] CGColor]];
//    button.frame=CGRectMake(0.0, 100.0, 70.0, 30.0);
//    [button addTarget:self action:@selector(cancelNumberPad)  forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *saveButtonToolbar = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButtonToolbar setTitle:@"Готово" forState:UIControlStateNormal];
    saveButtonToolbar.titleLabel.font = [UIFont fontWithName:@"FuturisCyrillic" size:14.0f];
    [saveButtonToolbar.layer setCornerRadius:4.0f];
    [saveButtonToolbar.layer setMasksToBounds:YES];
    [saveButtonToolbar.layer setBorderWidth:1.0f];
    [saveButtonToolbar.layer setBorderColor: [[UIColor grayColor] CGColor]];
    saveButtonToolbar.frame=CGRectMake(0.0, 100.0, 100.0, 30.0);
    [saveButtonToolbar addTarget:self action:@selector(calculateTextField:)  forControlEvents:UIControlEventTouchUpInside];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackOpaque;
    numberToolbar.items = [NSArray arrayWithObjects:
                           //                           [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNamePlot)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           //                           [[UIBarButtonItem alloc]initWithTitle:@"Сохранить" style:UIBarButtonItemStyleDone target:self action:@selector(doneNamePlot)],
                           [[UIBarButtonItem alloc] initWithCustomView:saveButtonToolbar],
                           nil];
    [numberToolbar sizeToFit];
    
    lusterField.inputAccessoryView = numberToolbar;
    bypassField.inputAccessoryView = numberToolbar;
    spotField.inputAccessoryView = numberToolbar;
    
	// Do any additional setup after loading the view.
}


-(void)populateFields {
    lusterField.text = [plot.lusterCount stringValue];
    bypassField.text = [plot.bypassCount stringValue];
    spotField.text = [plot.spotCount stringValue];
}


-(void)calculateAll {
    unsigned lusterCount = [plot.lusterCount integerValue];
    unsigned bypassCount = [plot.bypassCount integerValue];
    unsigned spotCount = [plot.spotCount integerValue];
    
    lastCostInt = (lusterCount*lusterPrice) + (bypassCount*bypassPrice) + (spotCount*spotPrice);
    plot.plotPrice = [NSNumber numberWithInt:lastCostInt];
    
    lastCost.text = [NSString stringWithFormat:@"%@ руб.", plot.plotPrice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calculateTextField:(id)sender {
    plot.lusterCount = [NSNumber numberWithInt:[lusterField.text intValue]];
    plot.bypassCount = [NSNumber numberWithInt:[bypassField.text intValue]];
    plot.spotCount = [NSNumber numberWithInt:[spotField.text intValue]];
    
    [lusterField resignFirstResponder];
    [bypassField resignFirstResponder];
    [spotField resignFirstResponder];
    
    [self calculateAll];
}


-(void)viewWillDisappear:(BOOL)animated {
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
    }
}


// скрываем клавиатуру по нажатию кнопки
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //вызов метода скрытия клавиатуры
    [textField resignFirstResponder];
    return YES;
}


@end
