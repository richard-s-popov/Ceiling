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
    
    //вносим данные в поля
    editMaterialName.text = _detail.nameMaterial;
    editMaterialWidth.text = _detail.widthMaterial;
    editMaterialPrice.text = _detail.priceMaterial;
    
}

//действие по нажатию на кнопку сохранинея
- (IBAction)saveMaterialSingle:(id)sender {
    
    NSUserDefaults *materials = [NSUserDefaults standardUserDefaults];
    
    [materials setObject:editMaterialName.text forKey:[NSString stringWithFormat:@"nameMaterialObject%@", _detail.idMaterial]];
    [materials setObject:editMaterialWidth.text forKey:[NSString stringWithFormat:@"widthMaterialObject%@", _detail.idMaterial]];
    [materials setObject:editMaterialPrice.text forKey:[NSString stringWithFormat:@"priceMaterialObject%@", _detail.idMaterial]];
    
    [materials synchronize];
}


//метод скрытия клавиатуры по нажатию на фон
- (void)dismissKeyboard {
    
    [editMaterialName resignFirstResponder];
    [editMaterialWidth resignFirstResponder];
    [editMaterialPrice resignFirstResponder];

    
}

@end