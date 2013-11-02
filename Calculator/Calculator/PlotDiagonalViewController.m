//
//  PlotDiagonalViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 01.11.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "PlotDiagonalViewController.h"

@interface PlotDiagonalViewController () {
    NSArray *list;
    NSMutableArray *listDiagonal;
    UITextField *myTextField;
    UITextField *diagonalTextField;
    PlotSide *newSide;
    NSNumber *lustSide;
    NSNumber *lustDiagonal;
}

@end

@implementation PlotDiagonalViewController
@synthesize plot;
@synthesize side;
@synthesize diagonal;
@synthesize managedObjectContext;
@synthesize tableOfDiagonal;
@synthesize diagonalTmp;
@synthesize mutableArray;
@synthesize index;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    

    //создаем массив из сторон этого чертежа
    //сортируем этот массив по первому углу
    //    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"angleFirst" ascending:YES]];
    //    newArraySides = [[newPlot.plotSide allObjects] sortedArrayUsingDescriptors:sortDescriptors];

    //создаем все диагонали
    int sidesCount = 0;
    
    //условие для угла A
    if (index == 0) {
        while (sidesCount != mutableArray.count-3) {
            
            NSLog(@"sideFirst - %@%@", side.angleFirst, side.angleSecond);
            
            PlotSide *sideSecond = [mutableArray objectAtIndex:sidesCount+2];
            NSLog(@"sideSecond - %@%@", sideSecond.angleFirst, sideSecond.angleSecond);
            
//            diagonal.diagonalName = [NSString stringWithFormat:@"%@%@", side.angleFirst, sideSecond.angleSecond];
            diagonalTmp = [[DiagonalTmp alloc] init];
            diagonalTmp.angleFirst = [NSString stringWithFormat:@"%@", side.angleFirst];
            diagonalTmp.angleSecond = [NSString stringWithFormat:@"%@", sideSecond.angleFirst ];
            
            NSLog(@"diagonal - %@%@", diagonalTmp.angleFirst, diagonalTmp.angleSecond);
            
            
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
            
            [listDiagonal addObject:diagonalTmp];
            sidesCount++;
        }
        
        sidesCount = 0;
        while (sidesCount != mutableArray.count-sideIndex-2) {
            
            NSLog(@"sideFirst - %@%@", side.angleFirst, side.angleSecond);
            
            PlotSide *sideSecond = [mutableArray objectAtIndex:sideIndex+sidesCount+2];
            NSLog(@"sideSecond - %@%@", sideSecond.angleFirst, sideSecond.angleSecond);
            
            //            diagonal.diagonalName = [NSString stringWithFormat:@"%@%@", side.angleFirst, sideSecond.angleSecond];
            diagonalTmp = [[DiagonalTmp alloc] init];
            diagonalTmp.angleFirst = [NSString stringWithFormat:@"%@", side.angleFirst];
            diagonalTmp.angleSecond = [NSString stringWithFormat:@"%@", sideSecond.angleFirst ];
            
            NSLog(@"diagonal - %@%@", diagonalTmp.angleFirst, diagonalTmp.angleSecond);
            
            
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
            
            [listDiagonal addObject:diagonalTmp];
            sidesCount++;
        }
    }
    
    NSLog(@"%lu", (unsigned long)index);
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
                
                myTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 7, 100, 30)];
                myTextField.delegate = self;
                myTextField.borderStyle = UITextBorderStyleRoundedRect;
                myTextField.placeholder = @"";
                myTextField.tag = 1;
                myTextField.enabled = NO;
                [myTextField addTarget:self action:@selector(saveSide) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:myTextField];
                
                //добвляем кнопки для NumPad
                UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
                numberToolbar.barStyle = UIBarStyleBlack;
                numberToolbar.items = [NSArray arrayWithObjects:
                                       [[UIBarButtonItem alloc]initWithTitle:@"Cancel"  style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                                       [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                       [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                                       nil];
                [numberToolbar sizeToFit];
                
                myTextField.inputAccessoryView = numberToolbar;

            }
            break;
        case 1:
            
            diagonalTmp = [listDiagonal objectAtIndex:indexPath.row];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@", diagonalTmp.angleFirst, diagonalTmp.angleSecond];
            cell.detailTextLabel.text = @"0";
            
            diagonalTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 7, 100, 30)];
            diagonalTextField.delegate = self;
            diagonalTextField.borderStyle = UITextBorderStyleRoundedRect;
            diagonalTextField.placeholder = @"";
            diagonalTextField.tag = indexPath.row +2;
            diagonalTextField.enabled = NO;
            [diagonalTextField addTarget:self action:@selector(saveDiagonal) forControlEvents:UIControlEventEditingDidEnd];
            [cell.contentView addSubview:diagonalTextField];
            
            
            //добвляем кнопки для NumPad
            UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
            numberToolbar.barTintColor = [UIColor blackColor];
            numberToolbar.barStyle = UIBarStyleBlackTranslucent;
            numberToolbar.items = [NSArray arrayWithObjects:
                                   [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                                   [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                   [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                                   nil];
            [numberToolbar sizeToFit];
            
            diagonalTextField.inputAccessoryView = numberToolbar;
            
            break;
    }

    return cell;
    
}


- (NSString*) tableView: (UITableView*) tableView titleForHeaderInSection: (NSInteger) section
{
    NSString *sectionName = [[NSString alloc] init];
    if (section == 0) {
        sectionName = @"Введите значение стороны";
    }
    else {
        sectionName = @"Введите значения диагоналей";
    }
    
    return sectionName;
}

-(void) saveSide {

    lustSide = [NSNumber numberWithInt:[myTextField.text intValue]];
    PlotSide *tmpSide = side;
    tmpSide.sideWidth = lustSide;
}


-(void) saveDiagonal {
    diagonalTmp = [listDiagonal objectAtIndex:diagonalTextField.tag-2];
    lustDiagonal = [NSNumber numberWithInt:[diagonalTextField.text intValue]];
    
    PlotDiagonal *tmpDiagonal = [NSEntityDescription insertNewObjectForEntityForName:@"PlotDiagonal" inManagedObjectContext:self.managedObjectContext];
    tmpDiagonal.diagonalWidth = lustDiagonal;
    tmpDiagonal.diagonalName = [NSString stringWithFormat:@"%@%@", diagonalTmp.angleFirst, diagonalTmp.angleSecond];
        
    [plot addPlotDiagonalObject:tmpDiagonal];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.row == 0) && (indexPath.section == 0)) {
        
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:newIndex];
        
        myTextField = (UITextField *)[cell viewWithTag:indexPath.row+1];
        myTextField.enabled = YES;
        myTextField.keyboardType = UIKeyboardTypeNumberPad;
        myTextField.returnKeyType = UIReturnKeyNext;
        [myTextField becomeFirstResponder];
        
    }
    else {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        diagonalTextField = (UITextField *) [cell viewWithTag:indexPath.row+2];
        diagonalTextField.enabled = YES;
        diagonalTextField.keyboardType = UIKeyboardTypeNumberPad;
        diagonalTextField.returnKeyType = UIReturnKeyNext;
        [diagonalTextField becomeFirstResponder];
    }
    
//    [tableOfDiagonal deselectRowAtIndexPath:[tableOfDiagonal indexPathForSelectedRow] animated:YES];
//    [myTextField resignFirstResponder];
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row == 0) && (indexPath.section == 0)) {
        
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:newIndex];
        
        myTextField = (UITextField *)[cell viewWithTag:indexPath.row+1];
        myTextField.enabled = NO;
        myTextField.keyboardType = UIKeyboardTypeNumberPad;
        myTextField.returnKeyType = UIReturnKeyNext;
        [myTextField resignFirstResponder];
        
    }
    else {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        diagonalTextField = (UITextField *) [cell viewWithTag:indexPath.row+2];
        diagonalTextField.enabled = NO;
        diagonalTextField.keyboardType = UIKeyboardTypeNumberPad;
        diagonalTextField.returnKeyType = UIReturnKeyNext;
        [diagonalTextField resignFirstResponder];
    }
}


-(void)cancelNumberPad{
    [myTextField resignFirstResponder];
    [diagonalTextField resignFirstResponder];
}

-(void)doneWithNumberPad{
    [myTextField resignFirstResponder];
    [diagonalTextField resignFirstResponder];
}


// скрываем клавиатуру по нажатию кнопки
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"return");
    //вызов метода скрытия клавиатуры
    [textField resignFirstResponder];
    return YES;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
