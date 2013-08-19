//
//  MathSingleViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 15.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MathModel.h"
#import "MatDetaleViewController.h"
#import "MaterialServise.h"

@interface MathSingleViewController : UIViewController

@property (nonatomic, strong) MathModel *detail;
@property (weak, nonatomic) IBOutlet UILabel *nameMaterialInDetail;
@property (weak, nonatomic) IBOutlet UILabel *priceMaterialInDetail;

@property (weak, nonatomic) IBOutlet UITextField *editMaterialName;
@property (weak, nonatomic) IBOutlet UITextField *editMaterialWidth;
@property (weak, nonatomic) IBOutlet UITextField *editMaterialPrice;

@property (nonatomic, strong) NSString *idMaterial;

- (IBAction)saveMaterialSingle:(id)sender;

@end
