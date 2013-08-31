//
//  MathSingleViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 15.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "MathSingleViewController.h"

@interface MathSingleViewController ()

@end

@implementation MathSingleViewController

@synthesize nameMaterialInDetail;
@synthesize priceMaterialInDetail;
@synthesize editMaterialName;
@synthesize editMaterialWidth;
@synthesize editMaterialPrice;
@synthesize idMaterial;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// скрываем клавиатуру по нажатию кнопки
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //поля материалов
    [editMaterialName resignFirstResponder];
    [editMaterialWidth resignFirstResponder];
    [editMaterialPrice resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    editMaterialName.delegate = self;
    editMaterialWidth.delegate = self;
    editMaterialPrice.delegate = self;
    
    //скрываем клавиатуру по нажатию на фон
    UITapGestureRecognizer *tapOnScrolView = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(dismissKeyboard)
                                              ];
    
    [self.view addGestureRecognizer:tapOnScrolView];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//передаем экземпляр материала по сигвэю
- (void) setDetail:(MathModel *)segueExemplarMaterial {

    _detail = segueExemplarMaterial;
}

- (void) reloadData {
    //изменяем titile и lable динамически
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", _detail.nameMaterial, _detail.widthMaterial];
    nameMaterialInDetail.text = [NSString stringWithFormat:@"%@ %@", _detail.nameMaterial, _detail.widthMaterial];
    priceMaterialInDetail.text =[NSString stringWithFormat:@"%@ руб/м2", _detail.priceMaterial];
    
    NSUserDefaults *materials = [NSUserDefaults standardUserDefaults];
    [materials setObject:_detail.idMaterial forKey:@"lustMaterial"];
    
    [materials synchronize];
    
    //вносим данные в поля
    editMaterialName.text = _detail.nameMaterial;
    editMaterialWidth.text = _detail.widthMaterial;
    editMaterialPrice.text = _detail.priceMaterial;
    
}

//действие по нажатию на кнопку сохранинея
- (IBAction)saveMaterialSingle:(id)sender {
    
    MathModel *exemplarMaterial = [[MathModel alloc] init];
    
    exemplarMaterial.nameMaterial = editMaterialName.text;
    exemplarMaterial.widthMaterial = editMaterialWidth.text;
    exemplarMaterial.priceMaterial = editMaterialPrice.text;
    exemplarMaterial.idMaterial = _detail.idMaterial;
    
    MaterialServise *contaner = [[MaterialServise alloc] init];
    [contaner SaveDetail:exemplarMaterial];
}


//метод скрытия клавиатуры по нажатию на фон
- (void)dismissKeyboard {
    
    [editMaterialName resignFirstResponder];
    [editMaterialWidth resignFirstResponder];
    [editMaterialPrice resignFirstResponder];

    
}

@end
