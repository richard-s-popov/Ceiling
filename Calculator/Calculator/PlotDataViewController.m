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
    NSArray *plotList;
    NSArray *diagonalList;
    int countOfAngle;
    NSIndexPath *lastWidthIndexPath;
    
}

@end

@implementation PlotDataViewController
@synthesize tableOfSides;
@synthesize managedObjectContext;
@synthesize angleCountOutlet;
@synthesize alphabet;
@synthesize scrollView;
@synthesize diagonalName;
@synthesize diagonalWidth;


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


-(void)PullSidesFromCoreData {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PlotSide"];
    sidesList = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}
-(void)PullPlotFromCoreData {
    NSFetchRequest *plotFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Plot"];
    plotList = [self.managedObjectContext executeFetchRequest:plotFetchRequest error:nil];
}
-(void)PullDiagonalFromCoreData {
    NSFetchRequest *diagonalFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PlotDiagonal"];
    diagonalList = [self.managedObjectContext executeFetchRequest:diagonalFetchRequest error:nil];
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
    
    //запускаем скроллер
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 1050)];
    
    angleCountOutlet.delegate = self;
    
//    alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    alphabet = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
                        componentsSeparatedByString:@" "];
    
    [tableOfSides reloadData];
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
    
    //получаем массив данных из coreData
    [self PullSidesFromCoreData];
    [self PullPlotFromCoreData];
    PlotSide *plot;
    if (sidesList.count != 0) {
        plot = [sidesList objectAtIndex:indexPath.row];
    }
    
    //условия для определения букв угла
    int angleCicle;
    
    if (indexPath.row+1<26) {angleCicle = 0;} //A-Z
    
    else if (indexPath.row+1 == 26){angleCicle = 26;}//условие для угла ZA1
    
    else if ((indexPath.row+1>26) && (indexPath.row+1<52)) {angleCicle = 1;} //A1-Z1
    
    else if (indexPath.row+1 == 52){angleCicle = 52;} //условие для угла Z1A2
    
    else if ((indexPath.row+1>=51) && (indexPath.row+1<76)){angleCicle = 2;} //A2-Z2
    
    else if (indexPath.row+1 == 76) {angleCicle = 76;} //условние для угла Z2A3
    
    else if ((indexPath.row+1>=76) && (indexPath.row+1<102)){angleCicle = 3;} //A3-Z3
    
    else {angleCicle = 4;} //условие для чесдурел
    
    
    //даем имя углу
//    switch (angleCicle) {
//        case 0:
//            cell.sideName.text = [NSString stringWithFormat:@"%@%@", alphabet[indexPath.row], alphabet[indexPath.row+1]];
//            plot.sideName = cell.sideName.text;
//            break;
//        case 1:
//            cell.sideName.text = [NSString stringWithFormat:@"%@1%@1", alphabet[indexPath.row-26], alphabet[indexPath.row-25]];
//            plot.sideName = cell.sideName.text;
//            break;
//        case 2:
//            cell.sideName.text = [NSString stringWithFormat:@"%@2%@2", alphabet[indexPath.row-52], alphabet[indexPath.row-51]];
//            plot.sideName = cell.sideName.text;
//            break;
//        case 3:
//            cell.sideName.text = [NSString stringWithFormat:@"%@3%@3", alphabet[indexPath.row-76], alphabet[indexPath.row-75]];
//            plot.sideName = cell.sideName.text;
//            break;
//        case 4:
//            cell.sideName.text = @"чесдурел?";
//            plot.sideName = cell.sideName.text;
//            break;
//        case 26:
//            cell.sideName.text = @"ZA1";
//            plot.sideName = cell.sideName.text;
//            break;
//        case 52:
//            cell.sideName.text = @"Z1A2";
//            plot.sideName = cell.sideName.text;
//            break;
//        case 76:
//            cell.sideName.text = @"Z2A3";
//            plot.sideName = cell.sideName.text;
//            break;
//        default:
//            break;
//    }
    
//    cell.sideWidth.text = [NSString stringWithFormat:@"%@",plot.sideWidth];
    cell.detailWidthLabel.text = [NSString stringWithFormat:@"%@",plot.sideWidth];
    
    //сохраняем контекст для сохранения названий сторон
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
    }
    
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


//изменяем длинну стороны
-(void)deselectMethod {
    textFieldSelected.hidden = YES;
    detailLabel.hidden = NO;
    
    [tableOfSides reloadRowsAtIndexPaths:[NSArray arrayWithObject:lastWidthIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self PullSidesFromCoreData];
    PlotSide *plotSide = [sidesList objectAtIndex:lastWidthIndexPath.row];
    
    plotSide.sideWidth = [NSNumber numberWithInt:[textFieldSelected.text intValue]];
    
    
    //коммитим контекст
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
    }
    
    [tableOfSides deselectRowAtIndexPath:[tableOfSides indexPathForSelectedRow] animated:YES];
    
    [tableOfSides reloadData];
}


- (IBAction)generateAngle:(id)sender {
    countOfAngle = [angleCountOutlet.text intValue];
    int count = countOfAngle;
    
    [self PullSidesFromCoreData];
    [self PullPlotFromCoreData];
    
    //удаляем данные если изменилось колличество углов
    if (sidesList.count!=0) {
        //удаляем всю сущность Plot вместе с ней удаляется и PlotSide (усатновки моделей Core Data)
        [self.managedObjectContext deleteObject:[plotList lastObject]];
    }
    
    Plot *newPlot = [NSEntityDescription insertNewObjectForEntityForName:@"Plot" inManagedObjectContext:self.managedObjectContext];
    
    while (count!=0) {
        count--;
        
        //добавляем объект PlotSide в контекст
        PlotSide *plotData = [NSEntityDescription insertNewObjectForEntityForName:@"PlotSide" inManagedObjectContext:self.managedObjectContext];
        
        plotData.sideWidth = [NSNumber numberWithInt:0];
        
        //добавляем объект PlotSide в Plot
        [newPlot addPlotSideObject:plotData];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
        }
    }
    
    [tableOfSides reloadData];
    [angleCountOutlet resignFirstResponder];
    
}

- (IBAction)saveDiagonal:(id)sender {
    
    [self PullDiagonalFromCoreData];
    [self PullPlotFromCoreData];
    PlotDiagonal *diagonal = [NSEntityDescription insertNewObjectForEntityForName:@"PlotDiagonal" inManagedObjectContext:self.managedObjectContext];
//    diagonal.diagonalName = diagonalName.text;
    diagonal.diagonalWidth = [NSNumber numberWithInt:[diagonalWidth.text intValue]];
    Plot *existPlot = [plotList lastObject];
    [existPlot addPlotDiagonalObject:diagonal];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
    }
    
    diagonalName.text = @"";
    diagonalWidth.text = @"";
    [diagonalName becomeFirstResponder];
}

- (IBAction)endDiagonal:(id)sender {
    [self PullDiagonalFromCoreData];
    [self PullPlotFromCoreData];
    
    if ((![diagonalName.text isEqual:@""]) && (diagonalName.text != nil)) {
        
        PlotDiagonal *diagonal = [NSEntityDescription insertNewObjectForEntityForName:@"PlotDiagonal" inManagedObjectContext:self.managedObjectContext];
//        diagonal.diagonalName = diagonalName.text;
        diagonal.diagonalWidth = [NSNumber numberWithInt:[diagonalWidth.text intValue]];
        Plot *existPlot = [plotList lastObject];
        [existPlot addPlotDiagonalObject:diagonal];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
        }
        
        NSLog(@"Name not nil");
    }
    
    
    diagonalName.text = @"";
    diagonalWidth.text = @"";
    [diagonalName resignFirstResponder];
}

- (IBAction)sideWidthField:(id)sender {
    NSLog(@"DONE");
}


- (IBAction)angleCount:(id)sender {
    
}

- (IBAction)doneSides:(id)sender {
    [self deselectMethod];
    
    [self PullPlotFromCoreData];
    Plot *lastPlot = [plotList lastObject];
    NSArray *array = [lastPlot.plotSide allObjects];
    NSLog(@"array: %@", array);
}


- (IBAction)clearData:(id)sender {
    [self PullPlotFromCoreData];
    [self.managedObjectContext deleteObject:[plotList lastObject]];
    [self.managedObjectContext save:nil];
    [tableOfSides reloadData];
}


- (void)dismissKeyboard {
    
    [angleCountOutlet resignFirstResponder];
    [textFieldSelected resignFirstResponder];
}


-(IBAction)closeKeyboard:(id)sender
{
    
    [angleCountOutlet resignFirstResponder];
    [textFieldSelected resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
