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
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.editButtonItem.title = @"Изменить";
    
    //добавляем кнопку добавить
    UIImage *rightButtonImage = [[UIImage imageNamed:@"rightBtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 23, 0, 6)];
    UIBarButtonItem *addButton =[[UIBarButtonItem alloc] initWithTitle:@"Добавить" style:UIBarButtonItemStyleBordered target:self action:@selector(addBtn)];
    [addButton setBackgroundImage:rightButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = addButton;
    
}


-(void)addBtn {
    Projects *addProject = [NSEntityDescription insertNewObjectForEntityForName:@"Projects" inManagedObjectContext:self.managedObjectContext];
    addProject.projectName = @"Новый проект";
    addProject.projectAdress = @"Новый адрес";
    addProject.projectPhone = @"89117774422";
    addProject.created = [NSDate date];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    projectArray = [projectArray arrayByAddingObject:addProject];
    
    //получаем массив из стека для правильной сортировки
    [self pullArrayFromCoreData];

    [tbl insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NewProjectDetailViewController *detailProject = [self.storyboard instantiateViewControllerWithIdentifier:@"ProjectDetailStoryboardId"];
    detailProject.project = [projectArray objectAtIndex:indexPath.row];
    
    lastName = [[projectArray objectAtIndex:indexPath.row] projectName];
    lastAdress = [[projectArray objectAtIndex:indexPath.row] projectAdress];
    
    indexPathSegue = indexPath;
    indexPathRow = indexPathSegue.row;
    
    [self.navigationController pushViewController:detailProject animated:YES];
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tbl indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"ToDetailProject"]) {
        NewProjectDetailViewController *detailProject = segue.destinationViewController;
        detailProject.project = [projectArray objectAtIndex:indexPath.row];
        
        lastName = [[projectArray objectAtIndex:indexPath.row] projectName];
        lastAdress = [[projectArray objectAtIndex:indexPath.row] projectAdress];
        
        indexPathSegue = indexPath;
        indexPathRow = indexPathSegue.row;
    }
}


//-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    //важное условие для swipe
//    if (!_cellSwiped) {
//        [super setEditing:editing animated:animated];
//    } else if (!editing) {
//        _cellSwiped = NO;
//    }
//    
//    if (editing) {
//        self.editButtonItem.title = NSLocalizedString(@"Сохранить", @"Сохранить");
//        
//        //добавляем кнопку добавить
//        UIBarButtonItem *addButton =[[UIBarButtonItem alloc] initWithTitle:@"Добавить" style:UIBarButtonItemStyleBordered target:self action:@selector(addBtn)];
//        self.navigationItem.leftBarButtonItem = addButton;
//    }
//    else {
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


//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//}
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //получаем имя проекта для удаления папки с чертежами
        NSString *projectName = [[projectArray objectAtIndex:indexPathRow] projectName];
        
        //удаляем объект
        [self.managedObjectContext deleteObject:[projectArray objectAtIndex:indexPath.row]];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        //удаляем папку с чертежами
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], projectName];
        if (![[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Ошибка удаления директории с чертежами" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
        //ссобщение при ошибке удаления
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSString *messageError =[NSString stringWithFormat:@"Ошибка удаления проекта: \n %@", error];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:messageError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        
        [self pullArrayFromCoreData];
        [tbl deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    
    //необходимо для условия
    NSString *newName;
    NSString *newAdress;
    
    if ([projectArray count]!=0) {
        newName = [[projectArray objectAtIndex:indexPathRow] projectName];
        newAdress = [[projectArray objectAtIndex:indexPathRow] projectAdress];
    }
    
    NSLog(@"lastName: %@", lastName);
    NSLog(@"index path: %d", indexPathRow);
    
    //условие для реализации перезагрузки ячейки таблицы при изменении
    if ((lastName != nil) && ((![lastName isEqual:newName]) || (![lastAdress isEqual:newAdress]))) {

        [self.tbl reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPathSegue] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    [self.tbl deselectRowAtIndexPath:[self.tbl indexPathForSelectedRow] animated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
