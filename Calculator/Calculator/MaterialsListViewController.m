//
//  MaterialsListViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 16.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "MaterialsListViewController.h"

@interface MaterialsListViewController ()

@end

@implementation MaterialsListViewController
@synthesize tbl;
@synthesize list;
@synthesize mutableList;
@synthesize managedObjectContext;
@synthesize created;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Materials"];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"matName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    
    NSError *error = nil;
    list = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [tbl reloadData];}


//создаем helper для managedObjectContext
- (NSManagedObjectContext *)managedObjectContext {
    return [(CalcAppDelegate*)[[UIApplication sharedApplication]delegate] managedObjectContext];
}


//кнопка edit
-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:!self.tbl.editing animated:animated];
    [tbl setEditing:editing animated:animated];
    
    if (editing) {
        
        //добавляем кнопку добавления материала
        UIBarButtonItem *addButton =[[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(addBtn)];
        self.navigationItem.leftBarButtonItem = addButton;
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    else {
        
        //добавляем кнопку добавления материала
        self.navigationItem.leftItemsSupplementBackButton = YES;
        self.navigationItem.leftBarButtonItem = NO;
    }
}


//добавление нового материала
- (void)addBtn {
    
    Materials *newMaterial = [NSEntityDescription insertNewObjectForEntityForName:@"Materials" inManagedObjectContext:self.managedObjectContext];
    
    newMaterial.created = [NSDate date];
    newMaterial.matName = [NSString stringWithFormat:@"Новый материал %d", list.count+1];
    newMaterial.matWidth = [NSNumber numberWithInt:0];
    newMaterial.matPrice = [NSNumber numberWithInt:0];
    newMaterial.matId = [NSNumber numberWithInteger:list.count];
    
    [self.managedObjectContext save:nil];
    
    list = [list arrayByAddingObject:newMaterial];
    NSLog(@"count: %d", list.count);
    
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:list.count -1 inSection:0];
    [tbl insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *const CellId = @"MatListCell";
    MaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[MaterialCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
    }
    
    //создаем объект ячейки из массива данных
    Materials *material = [list objectAtIndex:indexPath.row];
    
    cell.priceCell.text = [material.matPrice stringValue];
    cell.nameCell.text = material.matName;
    cell.widthCell.text = [NSString stringWithFormat:@"%@ - ширина полотна", material.matWidth];
        
    return cell;
}



//описание метода редактирования
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //удаляем материал из контекста
        [self.managedObjectContext deleteObject:[list objectAtIndex:indexPath.row]];
        [self.managedObjectContext save:nil];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Materials"];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:YES]];
        
        list = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        [tbl deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                   withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"MatListToDetailSegue"]) {
        MaterialsDetailViewController *detailMaterial = segue.destinationViewController;
        detailMaterial.material = [list objectAtIndex:tbl.indexPathForSelectedRow.row];
        
        //необходимо для условия для перезагрузки ячейки таблицы при изменении
        lustName = [[list objectAtIndex:tbl.indexPathForSelectedRow.row] matName];
        lustWidth = [[list objectAtIndex:tbl.indexPathForSelectedRow.row] matWidth];
        lustPrice = [[list objectAtIndex:tbl.indexPathForSelectedRow.row] matPrice];
    }
}


//анимация затухания выделения ячейки при возвращении в таблицу
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //необходимо для условия
    NSString *newName;
    NSNumber *newWidth;
    NSNumber *newPrice;
    if ([list count]!=0) {
        newName = [[list objectAtIndex:tbl.indexPathForSelectedRow.row] matName];
        newWidth = [[list objectAtIndex:tbl.indexPathForSelectedRow.row] matWidth];
        newPrice = [[list objectAtIndex:tbl.indexPathForSelectedRow.row] matPrice];
    }
    
    //условие для реализации перезагрузки ячейки таблицы при изменении
    if ((lustName != nil) && ((lustName != newName) || (![lustWidth isEqual:newWidth]) || (![lustPrice isEqual:newPrice]))) {
        NSIndexPath *selectedIndexPath = [self.tbl indexPathForSelectedRow];
        [self.tbl reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    [self.tbl deselectRowAtIndexPath:[self.tbl indexPathForSelectedRow] animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
