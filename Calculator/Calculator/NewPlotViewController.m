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
    BOOL *_cellSwiped;
    UITextField *angleCountField;
    int countOfSides;
    Plot *newPlot;
    PlotSide *newSide;
    NSArray *alphabet;
    NSObject *object;
    UIButton *button;
    UIButton *saveButton;
    NSIndexPath *indexPathForSelectedRow;
}

@end

@implementation NewPlotViewController
@synthesize tableOfSides;
@synthesize managedObjectContext;
@synthesize PlotView;
@synthesize diagonal;
@synthesize mutableArraySides;
@synthesize sidesView;
@synthesize sidesConteinerView;


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
    mutableArraySides = [[NSMutableArray alloc] init];
    
    countOfSides = 0;
    alphabet = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
                componentsSeparatedByString:@" "];
    
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(120, 7, 80, 30);
    button.titleLabel.text = @"Готово";
    button.titleLabel.textColor = [UIColor blackColor];
    [button setTitle:@"Готово" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(generatesSides) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 1;
    [sidesConteinerView addSubview:button];
    
    saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame = CGRectMake(220, 7, 80, 30);
    saveButton.titleLabel.text = @"save";
    saveButton.titleLabel.textColor = [UIColor blackColor];
    [saveButton setTitle:@"save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAll) forControlEvents:UIControlEventTouchUpInside];
    saveButton.tag = 3;
    [sidesConteinerView addSubview:saveButton];
    
    angleCountField = [[UITextField alloc] initWithFrame:CGRectMake(15, 7, 100, 30)];
    angleCountField.borderStyle = UITextBorderStyleRoundedRect;
    angleCountField.placeholder = @"к-во углов";
    angleCountField.keyboardType = UIKeyboardTypeNumberPad;
    [sidesConteinerView addSubview:angleCountField];
    
    
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
    return countOfSides;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlotList";
    
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    newSide = [mutableArraySides objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", newSide.angleFirst, newSide.angleSecond];
    cell.detailTextLabel.text = [newSide.sideWidth stringValue];
    
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
    
    int countTmp = 0;
    while (countTmp != countOfSides) {
        newSide = [NSEntityDescription insertNewObjectForEntityForName:@"PlotSide" inManagedObjectContext:self.managedObjectContext];
        
        //условия для определения букв угла
        //условия для case
        int angleCicle;
        if (countTmp+1<26) {angleCicle = 0;}                                            //A-Z
        else if (countTmp+1 == 26){angleCicle = 26;}                                    //условие для угла ZA1
        else if ((countTmp+1>26) && (countTmp+1<52)) {angleCicle = 1;}                  //A1-Z1
        else if (countTmp+1 == 52){angleCicle = 52;}                                    //условие для угла Z1A2
        else if ((countTmp+1>=51) && (countTmp+1<76)){angleCicle = 2;}                  //A2-Z2
        else if (countTmp+1 == 76) {angleCicle = 76;}                                   //условние для угла Z2A3
        else if ((countTmp+1>=76) && (countTmp+1<102)){angleCicle = 3;}                 //A3-Z3
        else {angleCicle = 4;}                                                          //условие для чесдурел
        
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
        
        if (countTmp == countOfSides-1) {
            newSide.angleSecond = @"A";
        }
        
        [mutableArraySides addObject:newSide];
        [newPlot addPlotSideObject:newSide];
        
        countTmp++;
    }
    

    [angleCountField resignFirstResponder];
    angleCountField.enabled = NO;
    button.enabled = NO;
    [tableOfSides reloadData];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"sidesDiagonalsSegue"]) {
        PlotDiagonalViewController *detailPlot = segue.destinationViewController;
        detailPlot.side = [mutableArraySides objectAtIndex:tableOfSides.indexPathForSelectedRow.row];

        detailPlot.plot = newPlot;
        detailPlot.mutableArray = mutableArraySides;
        detailPlot.index = tableOfSides.indexPathForSelectedRow.row;
        
        indexPathForSelectedRow = tableOfSides.indexPathForSelectedRow;
        
        //необходимо для условия для перезагрузки ячейки таблицы при изменении
//        lustName = [[list objectAtIndex:tbl.indexPathForSelectedRow.row] matName];
//        lustWidth = [[list objectAtIndex:tbl.indexPathForSelectedRow.row] matWidth];
//        lustPrice = [[list objectAtIndex:tbl.indexPathForSelectedRow.row] matPrice];
//        
//        indexPathSegue = tbl.indexPathForSelectedRow;
//        indexPathRow = indexPathSegue.row;
    }
    if ([segue.identifier isEqualToString:@"plotPlotId"]) {
        PlotVisualController *visualPlot = segue.destinationViewController;
        visualPlot.plot = newPlot;        
    }
}

-(void) saveAll {
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Сохранено" message:@"Введенные данные сохранены" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


//анимация затухания выделения ячейки при возвращении в таблицу
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    
    //условие для реализации перезагрузки ячейки таблицы при изменении
    if (indexPathForSelectedRow) {
        [self.tableOfSides reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForSelectedRow] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableOfSides deselectRowAtIndexPath:[self.tableOfSides indexPathForSelectedRow] animated:YES];
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
