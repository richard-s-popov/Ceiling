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
    
    list = [plot.plotSide allObjects];
    NSString *angleFromPlot = side.angleFirst;
    NSString *someAngle = @"P";
    int count = 0;
    while (count < (list.count-3)) {
        
//        diagonal = [NSEntityDescription insertNewObjectForEntityForName:@"PlotDiagonal" inManagedObjectContext:self.managedObjectContext];
//        diagonal.diagonalName = [NSString stringWithFormat:@"%@%@", side.angleFirst, someAngle];
//        [plot addPlotDiagonalObject:diagonal];
//        
//        NSError *error;
//        if (![self.managedObjectContext save:&error]) {
//        }

        diagonal.diagonalName = [NSString stringWithFormat:@"%@%@", angleFromPlot, someAngle];
        [listDiagonal addObject:diagonal];
        count++;
    }
    
//    listDiagonal = [plot.plotDiagonal allObjects];
    
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
    
    diagonal = [listDiagonal objectAtIndex:indexPath.row];
    
    cell.textLabel.text = diagonal.diagonalName;
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
