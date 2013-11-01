//
//  NewPlotDetailViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 27.10.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "NewPlotDetailViewController.h"

@interface NewPlotDetailViewController () {
    NSArray *list;
    NSArray *listDiagonal;
}

@end

@implementation NewPlotDetailViewController
@synthesize plot;
@synthesize side;
@synthesize diagonal;
@synthesize managedObjectContext;
@synthesize tableOfDiagonal;

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
    list = [plot.plotSide allObjects];
    NSString *someAngle = @"P";
    while (plot.plotDiagonal.count <= (list.count-3)) {
        diagonal = [NSEntityDescription insertNewObjectForEntityForName:@"PlotDiagonal" inManagedObjectContext:self.managedObjectContext];
        diagonal.diagonalName = [NSString stringWithFormat:@"%@%@", side.angleFirst, someAngle];
        [plot addPlotDiagonalObject:diagonal];
    }
    
    listDiagonal = [plot.plotDiagonal allObjects];

}


#pragma mark - table method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return listDiagonal.count;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *const CellId = @"diagonalCell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    
    //создаем объект ячейки из массива данных
    PlotDiagonal *diagonalTmp = [listDiagonal objectAtIndex:indexPath.row];
    
    cell.textLabel.text = diagonalTmp.diagonalName;
    cell.detailTextLabel.text = [diagonalTmp.diagonalWidth stringValue];
    
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
