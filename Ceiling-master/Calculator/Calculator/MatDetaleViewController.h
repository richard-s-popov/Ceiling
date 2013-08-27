//
//  MatDetaleViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 15.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MathModel.h"
#import "MaterialServise.h"
#import "MathSingleViewController.h"
#import "MaterialCell.h"

@interface MatDetaleViewController : UIViewController <UITableViewDelegate , UITableViewDataSource> {

    NSMutableArray *items;
    NSMutableArray *dataMaterial;
    NSMutableArray *innerArrayMaterial;
    
}

@property (nonatomic, retain) NSMutableArray *innerArrayMaterial;
@property (nonatomic, strong) NSArray *savedArray;
@property (weak, nonatomic) IBOutlet UITableView *tbl;

@property (nonatomic, strong) NSString *nameValueMaterial;
@property (nonatomic, strong) NSString *widthValueMaterial;
@property (nonatomic, strong) NSString *priceValueMaterial;


@end
