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
        
    [self pullArrayFromCoreData];

    //редактируем и добавляем Edit Button
    UIImage *rightButtonImage = [[UIImage imageNamed:@"rightBtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 23, 0, 6)];
    self.editButtonItem.title = @"Изменить";
    [self.editButtonItem setBackgroundImage:rightButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.editButtonItem setTitleTextAttributes:blackText forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    [tbl reloadData];
}


//создаем helper для managedObjectContext
- (NSManagedObjectContext *)managedObjectContext {
    return [(CalcAppDelegate*)[[UIApplication sharedApplication]delegate] managedObjectContext];
}


//кнопка edit
-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:!self.tbl.editing animated:animated];
    [tbl setEditing:editing animated:animated];
    
    if (editing) {
        self.editButtonItem.title = NSLocalizedString(@"Сохранить", @"Сохранить");
        [self.editButtonItem setTitleTextAttributes:redText forState:UIControlStateNormal];
        
        //добавляем кнопку добавления материала
        UIImage *addButtonImage = [[UIImage imageNamed:@"addBtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        UIBarButtonItem *addButton =[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(addBtn)];
        [addButton setBackgroundImage:addButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = addButton;
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    else {
        self.editButtonItem.title = NSLocalizedString(@"Изменить", @"Изменить");
        [self.editButtonItem setTitleTextAttributes:blackText forState:UIControlStateNormal];
        
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
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
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
    [cell.priceCell setFont:[UIFont fontWithName:@"FuturisCyrillic" size:19]];
    [cell.nameCell setFont:[UIFont fontWithName:@"FuturisCyrillic" size:19]];
    [cell.widthCell setFont:[UIFont fontWithName:@"FuturisCyrillic" size:14]];
    [cell.labelPriceCell setFont:[UIFont fontWithName:@"FuturisCyrillic" size:12]];
    
    
    //создаем объект ячейки из массива данных
    Materials *material = [list objectAtIndex:indexPath.row];
    
    cell.priceCell.text = [material.matPrice stringValue];
    cell.nameCell.text = material.matName;
    cell.widthCell.text = [NSString stringWithFormat:@"%@ - ширина полотна", material.matWidth];
        
    return cell;
}

- (void)pullArrayFromCoreData {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Materials"];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"matName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    
    list = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
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
        
        [self pullArrayFromCoreData];
        
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
