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
    if (index > 0) {
        
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
    
    //
    
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
//    [mutableArray removeObjectAtIndex:0];
//    [mutableArray addObject:sideFirst];
//        
//    sidesCount++;
//    }

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return listDiagonal.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"diagonalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    diagonalTmp = [listDiagonal objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@", diagonalTmp.angleFirst, diagonalTmp.angleSecond];
    cell.detailTextLabel.text = [diagonal.diagonalWidth stringValue];
    
    // Configure the cell...
    
    return cell;
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
