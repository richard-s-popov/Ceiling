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
        MaterialServise *contaner = [[MaterialServise alloc] init];
        exemplarMaterial = [contaner ZeroMaterial];
        
        //заполняем ячейку массива материалов по индексу
        [innerArrayMaterial addObject:exemplarMaterial];
    }
    
    
    //пересоздаем материалы в контроллере из памяти
    int n = 0;
    while (n!=intCount) {
        
        //перезаполняем массив
        [innerArrayMaterial addObject:[savedArray objectAtIndex:n]];
        n++;
    }  
    
    //чистим настройки в plist
    MaterialServise *clear = [[MaterialServise alloc] init];
    [clear ClearStorage];
    
    
    //подготовка к отправке данных в MaterialServise
    MaterialServise *modelMaterialServise = [[MaterialServise alloc] init];
    [modelMaterialServise SaveMaterial:innerArrayMaterial];
    
    //передаем данные из функции Read класс MaterialServise в объект mathModel
    savedArray = [MaterialServise Read];
    
    //кнопка редактирования
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}


//нажатие на кнопку добавить
- (void)addBtn {
    
    //заполняем нулевой объект данными
    MaterialServise *contaner = [[MaterialServise alloc] init];
    MathModel *exemplarMaterial = [contaner ZeroMaterial];
    
    //заполняем ячейку массива материалов по индексу
    [innerArrayMaterial addObject:exemplarMaterial];
    
    
    //подготовка к отправке данных в MaterialServise
    MaterialServise *modelMaterialServise = [[MaterialServise alloc] init];
    [modelMaterialServise SaveMaterial:innerArrayMaterial];
    
    
    //передаем данные из функции Read класс MaterialServise в объект mathModel
    savedArray = [MaterialServise Read];
    
    
    //пересобираем таблицу
    [tbl reloadData];
}


-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:!self.tbl.editing animated:animated];
    [tbl setEditing:editing animated:animated];
    
    if (editing) {
        
        //добавляем кнопку добавления материала
        UIBarButtonItem *addButton =[[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                     target:self
                                     action:@selector(addBtn)];
        self.navigationItem.leftBarButtonItem = addButton;
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    else {
        
        //добавляем кнопку добавления материала
        self.navigationItem.leftItemsSupplementBackButton = YES;
        self.navigationItem.leftBarButtonItem = NO;
    }
}


//описание метода редактирования
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
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
    MaterialCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (cell == nil) {
        cell = [[MaterialCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
    }
    
    //создаем объект ячейки из массива данных
    MathModel *exemplarMaterial = [savedArray objectAtIndex:indexPath.row];

    cell.priceCell.text = exemplarMaterial.priceMaterial;
    cell.nameCell.text = exemplarMaterial.nameMaterial;
    cell.widthCell.text = [NSString stringWithFormat:@"%@ - ширина полотна", exemplarMaterial.widthMaterial];
    
    return cell;
}


//отслеживание segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSIndexPath *indexPath = [self.tbl indexPathForSelectedRow];
    
    if (indexPath) {
        MathModel *exemplarMaterial = [savedArray objectAtIndex:indexPath.row];
        [segue.destinationViewController setDetail:exemplarMaterial];
    }
}


//анимация затухания выделения ячейки при возвращении в таблицу
- (void) viewDidAppear:(BOOL)animated {
    
    NSIndexPath *selectedIndexPath = [self.tbl indexPathForSelectedRow];
    
    [super viewDidAppear:animated];
    
    //изменяем данные в массиве
    MathModel *changedMaterial = [[MathModel alloc] init];
    changedMaterial = [innerArrayMaterial objectAtIndex:selectedIndexPath.row];
        
    //извлекаем данные из памяти
    MathModel *newData = [[MathModel alloc] init];
    MaterialServise *contaner = [[MaterialServise alloc] init];
    newData = [contaner ReadDetail];
        
    //проверяем изменились ли данные
    if ((selectedIndexPath) && ((changedMaterial.nameMaterial != newData.nameMaterial) || (changedMaterial.widthMaterial != newData.widthMaterial) || (changedMaterial.priceMaterial != newData.priceMaterial))) {
        
        [changedMaterial setNameMaterial:newData.nameMaterial];
        [changedMaterial setWidthMaterial:newData.widthMaterial];
        [changedMaterial setPriceMaterial:newData.priceMaterial];
        [changedMaterial setIdMaterial:newData.idMaterial];
        
        //записываем объект материала обратно в массив
        [innerArrayMaterial replaceObjectAtIndex:selectedIndexPath.row withObject:changedMaterial];
        
        //передаем массив для обработки классом MaterialService
        MaterialServise *modelMaterialServise = [[MaterialServise alloc] init];
        [modelMaterialServise SaveMaterial:innerArrayMaterial];
        
        //передаем сохраненный массив из функции Read класс MaterialServise
        savedArray = [MaterialServise Read];
        
        [self.tbl reloadRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    [self.tbl deselectRowAtIndexPath:[self.tbl indexPathForSelectedRow] animated:YES];
    
}


@end




















