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
    
    //для криволинейного участка
    UIButton *clearButton;
    UITextField *angleCurvLine;
    UILabel *curvLineLabel;
    int numberAngleCurv;
    NSString *angleCurvFirst;
    NSString *angleCurvSecond;
    BOOL isGeneratingCurv;
    UIButton *buttonCurv;
    BOOL deleteCurve;
    
//    для алерта
    UIAlertView *alert;
    BOOL emptySide;
    BOOL emptyDiagonal;
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

@synthesize curve;


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
    
    deleteCurve = NO;
    isGeneratingCurv = NO;
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
    
    
    //кнопка просмотра чертежа
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
        
        
        //ПОКАЗЫВАЕМ КНОПКУ ДЛЯ КРИВОЛИНЕЙНОГО УЧАСТКА
        
        [self showCurvButton];
        
    }
}



//МЕТОД ВЫЧИСЛЕНИЯ ДИАГОНАЛИ ПО УГЛУ 90 ГРАДУСОВ

-(void)calculateAngle90 {
    
    //ПЕРЕБИРАЕМ ВСЕ СТОРОНЫ ДЛЯ ПРОВЕРКИ УГЛА 90
    
    int i = 0;
    while (i < mutableArraySides.count) {
        
        PlotSide *sideFor90 = [mutableArraySides objectAtIndex:i];
        if (sideFor90.angle == [NSNumber numberWithInt:1]) {  //ЕСЛИ УГЛ 90 ГРАДУСОВ
            
            
            //ЕСЛИ УГОЛ А
            
            if (sideFor90 == [mutableArraySides firstObject]) {
                
                
                //ПЕРЕДАЕМ СТОРОНЫ В МЕТОД И ПОЛУЧАЕМ СОЗДАННУЮ ДАИГОНАЛЬ
                
                PlotSide *side90Second = [mutableArraySides lastObject];
                DiagonalTmp *diagonal90 = [self diagonal90 :side90Second :sideFor90];
                
                
                
                //СОЗДАЕМ ДИАГОНАЛЬ НА ОСНОВЕ 90 ГРАДУСОВ, ЕСЛИ ОНА НЕ СОЗДАНА
                //ПРОВЕРЯЕМ СУЩЕСТВУЕТ ЛИ ОБЪЕКТ ДИАГОНАЛЬ
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(angleFirst == %@) && (angleSecond == %@)", diagonal90.angleFirst, diagonal90.angleSecond];
                NSSet *filteredSet = [side90Second.sideDiagonal filteredSetUsingPredicate:predicate];
                
                
                
                //ЕСЛИ НЕТ НУЖНОЙ ДИАГОНАЛИ - СОЗДАЕМ ЕЕ
                
                if (filteredSet.count == 0) {
                    
                    PlotDiagonal *newDiagonal90 = [NSEntityDescription insertNewObjectForEntityForName:@"PlotDiagonal" inManagedObjectContext:self.managedObjectContext];
                    newDiagonal90.diagonalWidth = diagonal90.diagonalWidth;
                    newDiagonal90.angleFirst = diagonal90.angleFirst;
                    newDiagonal90.angleSecond = diagonal90.angleSecond;
                    newDiagonal90.diagonalWidthFactor = diagonal90.diagonalWidthFactor;
                    
                    [newPlot addPlotDiagonalObject:newDiagonal90];
                    [side90Second addSideDiagonalObject:newDiagonal90];
                    
                }
                else {
                    
                    PlotDiagonal *originDiagonal90 = [[filteredSet allObjects] objectAtIndex:0];
                    originDiagonal90.diagonalWidth = diagonal90.diagonalWidth;
                    originDiagonal90.diagonalWidthFactor = diagonal90.diagonalWidthFactor;

                }
                
                
            }
            
            
            
            //ЕСЛИ НЕ ПЕРВЫЙ И НЕ ПОСЛЕДНИЙ УГОЛ
            
            if ((sideFor90 != [mutableArraySides firstObject]) && (sideFor90 != [mutableArraySides lastObject])) {
                
                
                //ПЕРЕДАЕМ СТОРОНЫ В МЕТОД И ПОЛУЧАЕМ СОЗДАННУЮ ДАИГОНАЛЬ
                
                PlotSide *side90Second = [mutableArraySides objectAtIndex:i-1];
                DiagonalTmp *diagonal90 = [self diagonal90 :side90Second :sideFor90];
                
                
                
                //СОЗДАЕМ ДИАГОНАЛЬ НА ОСНОВЕ 90 ГРАДУСОВ, ЕСЛИ ОНА НЕ СОЗДАНА
                //ПРОВЕРЯЕМ СУЩЕСТВУЕТ ЛИ ОБЪЕКТ ДИАГОНАЛЬ
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(angleFirst == %@) && (angleSecond == %@)", diagonal90.angleFirst, diagonal90.angleSecond];
                NSSet *filteredSet = [side90Second.sideDiagonal filteredSetUsingPredicate:predicate];
                
                
                
                //ЕСЛИ НЕТ НУЖНОЙ ДИАГОНАЛИ - СОЗДАЕМ ЕЕ
                
                if (filteredSet.count == 0) {
                    
                    PlotDiagonal *newDiagonal90 = [NSEntityDescription insertNewObjectForEntityForName:@"PlotDiagonal" inManagedObjectContext:self.managedObjectContext];
                    newDiagonal90.diagonalWidth = diagonal90.diagonalWidth;
                    newDiagonal90.angleFirst = diagonal90.angleFirst;
                    newDiagonal90.angleSecond = diagonal90.angleSecond;
                    newDiagonal90.diagonalWidthFactor = diagonal90.diagonalWidthFactor;
                    
                    [newPlot addPlotDiagonalObject:newDiagonal90];
                    [side90Second addSideDiagonalObject:newDiagonal90];
                    
                }
                else {
                    
                    PlotDiagonal *originDiagonal90 = [[filteredSet allObjects] objectAtIndex:0];
                    originDiagonal90.diagonalWidth = diagonal90.diagonalWidth;
                    originDiagonal90.diagonalWidthFactor = diagonal90.diagonalWidthFactor;
                    
                }
                
                
            }
            
            
            
            //ЕСЛИ ПОСЛЕДНИЙ УГОЛ
            
            if (sideFor90 == [mutableArraySides lastObject]) {
                
                                
                //ПЕРЕДАЕМ СТОРОНЫ В МЕТОД И ПОЛУЧАЕМ СОЗДАННУЮ ДАИГОНАЛЬ
                
                PlotSide *side90Second = [mutableArraySides objectAtIndex:i-1];
                DiagonalTmp *diagonal90 = [self diagonal90 :side90Second :sideFor90];

                
                
                //СОЗДАЕМ ДИАГОНАЛЬ НА ОСНОВЕ 90 ГРАДУСОВ, ЕСЛИ ОНА НЕ СОЗДАНА
                //ПРОВЕРЯЕМ СУЩЕСТВУЕТ ЛИ ОБЪЕКТ ДИАГОНАЛЬ
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(angleFirst == %@) && (angleSecond == %@)", diagonal90.angleFirst, diagonal90.angleSecond];
                NSSet *filteredSet = [side90Second.sideDiagonal filteredSetUsingPredicate:predicate];
                
                
                
                //ЕСЛИ НЕТ НУЖНОЙ ДИАГОНАЛИ - СОЗДАЕМ ЕЕ
                
                if (filteredSet.count == 0) {
                    
                    PlotDiagonal *newDiagonal90 = [NSEntityDescription insertNewObjectForEntityForName:@"PlotDiagonal" inManagedObjectContext:self.managedObjectContext];
                    newDiagonal90.diagonalWidth = diagonal90.diagonalWidth;
                    newDiagonal90.angleFirst = diagonal90.angleFirst;
                    newDiagonal90.angleSecond = diagonal90.angleSecond;
                    newDiagonal90.diagonalWidthFactor = diagonal90.diagonalWidthFactor;
                    
                    [newPlot addPlotDiagonalObject:newDiagonal90];
                    [side90Second addSideDiagonalObject:newDiagonal90];
                    
                }
                else {
                    
                    PlotDiagonal *originDiagonal90 = [[filteredSet allObjects] objectAtIndex:0];
                    originDiagonal90.diagonalWidth = diagonal90.diagonalWidth;
                    originDiagonal90.diagonalWidthFactor = diagonal90.diagonalWidthFactor;
                    
                }
                
                
            }
            
            
            
        }
        
        
        i++; //ИНКРЕМЕНТ
        
        
    }

}



//МЕТОД ВЫЧИСЛЕНИЯ ДЛИННЫ ДИАГОНАЛИ

-(DiagonalTmp*)diagonal90 :(PlotSide*)side90Second :(PlotSide*)mainSide {
    
    DiagonalTmp *diagonal90 = [[DiagonalTmp alloc] init];
    diagonal90.angleFirst = side90Second.angleFirst;
    diagonal90.angleSecond = mainSide.angleSecond;
    
    
    double tangentFirst = [mainSide.sideWidth doubleValue];
    double tangentSecond = [side90Second.sideWidth doubleValue];
    double cotangent = sqrt( pow(tangentFirst, 2.0) + pow(tangentSecond, 2.0));
    
    diagonal90.diagonalWidth = [NSNumber numberWithDouble:cotangent];
    
    
    //считаем диагональ с учетом утяжки
    float diagonalWidthFactorTmp = [diagonal90.diagonalWidth floatValue] - ([diagonal90.diagonalWidth floatValue]*0.07);
    diagonal90.diagonalWidthFactor = [NSNumber numberWithFloat:diagonalWidthFactorTmp];
    
    
    return diagonal90;

}



//МЕТОД ПОКАЗАТЬ КНОПКУ ДЛЯ КРИВОЛИНЕЙНОГО УЧАСТКА

-(void)showCurvButton {

    [angleCountField removeFromSuperview];
    [button removeFromSuperview];
    
    
    //кнопка добавить криволинейный участок
    buttonCurv = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonCurv.frame = CGRectMake(10, 54, 220, 30);
    buttonCurv.titleLabel.font = [UIFont fontWithName:@"OpenSans-CondensedLight" size:18.0f];
    buttonCurv.titleLabel.textColor = [UIColor blackColor];
    
    [buttonCurv.layer setCornerRadius:4.0f];
    [buttonCurv.layer setBorderWidth:1.0f];
    [buttonCurv.layer setBorderColor: [[UIColor grayColor] CGColor]];
    
    [buttonCurv setTitle:@"Добавить криволинейный участок" forState:UIControlStateNormal];
    [buttonCurv addTarget:self action:@selector(clickAddCurvButton) forControlEvents:UIControlEventTouchUpInside];
    buttonCurv.tag = 1;
    [sidesConteinerView addSubview:buttonCurv];
    
    clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setTitle:@"Удалить" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal ];
    clearButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0f];
    [clearButton.layer setCornerRadius:4.0f];
    [clearButton.layer setBorderWidth:1.0f];
    [clearButton.layer setBorderColor: [[UIColor grayColor] CGColor]];
    clearButton.frame=CGRectMake(240, 54, 70.0, 30.0);
    [clearButton addTarget:self action:@selector(clearCurveNumberPad)  forControlEvents:UIControlEventTouchUpInside];
    [sidesConteinerView addSubview:clearButton];
    
}

-(void)clickAddCurvButton {
    
    [buttonCurv removeFromSuperview];
    [clearButton removeFromSuperview];
    
    curve = [[CurveLineModel alloc] init];
    
    angleCurvLine = [[UITextField alloc] initWithFrame:CGRectMake(15,54, 50, 30)];
    angleCurvLine.borderStyle = UITextBorderStyleRoundedRect;
    angleCurvLine.placeholder = @"A";
    angleCurvLine.enabled = YES;
    angleCurvLine.delegate = self;
    angleCurvLine.keyboardType = UIKeyboardTypeDefault;
    angleCurvLine.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [angleCurvLine addTarget:self action:@selector(characterAdd)  forControlEvents:UIControlEventEditingChanged];
    [sidesConteinerView addSubview:angleCurvLine];
    
    curvLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(80,54, 220, 30)];
    curvLineLabel.text = @"введите первый угол участка";
    [curvLineLabel setTextColor:[UIColor blackColor]];
    [curvLineLabel setFont:[UIFont fontWithName:@"OpenSans-CondensedLight" size:18]];
    [sidesConteinerView addSubview:curvLineLabel];
    
    //добвляем кнопки для NumPad
    UIButton *buttonCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCancel setTitle:@"Отмена" forState:UIControlStateNormal];
    buttonCancel.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0f];
    [buttonCancel.layer setCornerRadius:4.0f];
    [buttonCancel.layer setMasksToBounds:YES];
    [buttonCancel.layer setBorderWidth:1.0f];
    [buttonCancel.layer setBorderColor: [[UIColor grayColor] CGColor]];
    buttonCancel.frame=CGRectMake(0.0, 100.0, 70.0, 30.0);
    [buttonCancel addTarget:self action:@selector(cancelNumberPad)  forControlEvents:UIControlEventTouchUpInside];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackOpaque;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc] initWithCustomView:buttonCancel],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];
    [numberToolbar sizeToFit];
    
    numberAngleCurv = 0;
    angleCurvLine.inputAccessoryView = numberToolbar;
    
}



-(void) characterAdd {

    if (angleCurvLine.text.length ==1) {
        
        curve.angleFirstCurve = angleCurvLine.text;
        curvLineLabel.text = @"введите последний угол участка";
    }
    if (angleCurvLine.text.length == 2) {
        
        curve.angleSecondCurve = [angleCurvLine.text substringFromIndex:1];
        NSLog(@"введена кривая - %@%@", curve.angleFirstCurve, curve.angleSecondCurve);
        
        CalculateCurveLine *calculateCurve = [[CalculateCurveLine alloc] init];
        calculateCurve.plot = plotFromProject;
        calculateCurve.arrayOfSides = mutableArraySides;
        [calculateCurve SaveCurve:curve];
        
        
        [angleCurvLine resignFirstResponder];
        [angleCurvLine removeFromSuperview];
        [curvLineLabel removeFromSuperview];
        [sidesConteinerView addSubview:buttonCurv];
        [sidesConteinerView addSubview:clearButton];
    }
}



-(void)clearCurveNumberPad {
    deleteCurve = YES;
    
    alert = [[UIAlertView alloc] initWithTitle:@"Удаление" message:@"Вы уверены, что хотите удалить криволинейный участок?" delegate:self cancelButtonTitle:@"Удалить" otherButtonTitles:@"Отмена", nil];
    alert.tag = 1;
    [alert show];
}



-(void)cancelNumberPad {
    [angleCurvLine resignFirstResponder];
}



//метод подтверждения удаления чертежа

-(void)deletePlotAction {
    [self alertOKCancelAction];
}



- (void)alertOKCancelAction {
    // open a alert with an OK and cancel button
    alert = [[UIAlertView alloc] initWithTitle:@"Удаление чертежа" message:@"Вы уверены, что хотите удалить этот чертеж?" delegate:self cancelButtonTitle:@"Удалить" otherButtonTitles:@"Отмена", nil];
    [alert show];
}



- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        //проверка на то что мы удаляем
        if (alert.tag == 1) {
            if (deleteCurve == YES) {
                plotFromProject.plotCurve = 0;
            }
            else {
                [project removeProjectPlotObject:newPlot];
                
                NSError *error;
                if (![self.managedObjectContext save:&error]) {
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
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
    
    if (newSide.angleFirst == angleCurvFirst) {
        newPlot.plotPrice = 0;
        isGeneratingCurv = YES;
    }
//    if (isGeneratingCurv == YES) {
//    }
    
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
    [self showCurvButton];
    [tableOfSides reloadData];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"sidesDiagonalsSegue"]) {
        PlotDiagonalViewController *detailPlot = segue.destinationViewController;
        detailPlot.side = [mutableArraySides objectAtIndex:tableOfSides.indexPathForSelectedRow.row];

        //передаем следующую сторону для создания диагонали исходя из 90 градусов
        if (tableOfSides.indexPathForSelectedRow.row!=countOfSides-1) {
            detailPlot.sideFor90 = [mutableArraySides objectAtIndex:tableOfSides.indexPathForSelectedRow.row+1];
        }
        else {
            detailPlot.sideFor90 = [mutableArraySides objectAtIndex:0];
        }
        
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
    emptySide = NO;
    emptyDiagonal = NO;
    
    while (count != mutableArraySides.count) {
        
        PlotSide *someSide = [mutableArraySides objectAtIndex:count];
        
//        проверка значения сторон
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
    
    //если все впорядке пускаем в построение чертежа
    if ((emptySide == NO) && (diagonalCount >= mutableArraySides.count-3) && (emptyDiagonal == NO) ) {
        PlotVisualController *visualPlot = [self.storyboard instantiateViewControllerWithIdentifier:@"plotViewStoryboardId"];
        visualPlot.plot = newPlot;
        visualPlot.project = project;
        
        
        [self.navigationController pushViewController:visualPlot animated:YES];
    }
    else {
        if (emptySide == NO && mutableArraySides.count == 0) {
            alert = [[UIAlertView alloc] initWithTitle:@"Построение чертежа" message:@"Вы не ввели колличество углов, это необходимо для дальнейшего построения чертежа" delegate:self cancelButtonTitle:@"Хорошо" otherButtonTitles:nil];
            [alert show];
        }
        if (emptySide == YES) {
            alert = [[UIAlertView alloc] initWithTitle:@"Построение чертежа" message:@"Не все стороны заполнены, пожалуйста введите все необходимые данные" delegate:self cancelButtonTitle:@"Хорошо" otherButtonTitles:nil];
            [alert show];
        }
        if (diagonalCount<mutableArraySides.count-3) {
            alert = [[UIAlertView alloc] initWithTitle:@"Построение чертежа" message:@"Вы ввели недостаточное колличество диагоналей, пожалуйста введите все необходимые данные" delegate:self cancelButtonTitle:@"Хорошо" otherButtonTitles:nil];
            [alert show];
        }
        if (emptyDiagonal == YES) {
            alert = [[UIAlertView alloc] initWithTitle:@"Построение чертежа" message:@"Одна или несколько диагоналей имеют нулевое значение, пожалуйста введите все необходимые данные" delegate:self cancelButtonTitle:@"Хорошо" otherButtonTitles:nil];
            [alert show];
        }
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
    
    
    
    //ЦЫКЛ ДЛЯ ПРОВЕРКИ НЕ ПУСТЫХ СТОРОН И ВЫЧИСЛЕНИЯ ДИАГОНАЛИ ПО 90 ГРАДУСАМ
    
    if (mutableArraySides.count != 0) {
        
        
        BOOL emptySideForAngle90 = NO;
        
        for (int i=0; i < mutableArraySides.count; i++) {
            
            PlotSide *sideForCheck = [mutableArraySides objectAtIndex:i];
            NSNumber *zero = [NSNumber numberWithInt:0];
            
            if ([sideForCheck.sideWidth isEqual:zero]) {
                emptySideForAngle90 = YES;
            }
        }
        
        
        if (emptySideForAngle90 == NO) {
            
            //ВЫСЧИТЫВАЕМ ДИАГОНАЛЬ ПО УГЛУ 90
            [self calculateAngle90];
        }
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
    
    alert = [[UIAlertView alloc] initWithTitle:@"Сохранено" message:@"Введенные данные сохранены" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


@end
