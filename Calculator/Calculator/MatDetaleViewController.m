//
//  MatDetaleViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 15.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "MatDetaleViewController.h"
#import "MathModel.h"
#import "MathSingleViewController.h"

@interface MatDetaleViewController ()

@end

@implementation MatDetaleViewController
@synthesize tbl;

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
    
    //переменная где будет хранится то что возвращает метод fetchData (массив данных)
    _data = [MathModel fetchData];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNew)];
    self.navigationItem.leftBarButtonItem = addButton;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *const CellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    
    //создаем объект ячейки из массива данных
    MathModel *item = [_data objectAtIndex:indexPath.row];
    cell.textLabel.text = item.nameMaterial;
    cell.detailTextLabel.text = item.widthMaterial;
    
    return cell;
}

- (void) addNew {
    
    [items addObject:@"Новая запись"];
    [tbl reloadData];
    
}

//отслеживание segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSLog(@"PrepareForSeq %@", segue.identifier);
    NSIndexPath *indexPath = [self.tbl indexPathForSelectedRow];
    
    if (indexPath) {
        MathModel *item = [_data objectAtIndex:indexPath.row];
        [segue.destinationViewController setDetail:item];
    }
}

//анимация затухания выделения ячейки при возвращении в таблицу
- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.tbl deselectRowAtIndexPath:[self.tbl indexPathForSelectedRow] animated:YES];
}

@end




















