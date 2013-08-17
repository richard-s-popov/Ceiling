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
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", _detail.nameMaterial, _detail.widthMaterial];
    
    nameMaterialInDetail.text = [NSString stringWithFormat:@"%@ %@", _detail.nameMaterial, _detail.widthMaterial];
    
    priceMaterialInDetail.text =[NSString stringWithFormat:@"%@ руб/м2", _detail.priceMaterial];
    
    
    
}

//действие по нажатию на кнопку сохранинея
- (IBAction)saveMaterialSingle:(id)sender {
    
    NSUserDefaults *materials = [NSUserDefaults standardUserDefaults];
    
    [materials setObject:editMaterialName.text forKey:[NSString stringWithFormat:@"nameMaterialObject%@", _detail.idMaterial]];
    [materials setObject:editMaterialWidth.text forKey:[NSString stringWithFormat:@"widthMaterialObject%@", _detail.idMaterial]];
    [materials setObject:editMaterialPrice.text forKey:[NSString stringWithFormat:@"priceMaterialObject%@", _detail.idMaterial]];
    
    [materials synchronize];
}
@end
