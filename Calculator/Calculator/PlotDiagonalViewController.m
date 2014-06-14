//
//  PlotDiagonalViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 01.11.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "PlotDiagonalViewController.h"

@interface PlotDiagonalViewController () {
//    NSArray *list;
    UITextField *myTextField;
    
    PlotSide *newSide;
    NSNumber *lustSide;
    NSNumber *lustDiagonal;
    
    UITextField *diagonalTextField;
    NSMutableArray *textFieldArray;
    BOOL isSide;
    UILabel *startLable;
    
    NSIndexPath *diagonalIndexPath;
    PlotDiagonal *tmpDiagonalForSave;
    
    NSMutableArray *listDiagonal;
    NSArray *savedDiagonals;
}

@end

@implementation PlotDiagonalViewController
@synthesize plot;
@synthesize side;
@synthesize sideFor90;
@synthesize diagonal;
@synthesize managedObjectContext;
@synthesize tableOfDiagonal;
@synthesize diagonalTmp;
@synthesize mutableArray;
@synthesize index;
@synthesize diagonalConteinerView;


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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myTextField.delegate = self;
    diagonalTextField.delegate = self;
    
    listDiagonal = [[NSMutableArray alloc] init];
    textFieldArray = [[NSMutableArray alloc] init];
    
    //кнопка 90 градусов
    UIImage *viewButtomBackground = [[UIImage imageNamed:@"project_viewPlot.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIButton *viewPlotButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    viewPlotButton.frame = CGRectMake(0, 0, 320, 50);
    [viewPlotButton setTitle:[NSString stringWithFormat:@"Установить угол %@ как 90 градусов", side.angleFirst] forState:UIControlStateNormal];
    [viewPlotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
    [viewPlotButton setBackgroundImage:viewButtomBackground forState:UIControlStateNormal];
    [viewPlotButton addTarget:self action:@selector(add90) forControlEvents:UIControlEventTouchUpInside];
    [diagonalConteinerView addSubview:viewPlotButton];
    
    //создание надписи start
    startLable = [[UILabel alloc] initWithFrame:CGRectMake(30, 54, 320, 30)];
    [startLable setFont:[UIFont fontWithName:@"OpenSans" size:14]];
    startLable.text = @"Нажмите на сторону или диагональ";
    [diagonalConteinerView addSubview:startLable];
    
    //создание текстового поля для ввода диагоналей
    diagonalTextField = [[UITextField alloc] initWithFrame:CGRectMake(180, 54, 100, 30)];
    diagonalTextField.delegate = self;
    diagonalTextField.borderStyle = UITextBorderStyleRoundedRect;
    diagonalTextField.placeholder = @"";
    diagonalTextField.enabled = NO;
    diagonalTextField.tag = 2;
    diagonalTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    //добвляем кнопки для NumPad
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Отмена" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
    [button.layer setCornerRadius:4.0f];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1.0f];
    [button.layer setBorderColor: [[UIColor grayColor] CGColor]];
    button.frame=CGRectMake(0.0, 100.0, 70.0, 30.0);
    [button addTarget:self action:@selector(cancelNumberPad)  forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *saveButtonToolbar = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButtonToolbar setTitle:@"Сохранить" forState:UIControlStateNormal];
    saveButtonToolbar.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
    [saveButtonToolbar.layer setCornerRadius:4.0f];
    [saveButtonToolbar.layer setMasksToBounds:YES];
    [saveButtonToolbar.layer setBorderWidth:1.0f];
    [saveButtonToolbar.layer setBorderColor: [[UIColor grayColor] CGColor]];
    saveButtonToolbar.frame=CGRectMake(0.0, 100.0, 100.0, 30.0);
    [saveButtonToolbar addTarget:self action:@selector(doneWithNumberPad)  forControlEvents:UIControlEventTouchUpInside];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackOpaque;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc] initWithCustomView:button],
                           //                           [[UIBarButtonItem alloc]initWithTitle:@"Отмена" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNamePlot)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           //                           [[UIBarButtonItem alloc]initWithTitle:@"Сохранить" style:UIBarButtonItemStyleDone target:self action:@selector(doneNamePlot)],
                           [[UIBarButtonItem alloc] initWithCustomView:saveButtonToolbar],
                           nil];
    [numberToolbar sizeToFit];
    
    diagonalTextField.inputAccessoryView = numberToolbar;

    //создаем все диагонали
    int sidesCount = 0;
    
    //условие для угла A
    if (index == 0) {
        while (sidesCount != mutableArray.count-3) {
            
            NSLog(@"sideFirst - %@%@", side.angleFirst, side.angleSecond);
            
            PlotSide *sideSecond = [mutableArray objectAtIndex:sidesCount+2];
            NSLog(@"sideSecond - %@%@", sideSecond.angleFirst, sideSecond.angleSecond);
            
            diagonalTmp = [[DiagonalTmp alloc] init];
            diagonalTmp.angleFirst = [NSString stringWithFormat:@"%@", side.angleFirst];
            diagonalTmp.angleSecond = [NSString stringWithFormat:@"%@", sideSecond.angleFirst ];
            
            NSLog(@"diagonal - %@%@", diagonalTmp.angleFirst, diagonalTmp.angleSecond);
            
            //создаем массив диагоналей
            [listDiagonal addObject:diagonalTmp];
            
            sidesCount++;
        }
    }
    
    int sideIndex = index;
    //условие для других углов
    if ((index > 0) && (index != mutableArray.count-1)) {
        
        sidesCount = 0;
        while (sidesCount < index-1) {
            PlotSide *sideSecond = [mutableArray objectAtIndex:sidesCount];
            
            diagonalTmp = [[DiagonalTmp alloc] init];
            diagonalTmp.angleFirst = [NSString stringWithFormat:@"%@", side.angleFirst];
            diagonalTmp.angleSecond = [NSString stringWithFormat:@"%@", sideSecond.angleFirst ];
            
            //создаем массив диагоналей
            [listDiagonal addObject:diagonalTmp];
            
            sidesCount++;
        }
        
        sidesCount = 0;
        while (sidesCount != mutableArray.count-sideIndex-2) {
                        
            PlotSide *sideSecond = [mutableArray objectAtIndex:sideIndex+sidesCount+2];
            
            diagonalTmp = [[DiagonalTmp alloc] init];
            diagonalTmp.angleFirst = [NSString stringWithFormat:@"%@", side.angleFirst];
            diagonalTmp.angleSecond = [NSString stringWithFormat:@"%@", sideSecond.angleFirst ];
            
            //создаем массив диагоналей
            [listDiagonal addObject:diagonalTmp];
            
            sidesCount++;
        }
    }

    //условие для последней диагонали
    if (index == mutableArray.count-1) {
        
        sidesCount = 1;
        while (sidesCount < index-1) {
            PlotSide *sideSecond = [mutableArray objectAtIndex:sidesCount];
            
            diagonalTmp = [[DiagonalTmp alloc] init];
            diagonalTmp.angleFirst = [NSString stringWithFormat:@"%@", side.angleFirst];
            diagonalTmp.angleSecond = [NSString stringWithFormat:@"%@", sideSecond.angleFirst ];
            
            //создаем массив диагоналей
            [listDiagonal addObject:diagonalTmp];
            
            sidesCount++;
        }
    }
    

    //заполняем значения diagonalWidth если они существуют
    [self populateDiagonalWidth];
    
}

//добавляем 90 градусов к углу
-(void)add90 {
    side.angle = [NSNumber numberWithInt:1];
    
    DiagonalTmp *diagonalForAngle90 = [listDiagonal lastObject];
    NSLog(@"listDiagonal - %@%@", diagonalForAngle90.angleFirst, diagonalForAngle90.angleSecond);
    NSLog(@"%i", index);
    
}

//метод для заселения уже созданных диагоналей
-(void)populateDiagonalWidth {
    
    int countTmp = 0;
    
    NSArray *diagonalArrayFromSet = [side.sideDiagonal allObjects];
    
    while (countTmp < side.sideDiagonal.count) {
        
        PlotDiagonal *tmpDiagonal = [diagonalArrayFromSet objectAtIndex:countTmp];
        
        int countTmp2 = 0;
        while (countTmp2 < listDiagonal.count) {
            
            diagonalTmp = [listDiagonal objectAtIndex:countTmp2];
            if ([diagonalTmp.angleSecond isEqual:tmpDiagonal.angleSecond]) {
                diagonalTmp.diagonalWidth = tmpDiagonal.diagonalWidth;
            }
            countTmp2++;
        }
        countTmp++;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count = 0;
    switch (section)
    {
        case 0:
            count = 1;
            break;
        case 1:
            count = listDiagonal.count;
            break;
        default:
            break;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"diagonalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@", side.angleFirst, side.angleSecond];
                cell.detailTextLabel.text = [side.sideWidth stringValue];
            }

            break;
        case 1:
            
            diagonalTmp = [listDiagonal objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@", diagonalTmp.angleFirst, diagonalTmp.angleSecond];
            cell.detailTextLabel.text = [diagonalTmp.diagonalWidth stringValue];
            
            break;
    }

    return cell;
    
}


- (NSString*) tableView: (UITableView*) tableView titleForHeaderInSection: (NSInteger) section
{
    NSString *sectionName = [[NSString alloc] init];
    if (section == 0) {
        sectionName = @"Стороны:";
    }
    else {
        sectionName = @"Диагонали:";
    }
    
    return sectionName;
}


//сохранение диагоналей и стороны
-(void) saveDiagonal {
    
    //сохранение стороны
    if (isSide == YES) {
        side.sideWidth = [NSNumber numberWithInt:[diagonalTextField.text intValue]];
        
        float sideWidthFactorTmp = [side.sideWidth floatValue] - ([side.sideWidth floatValue]*0.07);
        side.sideWidthFactor = [NSNumber numberWithFloat:sideWidthFactorTmp];
        
        [diagonalTextField removeFromSuperview];
        startLable.text = @"Нажимая на диагонали вводите их длинну";
        [self.tableOfDiagonal reloadRowsAtIndexPaths:[NSArray arrayWithObject:diagonalIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableOfDiagonal selectRowAtIndexPath:diagonalIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    //сохранение диагонали
    else {
        diagonalTmp = [listDiagonal objectAtIndex:diagonalIndexPath.row];
        lustDiagonal = [NSNumber numberWithInt:[diagonalTextField.text intValue]];
        
        //проверка диагонали
        if ([diagonalTmp.diagonalWidth intValue] == 0) {
            tmpDiagonalForSave = [NSEntityDescription insertNewObjectForEntityForName:@"PlotDiagonal" inManagedObjectContext:self.managedObjectContext];
            
            tmpDiagonalForSave.diagonalWidth = lustDiagonal;
            tmpDiagonalForSave.angleFirst = diagonalTmp.angleFirst;
            tmpDiagonalForSave.angleSecond = diagonalTmp.angleSecond;
            
            //считаем диагональ с учетом утяжки
            float diagonalWidthFactorTmp = [tmpDiagonalForSave.diagonalWidth floatValue] - ([tmpDiagonalForSave.diagonalWidth floatValue]*0.07);
            tmpDiagonalForSave.diagonalWidthFactor = [NSNumber numberWithFloat:diagonalWidthFactorTmp];
            
            [plot addPlotDiagonalObject:tmpDiagonalForSave];
            [side addSideDiagonalObject:tmpDiagonalForSave];
            
            
            [self populateDiagonalWidth];
        }
        //условие для изменения диагонали в контексте , если диагональ уже была создана
        else {
            
            //создаем выборку по углам
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(angleFirst == %@) && (angleSecond == %@)", diagonalTmp.angleFirst, diagonalTmp.angleSecond];
            NSSet *filteredSet = [side.sideDiagonal filteredSetUsingPredicate:predicate];
            //извлекаем и изменяем объект
            PlotDiagonal *filteredDiagonal = [[filteredSet allObjects] objectAtIndex:0];
            filteredDiagonal.diagonalWidth = lustDiagonal;
            
            //вносим визуальные изменения в таблицу и во временный массив
            diagonalTmp.diagonalWidth = lustDiagonal;
            
            //считаем диагональ с учетом утяжки
            float diagonalWidthFactorTmp = [filteredDiagonal.diagonalWidth floatValue] - ([filteredDiagonal.diagonalWidth floatValue]*0.07);
            filteredDiagonal.diagonalWidthFactor = [NSNumber numberWithFloat:diagonalWidthFactorTmp];
            
        }
        
        
        
        [diagonalTextField removeFromSuperview];
        startLable.text = @"Нажимая на диагонали вводите их длинну";
        
        [self.tableOfDiagonal reloadRowsAtIndexPaths:[NSArray arrayWithObject:diagonalIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableOfDiagonal selectRowAtIndexPath:diagonalIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.row == 0) && (indexPath.section == 0)) {
        
        //для определения редактирования стороны
        isSide = YES;
        diagonalIndexPath = indexPath;
        
        diagonalTextField.enabled = YES;
        diagonalTextField.text = @"";
        [diagonalConteinerView addSubview:diagonalTextField];
        startLable.text = @"введите длинну в см";
        [diagonalTextField becomeFirstResponder];
        
    }
    if (indexPath.section == 1) {
        
        isSide = NO;
        diagonalIndexPath = indexPath;
        diagonalTextField.enabled = YES;
        diagonalTextField.text = @"";
        startLable.text = @"введите длинну в см";
        [diagonalConteinerView addSubview:diagonalTextField];
        [diagonalTextField becomeFirstResponder];
        [self.tableOfDiagonal scrollsToTop];
    }

}


-(void)cancelNumberPad{
    [diagonalTextField resignFirstResponder];
}

-(void)doneWithNumberPad{
    
    [self saveDiagonal];
    [diagonalTextField resignFirstResponder];
}


// скрываем клавиатуру по нажатию кнопки
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //вызов метода скрытия клавиатуры
    [textField resignFirstResponder];
    return YES;
}


@end
