//
//  NewPlotViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 21.10.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "NewPlotViewController.h"

@interface NewPlotViewController () {

    NSArray *plotList;
    NSArray *sidesList;
    NSArray *newArraySides;
    BOOL *_cellSwiped;
    UITextField *angleCountField;
    int countOfSides;
    Plot *newPlot;
    PlotSide *newSide;
    NSArray *alphabet;
    NSObject *object;
}

@end

@implementation NewPlotViewController
@synthesize tableOfSides;
@synthesize managedObjectContext;
@synthesize PlotView;
@synthesize diagonal;


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


// скрываем клавиатуру по нажатию кнопки
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //пользовательские поля
    [angleCountField resignFirstResponder];
    
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //кнопки меню бара
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.editButtonItem.title = @"Изменить";
    
    [self PullSidesFromCoreData];
    
    countOfSides = 0;
    alphabet = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
                componentsSeparatedByString:@" "];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(200, 7, 100, 30);
    button.titleLabel.text = @"Готово";
    button.titleLabel.textColor = [UIColor blackColor];
    [button setTitle:@"Готово" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(generatesSides) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 1;
    [tableOfSides addSubview:button];
    
    angleCountField = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, 100, 30)];
    angleCountField.borderStyle = UITextBorderStyleRoundedRect;
    angleCountField.placeholder = @"к-во углов";
    [tableOfSides addSubview:angleCountField];
    
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return newArraySides.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlotList";
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    PlotSide *side = [newArraySides objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", side.angleFirst, side.angleSecond];
    cell.detailTextLabel.text = @"не назначено";
    
    return cell;
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *result  =nil;
    if (section == 0) {
        result = @" ";
    } else {
        result = @" ";
    }
    return result;
}


-(void)generatesSides {
    countOfSides = [angleCountField.text intValue];
    [self PullPlotFromCoreData];
    newPlot = [NSEntityDescription insertNewObjectForEntityForName:@"Plot" inManagedObjectContext:self.managedObjectContext];
    newPlot.plotName = [NSString stringWithFormat:@"PlotOf%dSides", countOfSides];
    
    
    //создаем все стороны и диагонали основываясь на колличестве углов
    //начинаются названия
    int countTmp = 0;
    while (countTmp != countOfSides) {
        
                    //создаем новый объект-сторону Core Data
        newSide = [NSEntityDescription insertNewObjectForEntityForName:@"PlotSide" inManagedObjectContext:self.managedObjectContext];
        
        //условия для определения букв угла
        //условия для case
        int angleCicle;
        if (countTmp+1<26) {angleCicle = 0;} //A-Z
        else if (countTmp+1 == 26){angleCicle = 26;}                            //условие для угла ZA1
        else if ((countTmp+1>26) && (countTmp+1<52)) {angleCicle = 1;}          //A1-Z1
        else if (countTmp+1 == 52){angleCicle = 52;}                            //условие для угла Z1A2
        else if ((countTmp+1>=51) && (countTmp+1<76)){angleCicle = 2;}          //A2-Z2
        else if (countTmp+1 == 76) {angleCicle = 76;}                           //условние для угла Z2A3
        else if ((countTmp+1>=76) && (countTmp+1<102)){angleCicle = 3;}         //A3-Z3
        else {angleCicle = 4;}                                                  //условие для чесдурел
        
        //даем имя стороне
        switch (angleCicle) {
            case 0:
                newSide.angleFirst = [NSString stringWithFormat:@"%@", alphabet[countTmp]];
                newSide.angleSecond = [NSString stringWithFormat:@"%@", alphabet[countTmp+1]];
//                cell.textLabel.text = [NSString stringWithFormat:@"%@%@", newSide.angleFirst, newSide.angleSecond];
                break;
            case 1:
                newSide.angleFirst = [NSString stringWithFormat:@"%@1", alphabet[countTmp-26]];
                newSide.angleSecond = [NSString stringWithFormat:@"%@1", alphabet[countTmp-25]];
                break;
            case 2:
                newSide.angleFirst = [NSString stringWithFormat:@"%@2", alphabet[countTmp-52]];
                newSide.angleSecond = [NSString stringWithFormat:@"%@2", alphabet[countTmp-51]];
                break;
            case 3:
                newSide.angleFirst = [NSString stringWithFormat:@"%@3", alphabet[countTmp-76]];
                newSide.angleSecond = [NSString stringWithFormat:@"%@3", alphabet[countTmp-75]];
                break;
            case 4:
                newSide.angleFirst = @"перебор углов";
                newSide.angleFirst = @"углов";
                break;
            case 26:
                newSide.angleFirst = @"Z";
                newSide.angleSecond = @"A1";
                break;
            case 52:
                newSide.angleFirst = @"Z1";
                newSide.angleSecond = @"A2";
                break;
            case 76:
                newSide.angleFirst = @"Z2";
                newSide.angleSecond = @"A3";
                break;
            default:
                break;
        }
        
        [newPlot addPlotSideObject:newSide];
        
        //сохраняем контекст именно сразу после создания каждой стороны, что-бы в базе они шли по порядку
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
        }
        
        countTmp++;
    }
    
    
    //создаем массив из сторон этого чертежа
    //сортируем этот массив по первому углу
    newArraySides = [newPlot.plotSide allObjects];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"angleFirst" ascending:YES]];
//    newArraySides = [[newPlot.plotSide allObjects] sortedArrayUsingDescriptors:sortDescriptors];
    
//    //создаем изменяемый массив для создания диагоналей
//    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:newArraySides];
//    
//    //создаем все диагонали
//    int sidesCount = 0;
//    while (sidesCount != mutableArray.count) {
//        
//        //извлекаем объект сторону из отсортированного массива
//        PlotSide *sideFirst = [mutableArray objectAtIndex:0];
//        
//        NSLog(@"sideFirst - %@%@", sideFirst.angleFirst, sideFirst.angleSecond);
//        
//        //создаем все возможные диагонали для первого угла этой стороны
//        //так как диагоналей от одного угла меньше чем  колличество сторон
//        int diagonalCount = 0;
//        while (diagonalCount < (mutableArray.count-3)) {
//            
//            PlotSide *sideSecond = [mutableArray objectAtIndex:diagonalCount+2];
//            
//            NSLog(@"seideSecond - %@%@", sideSecond.angleFirst, sideSecond.angleSecond);
//            
//            diagonal = [NSEntityDescription insertNewObjectForEntityForName:@"PlotDiagonal" inManagedObjectContext:self.managedObjectContext];
//            diagonal.diagonalName = [NSString stringWithFormat:@"%@%@", sideFirst.angleFirst, sideSecond.angleFirst];
//            
//            [newPlot addPlotDiagonalObject:diagonal];
//            
//            NSLog(@"diagonal - %@", diagonal.diagonalName);
//            
//            diagonalCount++;
//        }
//        
//        [mutableArray removeObjectAtIndex:0];
//        [mutableArray addObject:sideFirst];
//        
//        sidesCount++;
//    }
//    
//    //сохраняем контекст
//    if (![self.managedObjectContext save:&error]) {
//    }
    
    [angleCountField resignFirstResponder];
    [tableOfSides reloadData];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"sidesDiagonalsSegue"]) {
        PlotDiagonalViewController *detailPlot = segue.destinationViewController;
        detailPlot.side = [newArraySides objectAtIndex:tableOfSides.indexPathForSelectedRow.row];
        detailPlot.plot = newPlot;
        
        //необходимо для условия для перезагрузки ячейки таблицы при изменении
//        lustName = [[list objectAtIndex:tbl.indexPathForSelectedRow.row] matName];
//        lustWidth = [[list objectAtIndex:tbl.indexPathForSelectedRow.row] matWidth];
//        lustPrice = [[list objectAtIndex:tbl.indexPathForSelectedRow.row] matPrice];
//        
//        indexPathSegue = tbl.indexPathForSelectedRow;
//        indexPathRow = indexPathSegue.row;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
