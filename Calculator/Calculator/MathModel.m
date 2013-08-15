//
//  MathModel.m
//  Calculator
//
//  Created by Александр Коровкин on 15.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "MathModel.h"

@implementation MathModel

//вызываем метод
+ (NSArray *)fetchData {

    //обоъявляем изменяемый массив
    NSMutableArray *resultMatData = [NSMutableArray array];
    
    //создаем объект класса для внесения данных в массив
    MathModel *itemMatData;
    
    itemMatData = [[MathModel alloc] init];
    itemMatData.nameMaterial = @"Глянец";
    itemMatData.widthMaterial = @"150";
    itemMatData.priceMaterial = @"300";
    
    //записываем объект в массив
    [resultMatData addObject:itemMatData];
    
    
    itemMatData = [[MathModel alloc] init];
    itemMatData.nameMaterial = @"Сатин";
    itemMatData.widthMaterial = @"200";
    itemMatData.priceMaterial = @"350";
    
    [resultMatData addObject:itemMatData];
    
    
    itemMatData = [[MathModel alloc] init];
    itemMatData.nameMaterial = @"Матовый";
    itemMatData.widthMaterial = @"220";
    itemMatData.priceMaterial = @"380";
    
    [resultMatData addObject:itemMatData];
    
    return resultMatData;
    
}
@end
