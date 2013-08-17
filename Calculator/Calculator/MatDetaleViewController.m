//
//  MatDetaleViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 15.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "MatDetaleViewController.h"
#import "MathSingleViewController.h"

@interface MatDetaleViewController ()

@end


@implementation MatDetaleViewController

@synthesize tbl;
@synthesize mathModel;
@synthesize innerArrayMaterial;


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
    
    
    //Создаем объект модели материалов
    //заполняем объект данными
    self.innerArrayMaterial = [NSMutableArray array];
    
    MathModel *modelMaterial;
    
    modelMaterial = [[MathModel alloc] init];
    modelMaterial.nameMaterial = @"Сатин";
    modelMaterial.widthMaterial = @"150см";
    modelMaterial.priceMaterial = @"200";
    
    [innerArrayMaterial addObject:modelMaterial];
    
    modelMaterial = [[MathModel alloc] init];
    modelMaterial.nameMaterial = @"Глянец";
    modelMaterial.widthMaterial = @"180см";
    modelMaterial.priceMaterial = @"250";
    
    [innerArrayMaterial addObject:modelMaterial];
    
    modelMaterial = [[MathModel alloc] init];
    modelMaterial.nameMaterial = @"Матовый";
    modelMaterial.widthMaterial = @"280см";
    modelMaterial.priceMaterial = @"340";
    
    [innerArrayMaterial addObject:modelMaterial];
    

    
    //подготовка к отправке данных в MaterialServise
    MaterialServise *modelMaterialServise = [[MaterialServise alloc] init];
    [modelMaterialServise SaveMaterial:innerArrayMaterial];
    
    
    //передаем данные из функции Read класс MaterialServise в объект mathModel
    mathModel = [MaterialServise Read];
    
    
    //добавляем кнопку редактирования 
    UIBarButtonItem *edit =[[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                             target:self
                             action:@selector(editing)];
    self.navigationItem.rightBarButtonItem = edit;
}


//описание работы кнопки редактирования
- (void)editing {
    [tbl setEditing:!self.tbl.editing animated:YES];
}


//описание метода редактирования
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [innerArrayMaterial removeObjectAtIndex:indexPath.row];
        
        //попытка провести все действия mvc при удалении
        //подготовка к отправке данных в MaterialServise
        MaterialServise *modelMaterialServise = [[MaterialServise alloc] init];
        [modelMaterialServise SaveMaterial:innerArrayMaterial];
        
        //передаем данные из функции Read класс MaterialServise в объект mathModel
        mathModel = [MaterialServise Read];

        //проверка уменьшения эллементов массива mathModel класса MaterialServise
        NSLog(@"mathModel.count = %d", mathModel.count);
        
        [tbl deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return mathModel.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *const CellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    
    //создаем объект ячейки из массива данных
    MathModel *item = [mathModel objectAtIndex:indexPath.row];
    cell.textLabel.text = item.nameMaterial;
    cell.detailTextLabel.text = item.widthMaterial;
    
    return cell;
}


//отслеживание segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSLog(@"PrepareForSeq %@", segue.identifier);
    NSIndexPath *indexPath = [self.tbl indexPathForSelectedRow];
    
    if (indexPath) {
        MathModel *item = [mathModel objectAtIndex:indexPath.row];
        [segue.destinationViewController setDetail:item];
    }
}


//анимация затухания выделения ячейки при возвращении в таблицу
- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self.tbl deselectRowAtIndexPath:[self.tbl indexPathForSelectedRow] animated:YES];
}

@end




















