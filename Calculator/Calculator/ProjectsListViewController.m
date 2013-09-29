//
//  ProjectsListViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "ProjectsListViewController.h"


@interface ProjectsListViewController ()

@end

@implementation ProjectsListViewController

@synthesize clientsList;
@synthesize savedProjects;
@synthesize projectsCount;
@synthesize explaneText;

@synthesize managedObjectsContent;
@synthesize projectsArray;
@synthesize tbl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSManagedObjectContext *)managedObjectsContent {
    return [(CalcAppDelegate *)[[UIApplication sharedApplication]delegate] managedObjectContext];
}

- (void)pullArrayFromCoreData {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Projects"];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"projectName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByName]];
    
    NSError *error = nil;
    projectsArray = [self.managedObjectsContent executeFetchRequest:fetchRequest error:&error];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    CustomNavigationBar
    
    //стек Core Data
    [self pullArrayFromCoreData];
    
    //кнопка редактирования
    //редактируем и добавляем Edit Button
    UIImage *rightButtonImage = [[UIImage imageNamed:@"rightBtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 23, 0, 6)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.title = @"Изменить";
    [self.editButtonItem setTitleTextAttributes:blackText forState:UIControlStateNormal]; //blakText - макрос CalcAppDelegate
    [self.editButtonItem setBackgroundImage:rightButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    //кнопка меню
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc]
                                  initWithTitle:@"меню" style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(menuBtn)];
    self.navigationItem.leftBarButtonItem = menuButton;
    
}

- (void)addBtn {

    Projects *addProject = [NSEntityDescription insertNewObjectForEntityForName:@"Projects" inManagedObjectContext:self.managedObjectsContent];

    addProject.projectName = [NSString stringWithFormat:@"Новый клиент %d", projectsArray.count+1];
    addProject.projectAdress = @"Адресс";
    addProject.projectExplane = @"Описание";
    
    projectsArray = [projectsArray arrayByAddingObject:addProject];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [tbl insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    //сохраняем новый объект кантекста в персистент
    NSError *error = nil;
    if (![self.managedObjectsContent save:&error]) {
    }
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:!self.tbl.editing animated:animated];
    [tbl setEditing:editing animated:animated];
    
    if (editing) {

        self.editButtonItem.title = NSLocalizedString(@"Сохранить", @"Сохранить");
        [self.editButtonItem setTitleTextAttributes:redText forState:UIControlStateNormal];
        //добавляем кнопку добавить
        UIImage *addButtonImage = [[UIImage imageNamed:@"addBtn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        UIBarButtonItem *addButton =[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(addBtn)];
//        [addButton setTitleTextAttributes:blackText forState:UIControlStateNormal];
        [addButton setBackgroundImage:addButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = addButton;
    }
    else {
        
        self.editButtonItem.title = NSLocalizedString(@"Изменить", @"Изменить");
        [self.editButtonItem setTitleTextAttributes:blackText forState:UIControlStateNormal];
        //добвляем кнопку меню
        UIBarButtonItem *menuButton =[[UIBarButtonItem alloc]
                                      initWithTitle:@"меню" style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(menuBtn)];
        self.navigationItem.leftBarButtonItem = menuButton;
    }
}



//описание метода редактирования
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //удаляем ячейку с материалом непосредственно из массива
        
        [self.managedObjectsContent deleteObject:[projectsArray objectAtIndex:indexPath.row]];
        NSError *error = nil;
        if (![self.managedObjectsContent save:&error]) {
        }
        
        [self pullArrayFromCoreData];

        [tbl deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                   withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return projectsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellProject";
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell.labelName setFont:[UIFont fontWithName:@"FuturisCyrillic" size:19]];
    [cell.labelAdress setFont:[UIFont fontWithName:@"FuturisCyrillic" size:15]];
    
    Projects *project = [projectsArray objectAtIndex:indexPath.row];
    cell.labelName.text = project.projectName;
    cell.labelAdress.text  = project.projectAdress;
    
    return cell;
}


//отслеживание segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tbl indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"projectDetail"]) {
        ProjectDetailViewController *detailProject = segue.destinationViewController;
        detailProject.project = [projectsArray objectAtIndex:indexPath.row];
        
        lustName = [[projectsArray objectAtIndex:indexPath.row] projectName];
        lustAdress = [[projectsArray objectAtIndex:indexPath.row] projectAdress];
    }
}


//анимация затухания выделения ячейки при возвращении в таблицу
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //необходимо для условия
    NSString *newName;
    NSString *newAdress;
    if ([projectsArray count]!=0) {
        newName = [[projectsArray objectAtIndex:tbl.indexPathForSelectedRow.row] projectName];
        newAdress = [[projectsArray objectAtIndex:tbl.indexPathForSelectedRow.row] projectAdress];
    }
    
    //условие для реализации перезагрузки ячейки таблицы при изменении
    if ((lustName != nil) && ((lustName != newName) || (![lustAdress isEqual:newAdress]))) {
        NSIndexPath *selectedIndexPath = [self.tbl indexPathForSelectedRow];
        [self.tbl reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    [self.tbl deselectRowAtIndexPath:[self.tbl indexPathForSelectedRow] animated:YES];
    
}

- (void)menuBtn {
    
    [self.slidingViewController anchorTopViewTo:ECRight];

}


@end
