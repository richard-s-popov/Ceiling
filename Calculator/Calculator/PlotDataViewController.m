//
//  PlotDataViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 29.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "PlotDataViewController.h"
#define textFieldPlotTag 1
#define detailLableTag 2

@interface PlotDataViewController () {
    UITableViewCell *cellSelected;
    UITextField *textFieldSelected;
    UILabel *detailLabel;
    NSArray *sidesList;
    int countOfAngle;
    NSIndexPath *lastWidthIndexPath;
    
}

@end

@implementation PlotDataViewController
@synthesize tableOfSides;
@synthesize managedObjectContext;
@synthesize angleCountOutlet;
//@synthesize countOfAngle;
@synthesize alphabet;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(NSManagedObjectContext*)managedObjectContext {
    return [(CalcAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}


-(void)PullArrayFromCoreData {

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Plot"];
    sidesList = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}


// скрываем клавиатуру по нажатию кнопки
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //пользовательские поля
    [angleCountOutlet resignFirstResponder];
    [textFieldSelected resignFirstResponder];
    
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    angleCountOutlet.delegate = self;
    
//    alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    alphabet = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
                        componentsSeparatedByString:@" "];
    
    [tableOfSides reloadData];
    
    
//    UITapGestureRecognizer *tapOnScrolView = [[UITapGestureRecognizer alloc]
//                                              initWithTarget:self
//                                              action:@selector(dismissKeyboard)
//                                              ];
//    
//    [self.view addGestureRecognizer:tapOnScrolView];
    

}


#pragma mark - table method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return countOfAngle;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *const CellId = @"PlotCell";
    PlotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[PlotCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
    }
    
    
    //заполняем названия сторон
    if (indexPath.row<25) {
        cell.sideName.text = [NSString stringWithFormat:@"%@%@", alphabet[indexPath.row], alphabet[indexPath.row+1]];
        NSLog(@"0 секция");

    }
    else if ((indexPath.row>=25) && (indexPath.row<50)) {
        cell.sideName.text = [NSString stringWithFormat:@"%@%@1", alphabet[indexPath.row-25], alphabet[indexPath.row-24]];
        NSLog(@"1 секция");
    }
    else if ((indexPath.row>=50) && (indexPath.row<75)) {
        cell.sideName.text = [NSString stringWithFormat:@"%@%@2", alphabet[indexPath.row-50], alphabet[indexPath.row-49]];
        NSLog(@"2 секция");

    }
    else if ((indexPath.row>=75) && (indexPath.row<100)) {
        cell.sideName.text = [NSString stringWithFormat:@"%@%@3", alphabet[indexPath.row-75], alphabet[indexPath.row-74]];
        NSLog(@"3 секция");
    }
    else {
        cell.sideName.text = @"че, сдурел?";
    }
    
    
    //получаем массив данных из coreData
    [self PullArrayFromCoreData];
    Plot *plot = [sidesList objectAtIndex:indexPath.row];
    
//    cell.sideWidth.text = [NSString stringWithFormat:@"%@",plot.sideWidth];
    cell.detailWidthLabel.text = [NSString stringWithFormat:@"%@",plot.sideWidth];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    cellSelected = [tableOfSides cellForRowAtIndexPath:indexPath];
    lastWidthIndexPath = indexPath;
    
    textFieldSelected = (UITextField*)[cellSelected viewWithTag:textFieldPlotTag];
    textFieldSelected.hidden = NO;
    [textFieldSelected becomeFirstResponder];
    
    detailLabel = (UILabel*)[cellSelected viewWithTag:detailLableTag];
    detailLabel.hidden = YES;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self deselectMethod];
}


-(void)deselectMethod {
    textFieldSelected.hidden = YES;
    detailLabel.hidden = NO;
    
    [tableOfSides reloadRowsAtIndexPaths:[NSArray arrayWithObject:lastWidthIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self PullArrayFromCoreData];
    Plot *plot = [sidesList objectAtIndex:lastWidthIndexPath.row];
    
    plot.sideWidth = [NSNumber numberWithInt:[textFieldSelected.text intValue]];
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
    }
    
    [tableOfSides deselectRowAtIndexPath:[tableOfSides indexPathForSelectedRow] animated:YES];
    
    [tableOfSides reloadData];
}


- (IBAction)sideWidthField:(id)sender {
    NSLog(@"DONE");
    
//    [tableOfSides reloadData];
}

//- (BOOL)findAndResignFirstResonder:(UIView *)stView {
//    if (stView.isFirstResponder) {
//        [stView resignFirstResponder];
//        return YES;
//    }
//    
//    for (UIView *subView in stView.subviews) {
//        if ([self findAndResignFirstResonder:subView]) {
//            return YES;
//        }
//    }
//    return NO;
//}


- (IBAction)angleCount:(id)sender {
    countOfAngle = [angleCountOutlet.text intValue];
    int count = countOfAngle;
    
    [self PullArrayFromCoreData];
    
    
    //удаляем данные если изменилось колличество углов
    if (sidesList.count!=0) {
        NSLog(@"sidelist");
        while (sidesList.count!=0) {
            [self.managedObjectContext deleteObject:[sidesList objectAtIndex:sidesList.count-1]];
            [self.managedObjectContext save:nil];
            [self PullArrayFromCoreData];
        }
    }
    
    while (count!=0) {
        count--;
        
        //добавляем объект в контекст
        Plot *plotData = [NSEntityDescription insertNewObjectForEntityForName:@"Plot" inManagedObjectContext:self.managedObjectContext];
        
        plotData.sideWidth = [NSNumber numberWithInt:0];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
        }

        
    }
    
    [tableOfSides reloadData];
}

- (IBAction)doneSides:(id)sender {
    [self deselectMethod];
}


- (void)dismissKeyboard {
    
    [angleCountOutlet resignFirstResponder];
    [textFieldSelected resignFirstResponder];
//    [self findAndResignFirstResonder: self.view];
    
}


-(IBAction)closeKeyboard:(id)sender
{
    
    [angleCountOutlet resignFirstResponder];
    [textFieldSelected resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
