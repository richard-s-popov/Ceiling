//
//  NewProjectListViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 23.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "NewProjectListViewController.h"

@interface NewProjectListViewController ()

@end

@implementation NewProjectListViewController
@synthesize managedObjectContext;
@synthesize projectArray;
@synthesize tbl;
@synthesize mutableArray;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(NSManagedObjectContext *)managedObjectContext {
    return [(CalcAppDelegate *)[[UIApplication sharedApplication]delegate] managedObjectContext];
}


-(void)pullArrayFromCoreData {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Projects"];
    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortByDate]];
    NSError *error;
    projectArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self pullArrayFromCoreData];
    
    //кнопки меню бара
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.editButtonItem.title = @"Изменить";
    
    //кнопка добавления клиента
    UIBarButtonItem *addButton =[[UIBarButtonItem alloc] initWithTitle:@"Добавить" style:UIBarButtonItemStyleBordered target:self action:@selector(addBtn)];
    self.navigationItem.leftBarButtonItem = addButton;
}


-(void)addBtn {
    Projects *addProject = [NSEntityDescription insertNewObjectForEntityForName:@"Projects" inManagedObjectContext:self.managedObjectContext];
    addProject.projectName = @"Новый проект";
    addProject.projectAdress = @"Новый адрес";
    addProject.created = [NSDate date];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    projectArray = [projectArray arrayByAddingObject:addProject];
    
    //получаем массив из стека для правильной сортировки
    [self pullArrayFromCoreData];

    [tbl insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


//-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    //необходимые методы для отслеживания состояния кнопки editing
//    [super setEditing:!self.tbl.editing animated:animated];
//    [tbl setEditing:editing animated:animated]; //при этом методе глючит свайп для удаления
//    
//    if (editing) {
//        NSLog(@"editing - yes");
//        
//        self.editButtonItem.title = NSLocalizedString(@"Сохранить", @"Сохранить");
//        
//        //добавляем кнопку добавить
//        UIBarButtonItem *addButton =[[UIBarButtonItem alloc] initWithTitle:@"Добавить" style:UIBarButtonItemStyleBordered target:self action:@selector(addBtn)];
//        self.navigationItem.leftBarButtonItem = addButton;
//    }
//    else {
//        NSLog(@"editing - no");
//        
//        self.editButtonItem.title = NSLocalizedString(@"Изменить", @"Изменить");
//        self.navigationItem.leftBarButtonItem = nil;
//    }
//}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.managedObjectContext deleteObject:[projectArray objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
        }
        
        [self pullArrayFromCoreData];
        [tbl beginUpdates];
        [tbl deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tbl endUpdates];
    }
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
    return projectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewProjectList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Projects *project = [projectArray objectAtIndex:indexPath.row];
    cell.textLabel.text = project.projectName;
    cell.detailTextLabel.text = project.projectAdress;
    
    return cell;
}


// Override to support conditional editing of the table view.

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

#pragma mark - ViewDidAppear
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    NSIndexPath *selectedIndexPath = [self.tbl indexPathForSelectedRow];
//    [self.tbl reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
//
    [self.tbl deselectRowAtIndexPath:[self.tbl indexPathForSelectedRow] animated:YES];
    [tbl reloadData];
}




#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tbl indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"ToDetailProject"]) {
        NewProjectDetailViewController *detailProject = segue.destinationViewController;
        detailProject.project = [projectArray objectAtIndex:indexPath.row];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
