//
//  MaterialServise.m
//  Calculator
//
//  Created by Александр Коровкин on 16.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "MaterialServise.h"

@implementation MaterialServise

- (void)SaveMaterial:(NSMutableArray *)model {
    
    
    //сохранение счетчика
    NSUserDefaults *count = [NSUserDefaults standardUserDefaults];
    [count setObject:[NSString stringWithFormat:@"%d", model.count] forKey:@"countCicle"];
    [count synchronize];
    //преобразование счетчика в integer
    NSString *strCount = [count objectForKey:@"countCicle"];
    int intCount = [strCount integerValue];
    
    
    //цыкл для сохранения данных
    int n = 0;
    while (n!=intCount) {
        //создание объекта материала на основе индекса массива
        MathModel *exemplarMaterial = [model objectAtIndex:n];
        //сохранение данных переданных из класса MatDetaleViewController
        NSUserDefaults *materials = [NSUserDefaults standardUserDefaults];
        [materials setObject:[exemplarMaterial nameMaterial] forKey:[NSString stringWithFormat:@"nameMaterialObject%d", n]];
        [materials setObject:[exemplarMaterial widthMaterial] forKey:[NSString stringWithFormat:@"widthMaterialObject%d", n]];
        [materials setObject:[exemplarMaterial priceMaterial] forKey:[NSString stringWithFormat:@"priceMaterialObject%d", n]];
        [materials setObject:[NSString stringWithFormat:@"%d", n] forKey:[NSString stringWithFormat:@"idMaterialObject%d", n]];
        [materials synchronize];
        //увеличиваем счетчик
        n++;
    }
}


+ (NSMutableArray *)Read {
    
    
    NSMutableArray *resultMaterials = [[NSMutableArray alloc] init];
    MathModel *savedMaterial;
    
    
    //извлечение счетчика count
    NSUserDefaults *count = [NSUserDefaults standardUserDefaults];
    NSString *strCount = [count objectForKey:@"countCicle"];
    int intCount = [strCount integerValue];
    
    
    //цыкл основанный на общем колличестве материалов в массиве
    int n = 0;
    while (n!=intCount) {
        //создание объекта материала для сохранения данных
        savedMaterial = [[MathModel alloc] init];
        //извлечение данных материала из plist по очередности
        NSUserDefaults *materials = [NSUserDefaults standardUserDefaults];
        [savedMaterial setNameMaterial:[materials objectForKey:[NSString stringWithFormat:@"nameMaterialObject%d", n]]];
        [savedMaterial setWidthMaterial:[materials objectForKey:[NSString stringWithFormat:@"widthMaterialObject%d", n]]];
        [savedMaterial setPriceMaterial:[materials objectForKey:[NSString stringWithFormat:@"priceMaterialObject%d", n]]];
        [savedMaterial setIdMaterial:[materials objectForKey:[NSString stringWithFormat:@"idMaterialObject%d", n]]];
        //добавление объекта материала в массив предназначенный для дальнейшей передачи данных в контроллер
        [resultMaterials addObject:savedMaterial];
        //увеличиваем счетчик
        n++;
    }
    
    
    return resultMaterials;
}


- (MathModel *)ZeroMaterial {

    MathModel *exemplarMaterial = [[MathModel alloc] init];
    
    exemplarMaterial.nameMaterial = @"название материала";
    exemplarMaterial.widthMaterial = @"";
    exemplarMaterial.priceMaterial = @"";
    exemplarMaterial.idMaterial = @"0";
    
    return exemplarMaterial;
}


//чистим память
-(void)ClearStorage {
    
    NSUserDefaults *count = [NSUserDefaults standardUserDefaults];
    NSString *strCount = [count objectForKey:@"countCicle"];
    int intCount = [strCount integerValue];

    int n = 50;
    while (n>=intCount) {
        NSUserDefaults *materials = [NSUserDefaults standardUserDefaults];
        //удаляем настройки из plist
        [materials removeObjectForKey:[NSString stringWithFormat:@"nameMaterialObject%d", n]];
        [materials removeObjectForKey:[NSString stringWithFormat:@"widthMaterialObject%d", n]];
        [materials removeObjectForKey:[NSString stringWithFormat:@"priceMaterialObject%d", n]];
        [materials removeObjectForKey:[NSString stringWithFormat:@"idMaterialObject%d", n]];
        n--;
    }
}


-(void)SaveDetail:(MathModel *)savedMaterial {
    
    NSLog(@"SaveDetail = %@ %@ %@ %@", savedMaterial.nameMaterial, savedMaterial.widthMaterial, savedMaterial.priceMaterial, savedMaterial.idMaterial);

    NSUserDefaults *materials = [NSUserDefaults standardUserDefaults];
    
    [materials setObject:savedMaterial.nameMaterial forKey:[NSString stringWithFormat:@"nameMaterialObject%@", savedMaterial.idMaterial]];
    [materials setObject:savedMaterial.widthMaterial forKey:[NSString stringWithFormat:@"widthMaterialObject%@", savedMaterial.idMaterial]];
    [materials setObject:savedMaterial.priceMaterial forKey:[NSString stringWithFormat:@"priceMaterialObject%@", savedMaterial.idMaterial]];
    [materials setObject:savedMaterial.idMaterial forKey:[NSString stringWithFormat:@"idMaterialObject%@", savedMaterial.idMaterial]];
    
    [materials synchronize];
}

-(MathModel *)ReadDetail {
    
    MathModel *exemplarMaterial = [[MathModel alloc] init];
    
    NSUserDefaults *materials =[NSUserDefaults standardUserDefaults];
    NSString *count = [materials objectForKey:@"lustMaterial"];
    
    exemplarMaterial.nameMaterial = [materials objectForKey:[NSString stringWithFormat:@"nameMaterialObject%@", count]];
    exemplarMaterial.widthMaterial = [materials objectForKey:[NSString stringWithFormat:@"widthMaterialObject%@", count]];
    exemplarMaterial.priceMaterial = [materials objectForKey:[NSString stringWithFormat:@"priceMaterialObject%@", count]];
    exemplarMaterial.idMaterial = [materials objectForKey:[NSString stringWithFormat:@"idMaterialObject%@", count]];
    
    return exemplarMaterial;
}

@end
