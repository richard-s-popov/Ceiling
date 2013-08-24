//
//  ProjectsListViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "ProjectsListViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "ProjectModel.h"
#import "ProjectDetailViewController.h"
#import "ProjectServise.h"

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

- (IBAction)menuBtn:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}

@end
