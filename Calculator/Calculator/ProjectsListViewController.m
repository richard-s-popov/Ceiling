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
@synthesize tbl;
@synthesize projectsCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //получаем сохраненные данные из ProjectService
    savedProjects = [ProjectServise Read];
    
    NSUserDefaults *projects = [NSUserDefaults standardUserDefaults];
    projectsCount = [projects objectForKey:@"porjectsCount"];
    
    
    self.clientsList = [[NSMutableArray alloc] init];
    ProjectModel *projectExemplar;
    
    //создание нулевого эллемента
    int n = 0;
    if ( n == [projectsCount intValue]) {
        projectExemplar = [[ProjectModel alloc] init];
        projectExemplar.clientName = @"Иван Иванович";
        projectExemplar.clientAdress = @"Октябрьская 34 - 20";
        projectExemplar.clientId = @"0";
        
        [clientsList addObject:projectExemplar];
    }
    
    //заполнение массива данными
    while ( n != [projectsCount intValue]) {
        projectExemplar = [[ProjectModel alloc] init];
        projectExemplar = [savedProjects objectAtIndex:n];

        [clientsList addObject:projectExemplar];
        n++;
    }
    
    //чистим настройки в plist
    n = 50;
    while (n >= [projectsCount intValue]) {
        
        NSUserDefaults *projects = [NSUserDefaults standardUserDefaults];
        //удаляем настройки из plist
        [projects removeObjectForKey:[NSString stringWithFormat:@"clientName%d", n]];
        [projects removeObjectForKey:[NSString stringWithFormat:@"clientAdress%d", n]];
        [projects removeObjectForKey:[NSString stringWithFormat:@"clientId%d", n]];
        
        n--;
    }
    
    
    //отдаем данные в ProjectService
    ProjectServise *newArrayProjects = [[ProjectServise alloc] init];
    [newArrayProjects SaveProject:clientsList];
    //получаем сохраненные данные из ProjectService
    savedProjects = [ProjectServise Read];
    

    //кнопка редактирования
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //кнопка меню
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc]
                                  initWithTitle:@"меню" style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(menuBtn)];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)addBtn {

    ProjectModel *projectExemplar = [[ProjectModel alloc] init];
    projectExemplar.clientName = @"Новый клиент";
    projectExemplar.clientAdress = @"адрес";
    projectExemplar.clientId = [NSString stringWithFormat:@"%@", projectsCount ];
    [clientsList addObject:projectExemplar];
    
    //отдаем данные в ProjectService
    ProjectServise *newArrayProjects = [[ProjectServise alloc] init];
    [newArrayProjects SaveProject:clientsList];
    //получаем сохраненные данные из ProjectService
    savedProjects = [ProjectServise Read];
        
    [tbl reloadData];
    
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:!self.tbl.editing animated:animated];
    [tbl setEditing:editing animated:animated];
    
    if (editing) {
        NSLog(@"editing project list");
        //добавляем кнопку добавить
        UIBarButtonItem *addButton =[[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(addBtn)];
        self.navigationItem.leftBarButtonItem = addButton;
    }
    else {
        //добвляем кнопку меню
        UIBarButtonItem *menuButton =[[UIBarButtonItem alloc]
                                      initWithTitle:@"меню" style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(menuBtn)];
        self.navigationItem.leftBarButtonItem = menuButton;
    }
}


//- (void)editing {
//    [tbl setEditing:!self.tbl.editing animated:YES];
//    if (tbl.editing) {
//        NSLog(@"editing project list");
//    }
//    else {
//        NSLog(@"done");
//    }
//}



//описание метода редактирования
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //удаляем ячейку с материалом непосредственно из массива
        [clientsList removeObjectAtIndex:indexPath.row];
        
        
        //отдаем данные в ProjectService
        ProjectServise *newArrayProjects = [[ProjectServise alloc] init];
        [newArrayProjects SaveProject:clientsList];
        //получаем сохраненные данные из ProjectService
        savedProjects = [ProjectServise Read];
        
        [tbl deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                   withRowAnimation:UITableViewRowAnimationFade];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return savedProjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellProject";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ProjectModel *projectModel = [[ProjectModel alloc] init];
    projectModel = [savedProjects objectAtIndex:indexPath.row];
    
    cell.textLabel.text = projectModel.clientName;
    cell.detailTextLabel.text = projectModel.clientAdress;

    
    // Configure the cell...
    
    return cell;
}


//отслеживание segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tbl indexPathForSelectedRow];
    
    if (indexPath) {
        ProjectModel *projectExemplar = [savedProjects objectAtIndex:indexPath.row];
        [segue.destinationViewController setDetail:projectExemplar];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


//анимация затухания выделения ячейки при возвращении в таблицу
- (void) viewDidAppear:(BOOL)animated {
    
    NSIndexPath *selectedIndexPath = [self.tbl indexPathForSelectedRow];
    
    [super viewDidAppear:animated];
    
    //изменяем данные в массиве
    ProjectModel *changedProject = [[ProjectModel alloc] init];
    changedProject = [clientsList objectAtIndex:selectedIndexPath.row];
    
    //извлекаем данные из памяти
    NSUserDefaults *projects =[NSUserDefaults standardUserDefaults];
    NSString *newName = [projects objectForKey:[NSString stringWithFormat:@"clientName%d", selectedIndexPath.row]];
    NSString *newAdress = [projects objectForKey:[NSString stringWithFormat:@"clientAdress%d", selectedIndexPath.row]];
    NSString *newId = [projects objectForKey:[NSString stringWithFormat:@"clientId%d", selectedIndexPath.row]];
    
    //проверяем изменились ли данные
    if ((selectedIndexPath) && ((changedProject.clientName != newName) || (changedProject.clientAdress != newAdress))) {
//    if (selectedIndexPath) {
    
        [changedProject setClientName:newName];
        [changedProject setClientAdress:newAdress];
        [changedProject setClientId:newId];
        
        //записываем объект материала обратно в массив
        [clientsList replaceObjectAtIndex:selectedIndexPath.row withObject:changedProject];
        
        //отдаем данные в ProjectService
        ProjectServise *newArrayProjects = [[ProjectServise alloc] init];
        [newArrayProjects SaveProject:clientsList];
        //получаем сохраненные данные из ProjectService
        savedProjects = [ProjectServise Read];
        
        [self.tbl reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    [self.tbl deselectRowAtIndexPath:[self.tbl indexPathForSelectedRow] animated:YES];
    
}

- (void)menuBtn {
    
    [self.slidingViewController anchorTopViewTo:ECRight];

}

@end
