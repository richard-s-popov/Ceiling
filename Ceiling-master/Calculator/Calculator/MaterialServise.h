//
//  MaterialServise.h
//  Calculator
//
//  Created by Александр Коровкин on 16.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MathModel.h"
#import "MatDetaleViewController.h"

@interface MaterialServise : NSObject


- (void)SaveMaterial:(NSMutableArray *)model;
+ (NSMutableArray *)Read;

@end
