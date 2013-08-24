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
@synthesize menuBtn;
@synthesize clientsList;
@synthesize savedProjects;
@synthesize tbl;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    NSNumber *projectsCount = [projects objectForKey:@"porjectsCount"];
    
    
    self.clientsList = [[NSMutableArray alloc] init];
    ProjectModel *projectExemplar;
    
    //создание нулевого эллемента
    int n = 0;
    if ( n == [projectsCount intValue]) {
        projectExemplar = [[ProjectModel alloc] init];
        projectExemplar.clientName = @"Иван Иванович";
        projectExemplar.clientAdress = @"Октябрьская 34 - 20";
        
        [clientsList addObject:projectExemplar];
        NSLog(@"count = %d",clientsList.count);
    }
    
    //заполнение массива данными
    while ( n != [projectsCount intValue]) {
        projectExemplar = [[ProjectModel alloc] init];
        projectExemplar = [savedProjects objectAtIndex:n];

        [clientsList addObject:projectExemplar];
        n++;
    }
    

    //отдаем данные в ProjectService
    ProjectServise *newArrayProjects = [[ProjectServise alloc] init];
    [newArrayProjects SaveProject:clientsList];
    //получаем сохраненные данные из ProjectService
    savedProjects = [ProjectServise Read];
    
    
    //добавляем кнопку добавить
    UIBarButtonItem *addButton =[[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addBtn)];
    self.navigationItem.leftBarButtonItem = addButton;
    //добавляем кнопку редактирования
    UIBarButtonItem *edit =[[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                            target:self
                            action:@selector(editing)];
    self.navigationItem.rightBarButtonItem = edit;
}

- (void)addBtn {

    ProjectModel *projectExemplar = [[ProjectModel alloc] init];
    projectExemplar.clientName = @"Новый клиент";
    projectExemplar.clientAdress = @"адрес";
    [clientsList addObject:projectExemplar];
    
    //отдаем данные в ProjectService
    ProjectServise *newArrayProjects = [[ProjectServise alloc] init];
    [newArrayProjects SaveProject:clientsList];
    
    [tbl reloadData];
}


- (void)editing {
    [tbl setEditing:!self.tbl.editing animated:YES];
}


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
    return clientsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellProject";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ProjectModel *projectModel = [[ProjectModel alloc] init];
    projectModel = [clientsList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = projectModel.clientName;
    cell.detailTextLabel.text = projectModel.clientAdress;
    NSLog(@"name = %@", projectModel.clientName);

    
    // Configure the cell...
    
    return cell;
}


//отслеживание segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tbl indexPathForSelectedRow];
    
    if (indexPath) {
        ProjectModel *projectExemplar = [clientsList objectAtIndex:indexPath.row];
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
    
    NSLog(@"new name - %@",newName);
    //проверяем изменились ли данные
    if ((selectedIndexPath) && ((changedProject.clientName != newName) || (changedProject.clientAdress != newAdress) )) {
        
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


- (IBAction)menuBtn:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}

@end
