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
    PlotSide *newSide;
    NSArray *alphabet;
    NSObject *object;
    UIButton *button;
    UIButton *saveButton;
    NSIndexPath *indexPathForSelectedRow;
    Plot *newPlot;
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
@synthesize plotFromProject;
@synthesize project;


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
    button.frame = CGRectMake(120, 54, 80, 30);
    button.titleLabel.text = @"Далее";
    button.titleLabel.textColor = [UIColor blackColor];
    [button setTitle:@"Далее" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(generatesSides) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 1;
    [sidesConteinerView addSubview:button];
    
    
    //кнопка сохранить
    UIImage *viewButtomBackground = [[UIImage imageNamed:@"project_viewPlot.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIButton *viewPlotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    viewPlotButton.frame = CGRectMake(0, 0, 220, 50);
    [viewPlotButton setTitle:@"Просмотр чертежа" forState:UIControlStateNormal];
    [viewPlotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [viewPlotButton setBackgroundImage:viewButtomBackground forState:UIControlStateNormal];
    [viewPlotButton addTarget:self action:@selector(buildPlot) forControlEvents:UIControlEventTouchUpInside];
    [sidesConteinerView addSubview:viewPlotButton];
    
    //кнопка удалить
    UIImage *deleteButtomBackground = [[UIImage imageNamed:@"project_deletePlot.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIButton *deletePlotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    deletePlotButton.frame = CGRectMake(220, 0, 100, 50);
    [deletePlotButton setTitle:@"Удалить" forState:UIControlStateNormal];
    [deletePlotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [deletePlotButton setBackgroundImage:deleteButtomBackground forState:UIControlStateNormal];
    [deletePlotButton addTarget:self action:@selector(deletePlotAction) forControlEvents:UIControlEventTouchUpInside];
    [sidesConteinerView addSubview:deletePlotButton];
    
    angleCountField = [[UITextField alloc] initWithFrame:CGRectMake(15,54, 100, 30)];
    angleCountField.borderStyle = UITextBorderStyleRoundedRect;
    angleCountField.placeholder = @"к-во углов";
    angleCountField.enabled = YES;
    angleCountField.keyboardType = UIKeyboardTypeNumberPad;
    [sidesConteinerView addSubview:angleCountField];
    
    
    //условие если стороны уже были сгенерированы для текущего чертежа
    newPlot = plotFromProject;
    if (newPlot.plotSide.count != 0) {
        mutableArraySides = (NSMutableArray *)[newPlot.plotSide allObjects];
        countOfSides = mutableArraySides.count;
 
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sidePosition" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        mutableArraySides = (NSMutableArray*)[mutableArraySides sortedArrayUsingDescriptors:sortDescriptors];
        
        angleCountField.enabled = NO;
        button.enabled = NO;
    }
}


-(void)deletePlotAction {
    [project removeProjectPlotObject:newPlot];
    [self.navigationController popViewControllerAnimated:YES];
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
    
    //условие если стороны для чертежа никогда не генерировались
    if (newPlot.plotSide.count == 0) {
        countOfSides = [angleCountField.text intValue];
        
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
            
            newSide.sidePosition = [NSNumber numberWithInt:countTmp];
            
            [mutableArraySides addObject:newSide];
            [newPlot addPlotSideObject:newSide];
            
            countTmp++;
        }
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
        
    }
    if ([segue.identifier isEqualToString:@"plotPlotId"]) {
        PlotVisualController *visualPlot = segue.destinationViewController;
        visualPlot.plot = newPlot;        
    }
}

-(void) buildPlot {
    
    //проверка на заполнение сторон и диагоналей
    int count = 0;
    int diagonalCount = 0;
    BOOL emptySide = NO;
    BOOL emptyDiagonal = NO;
    
    while (count != mutableArraySides.count) {
        
        PlotSide *someSide = [mutableArraySides objectAtIndex:count];
        int width = [someSide.sideWidth intValue];
        
        if (width == 0) {
            emptySide = YES;
        }
        
        //проверяем диагонали на нулевые значения
        NSArray *tmpDiagonalArray = [someSide.sideDiagonal allObjects];
        int countDiagonalOfSide = 0;
        while ((countDiagonalOfSide != tmpDiagonalArray.count) ) {
            
            PlotDiagonal *tmpDiagonal  = [tmpDiagonalArray objectAtIndex:countDiagonalOfSide];
            int diagonalWidth = [tmpDiagonal.diagonalWidth intValue];
            
            if (diagonalWidth == 0) {
                emptyDiagonal = YES;
            }
            countDiagonalOfSide++;
        }
        
        //проверяем диагонали на колличественное соответствие
        diagonalCount = diagonalCount+tmpDiagonalArray.count;
        
        count++;
    }
    
    if (emptySide == YES) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Построение чертежа" message:@"Не все стороны заполнены, пожалуйста введите все необходимые данные" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    if (diagonalCount<mutableArraySides.count-3) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Построение чертежа" message:@"Вы ввели недостаточное колличество диагоналей, пожалуйста введите все необходимые данные" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    if (emptyDiagonal == YES) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Построение чертежа" message:@"Одна или несколько диагоналей имеют нулевое значение, пожалуйста введите все необходимые данные" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
    //если все впорядке пускаем в построение чертежа
    if ((emptySide == NO) && (diagonalCount >= mutableArraySides.count-3) && (emptyDiagonal == NO) ) {
        PlotVisualController *visualPlot = [self.storyboard instantiateViewControllerWithIdentifier:@"plotViewStoryboardId"];
        visualPlot.plot = newPlot;
        
        
        [self.navigationController pushViewController:visualPlot animated:YES];
    }
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

- (IBAction)saveAll:(id)sender {
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Сохранено" message:@"Введенные данные сохранены" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
