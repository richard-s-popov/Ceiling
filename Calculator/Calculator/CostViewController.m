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
    unsigned kantPrice;
    
    BOOL kantIsChecked;
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
@synthesize material;

@synthesize materialsArray;
@synthesize pickerView;

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
    
    //запускаем скроллер
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 650)];
    
    lusterField.delegate = self;
    bypassField.delegate = self;
    spotField.delegate = self;
    
    kantIsChecked = [plot.isCheckKant boolValue];
    [self checkKantCondition];
    
    
    [self populateFields];
    
    
    //получаем массив материалов
    NSFetchRequest *fetchRequestMaterial = [NSFetchRequest fetchRequestWithEntityName:@"Materials"];
    NSError *error = nil;
    NSArray *tmpMaterialsArray = [self.managedObjectContext executeFetchRequest:fetchRequestMaterial error:&error];
    //сортаруем материалы по названию
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"matName" ascending:YES];
    NSArray *tmpMatArray = [NSArray arrayWithObject:sortDescriptor];
    materialsArray = [tmpMaterialsArray sortedArrayUsingDescriptors:tmpMatArray];

    
    //получаем данные по AddPrice из Core Data
    NSFetchRequest *fetchRequestAddPrice = [NSFetchRequest fetchRequestWithEntityName:@"AddPrice"];
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
    kantPrice = [addPrice.kantPrice integerValue];
    
    [self calculateAll];
    
    //добавляем кнопку готово в тулбар
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
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc] initWithCustomView:saveButtonToolbar],
                           nil];
    [numberToolbar sizeToFit];
    
    lusterField.inputAccessoryView = numberToolbar;
    bypassField.inputAccessoryView = numberToolbar;
    spotField.inputAccessoryView = numberToolbar;
    
    
    //предустановка положения pickerView
    if (plot.plotMaterial) {
        
        int indexMaterial = [materialsArray indexOfObject:plot.plotMaterial];
        [pickerView selectRow:indexMaterial inComponent:0 animated:YES];
        
        [self calculateAll];
    }
}


#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [materialsArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    NSString *nameOfMaterial = [NSString stringWithFormat:@"%@ - %@",[[materialsArray objectAtIndex:row] matName], [[materialsArray objectAtIndex:row] matWidth]];
    return nameOfMaterial;
}


#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    
    material = [materialsArray objectAtIndex:row];
    plot.plotMaterial = material;
    [self calculateAll];
}


-(void)populateFields {
    
    lusterField.text = [plot.lusterCount stringValue];
    bypassField.text = [plot.bypassCount stringValue];
    spotField.text = [plot.spotCount stringValue];
    
    //подтягиваем площадь и периметр
    float square = [plot.plotSquare floatValue];
    float perimetr = [plot.plotPerimetr floatValue];
    float curve = [plot.plotCurve floatValue];
    squareLabel.text = [NSString stringWithFormat:@"%1.2f м.кв.", square];
    perimetrLabel.text = [NSString stringWithFormat:@"%1.2f м.", perimetr];
    curveLabel.text = [NSString stringWithFormat:@"%1.2f м.", curve];
}


-(void)calculateAll {
    
    unsigned lusterCount = [plot.lusterCount integerValue];
    unsigned bypassCount = [plot.bypassCount integerValue];
    unsigned spotCount = [plot.spotCount integerValue];
    
    //считаем дополнительные параметры
    lastCostInt = (lusterCount*lusterPrice) + (bypassCount*bypassPrice) + (spotCount*spotPrice);
    //считаем стоимость полотна
    float squarePrice = [plot.plotSquare floatValue] * [plot.plotMaterial.matPrice floatValue];
    
    //считаем кантик
    float cantikPrice = 0;
    if (!kantIsChecked) {
        cantikPrice = 0;
    }
    else if (kantIsChecked) {
        cantikPrice = [plot.plotPerimetr floatValue]*kantPrice;
    }
    
    //для криволинейного участка
    int curvePrice = [addPrice.curvePrice intValue];
    float curveCost = [plot.plotCurve floatValue]*curvePrice;
    
    //считаем итого
    float price = lastCostInt + squarePrice + cantikPrice + curveCost;
    
    plot.plotPrice = [NSNumber numberWithFloat:price];
    lastCost.text = [NSString stringWithFormat:@"%1.2f руб.", price];
    
    //считаем стоимость проекта
    NSArray *plotArray = [project.projectPlot allObjects];
    int countPlot = 0;
    project.projectPrice = 0;
    float projectPrice = 0;
    while (countPlot != plotArray.count) {
        
        NSNumber *plotPrice = [[plotArray objectAtIndex:countPlot] plotPrice];
        projectPrice = projectPrice + [plotPrice floatValue];
        
        countPlot++;
    }
    
    project.projectPrice = [NSNumber numberWithInt:projectPrice];
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

- (IBAction)pickMaterial:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)kantCheckBox:(id)sender {
    
    if (!kantIsChecked) {
        UIImage *checkBoxBg = [[UIImage imageNamed:@"checkbox.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [checkBoxKant setBackgroundImage:checkBoxBg forState:UIControlStateNormal];
        kantIsChecked = YES;
        [self calculateAll];
    }
    else if (kantIsChecked) {
        UIImage *checkBoxUnBg = [[UIImage imageNamed:@"checkbox_unabled.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [checkBoxKant setBackgroundImage:checkBoxUnBg forState:UIControlStateNormal];
        kantIsChecked = NO;
        [self calculateAll];
    }
}


-(void) checkKantCondition {

    if (!kantIsChecked) {
        UIImage *checkBoxUnBg = [[UIImage imageNamed:@"checkbox_unabled.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [checkBoxKant setBackgroundImage:checkBoxUnBg forState:UIControlStateNormal];
    }
    else if (kantIsChecked) {
        UIImage *checkBoxBg = [[UIImage imageNamed:@"checkbox.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [checkBoxKant setBackgroundImage:checkBoxBg forState:UIControlStateNormal];
    }
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
