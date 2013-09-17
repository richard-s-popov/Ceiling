//
//  AddSettingsServise.m
//  Calculator
//
//  Created by Александр Коровкин on 31.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "AddSettingsServise.h"


@implementation AddSettingsServise
@synthesize exampleAdditional;
@synthesize priceArray;

- (void)Save:(AddSettingsModel *)model {
    
    //создаем синглтон AppDelegate
    CalcAppDelegate *calcAppDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *_managedObjectContext = [calcAppDelegate managedObjectContext];
    
    AddPrice *addPrice = [NSEntityDescription insertNewObjectForEntityForName:@"AddPrice" inManagedObjectContext:_managedObjectContext];
    
    addPrice.lusterPrice = model.lusterPrice;
    addPrice.bypassPrice = model.bypassPrice;
    addPrice.spotPrice = model.spotPrice;
    
    NSError *error = nil;
    
    
    if (![_managedObjectContext save:&error]) {
    }
}

- (AddSettingsModel *)Read {
    
    //создаем синглтон AppDelegate
    CalcAppDelegate *calcAppDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *_managedObjectContext = [calcAppDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AddPrice" inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    
    NSError *error =nil;
    NSArray *fetchArray = [_managedObjectContext executeFetchRequest:request error:&error];
    AddPrice *lastPrice = [fetchArray lastObject];
    
    AddSettingsModel *newPrice = [[AddSettingsModel alloc]init];
    newPrice.lusterPrice = lastPrice.lusterPrice;
    newPrice.bypassPrice = lastPrice.bypassPrice;
    newPrice.spotPrice = lastPrice.spotPrice;
    

    return newPrice;
}

@end
