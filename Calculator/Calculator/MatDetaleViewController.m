//
//  MatDetaleViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 15.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "MatDetaleViewController.h"

@interface MatDetaleViewController ()

@end


@implementation MatDetaleViewController

@synthesize tbl;
@synthesize savedArray;
@synthesize innerArrayMaterial;

@synthesize nameValueMaterial;
@synthesize widthValueMaterial;
@synthesize priceValueMaterial;


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
    NSLog(@"viewDidLoad has worked");
    
    //передаем данные из функции Read класс MaterialServise в объект mathModel
    savedArray = [MaterialServise Read];

    
    //инициализируем объекты массива и материала
    self.innerArrayMaterial = [NSMutableArray array];
    MathModel *exemplarMaterial;
    
    
    //цыкл для загрузки данных
    //извлечение счетчика колличества сохраненных объектов count
    NSUserDefaults *count = [NSUserDefaults standardUserDefaults];
    NSString *strCount = [count objectForKey:@"countCicle"];
    int intCount = [strCount integerValue];
    
    
    //добавляем первый материал если счетчик колличества материалов равен 0
    //задаем нулевой объект
    if (intCount == 0) {
        //заполняем нулевой объект данными
        exemplarMaterial = [[MathModel alloc] init];
        exemplarMaterial.nameMaterial = @"первый материал";
        exemplarMaterial.widthMaterial = @"ширина";
        exemplarMaterial.priceMaterial = @"цена";
        exemplarMaterial.idMaterial = @"0";
        //заполняем ячейку массива материалов по индексу
        [innerArrayMaterial addObject:exemplarMaterial];
    }
    
    
    //пересоздаем материалы в контроллере из памяти
    int n = 0;
    while (n!=intCount) {
        //инициализируем новый объект материала для заполнения
        exemplarMaterial = [[MathModel alloc] init];
        NSUserDefaults *materials = [NSUserDefaults standardUserDefaults];
        [exemplarMaterial setNameMaterial:[materials objectForKey:[NSString stringWithFormat:@"nameMaterialObject%d", n]]];
        [exemplarMaterial setWidthMaterial:[materials objectForKey:[NSString stringWithFormat:@"widthMaterialObject%d", n]]];
        [exemplarMaterial setPriceMaterial:[materials objectForKey:[NSString stringWithFormat:@"priceMaterialObject%d", n]]];
        [exemplarMaterial setIdMaterial:[materials objectForKey:[NSString stringWithFormat:@"idMaterialObject%d", n]]];
        
        [innerArrayMaterial addObject:exemplarMaterial];
        n++;
    }  
    
    //чистим настройки в plist
    n = 50;
    while (n>=intCount) {
        NSUserDefaults *materials = [NSUserDefaults standardUserDefaults];
        //удаляем настройки из plist
        [materials removeObjectForKey:[NSString stringWithFormat:@"nameMaterialObject%d", n]];
        [materials removeObjectForKey:[NSString stringWithFormat:@"widthMaterialObject%d", n]];
        [materials removeObjectForKey:[NSString stringWithFormat:@"priceMaterialObject%d", n]];
        [materials removeObjectForKey:[NSString stringWithFormat:@"idMaterialObject%d", n]];     
        n--;
    }
    
    
    //подготовка к отправке данных в MaterialServise
    MaterialServise *modelMaterialServise = [[MaterialServise alloc] init];
    [modelMaterialServise SaveMaterial:innerArrayMaterial];
    
    
    //добавляем кнопку редактирования 
    UIBarButtonItem *edit =[[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                             target:self
                             action:@selector(editing)];
    self.navigationItem.rightBarButtonItem = edit;
}


//нажатие на кнопку добавить
- (IBAction)addBtn:(id)sender {
    NSLog(@"addBtn has worked");
    
    //создаем экземпляр нового материала
    MathModel *exemplarMaterial;
    //заполняем экземпляр статичными данными
    exemplarMaterial = [[MathModel alloc] init];
    exemplarMaterial.nameMaterial = @"Новый материал";
    exemplarMaterial.widthMaterial = @"";
    exemplarMaterial.priceMaterial = @"";
    //присваиваем id материалу по числу count
    exemplarMaterial.idMaterial = [NSString stringWithFormat:@"%d", innerArrayMaterial.count];
    [innerArrayMaterial addObject:exemplarMaterial];
    
    
    //подготовка к отправке данных в MaterialServise
    MaterialServise *modelMaterialServise = [[MaterialServise alloc] init];
    [modelMaterialServise SaveMaterial:innerArrayMaterial];
    
    
    //передаем данные из функции Read класс MaterialServise в объект mathModel
    savedArray = [MaterialServise Read];
    
    
    //пересобираем таблицу
    [tbl reloadData];
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
        NSLog(@"delete cell is worked");
        //удаляем ячейку с материалом непосредственно из массива
        [innerArrayMaterial removeObjectAtIndex:indexPath.row];

        
        //подготовка к отправке данных в MaterialServise
        MaterialServise *modelMaterialServise = [[MaterialServise alloc] init];
        [modelMaterialServise SaveMaterial:innerArrayMaterial];
        
        
        //передаем данные из функции Read класс MaterialServise в объект savedArray
        savedArray = [MaterialServise Read];

        
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

    return savedArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *const CellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    
    NSLog(@"Cell %d is filled", indexPath.row);
    //создаем объект ячейки из массива данных
    MathModel *exemplarMaterial = [savedArray objectAtIndex:indexPath.row];
    cell.textLabel.text = exemplarMaterial.nameMaterial;
    cell.detailTextLabel.text = exemplarMaterial.widthMaterial;
    
    return cell;
}


//отслеживание segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath *indexPath = [self.tbl indexPathForSelectedRow];
    
    if (indexPath) {
        MathModel *exemplarMaterial = [savedArray objectAtIndex:indexPath.row];
        [segue.destinationViewController setDetail:exemplarMaterial];
        NSLog(@"array MathModel worked with segue %d", indexPath.row);
    }
}


//анимация затухания выделения ячейки при возвращении в таблицу
- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidApear is worked");
    
    NSIndexPath *selectedIndexPath = [self.tbl indexPathForSelectedRow];
    
    [super viewDidAppear:animated];
    
    if (selectedIndexPath) {
        //изменяем данные в массиве
        MathModel *changedMaterial = [[MathModel alloc] init];
        changedMaterial = [innerArrayMaterial objectAtIndex:selectedIndexPath.row];
        
        //извлекаем данные из памяти
        NSUserDefaults *materials =[NSUserDefaults standardUserDefaults];
        [changedMaterial setNameMaterial:[materials objectForKey:[NSString stringWithFormat:@"nameMaterialObject%d", selectedIndexPath.row]]];
        [changedMaterial setWidthMaterial:[materials objectForKey:[NSString stringWithFormat:@"widthMaterialObject%d", selectedIndexPath.row]]];
        [changedMaterial setPriceMaterial:[materials objectForKey:[NSString stringWithFormat:@"priceMaterialObject%d", selectedIndexPath.row]]];
        [changedMaterial setIdMaterial:[materials objectForKey:[NSString stringWithFormat:@"idMaterialObject%d", selectedIndexPath.row]]];
        
        //записываем объект материала обратно в массив
        [innerArrayMaterial replaceObjectAtIndex:selectedIndexPath.row withObject:changedMaterial];
        
        //передаем массив для обработки классом MaterialService
        MaterialServise *modelMaterialServise = [[MaterialServise alloc] init];
        [modelMaterialServise SaveMaterial:innerArrayMaterial];
        
        //передаем сохраненный массив из функции Read класс MaterialServise
        savedArray = [MaterialServise Read];
        
        [self.tbl reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        NSLog(@"condition in viewWillApear has worked");
    }
    
    [self.tbl deselectRowAtIndexPath:[self.tbl indexPathForSelectedRow] animated:YES];
    
}


@end




















