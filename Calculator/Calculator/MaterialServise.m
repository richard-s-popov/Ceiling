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
        
        MathModel *mathModelInner = [model objectAtIndex:n];
        NSLog(@"\n \n сохрание step1 - %@", mathModelInner.nameMaterial);
        
        //сохранение данных переданных из класса MatDetaleViewController
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:[mathModelInner nameMaterial] forKey:[NSString stringWithFormat:@"nameMaterialKey%d", n]];
        [defaults setObject:[mathModelInner widthMaterial] forKey:[NSString stringWithFormat:@"widthMaterialKey%d", n]];
        [defaults setObject:[mathModelInner priceMaterial] forKey:[NSString stringWithFormat:@"priseMaterialKey%d", n]];
        
        [defaults synchronize];
        
        n++;//увеличиваем счетчик
    }
    
}


+ (NSMutableArray *)Read {
    
    NSMutableArray *resultMaterials = [[NSMutableArray alloc] init];
    
    MathModel *savedMaterial;
    
    NSUserDefaults *count = [NSUserDefaults standardUserDefaults];
    NSString *strCount = [count objectForKey:@"countCicle"];
    int intCount = [strCount integerValue];
    
    int n = 0;
    while (n!=intCount) {
        savedMaterial = [[MathModel alloc] init];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [savedMaterial setNameMaterial:[defaults objectForKey:[NSString stringWithFormat:@"nameMaterialKey%d", n]]];
        [savedMaterial setWidthMaterial:[defaults objectForKey:[NSString stringWithFormat:@"widthMaterialKey%d", n]]];
        [savedMaterial setPriceMaterial:[defaults objectForKey:[NSString stringWithFormat:@"priseMaterialKey%d", n]]];
        
        [resultMaterials addObject:savedMaterial];
        
        //лог о сохранненном объекте
        NSLog(@"сохранен объект:\n %@ \n %@ \n %@",[defaults objectForKey:[NSString stringWithFormat:@"nameMaterialKey%d", n]]);
        
        n++;//увеличиваем счетчик
    }
    
    return resultMaterials;
}

@end
