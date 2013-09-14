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
    
//    exampleAdditional = [[AddSettingsModel alloc] init];
//    exampleAdditional = model;
//    
//    NSUserDefaults *addittionaly = [NSUserDefaults standardUserDefaults];
//    
//    [addittionaly setObject:[exampleAdditional lusterPrice] forKey:@"lusterPrice"];
//    [addittionaly setObject:[exampleAdditional bypassPrice] forKey:@"bypassPrice"];
//    [addittionaly setObject:[exampleAdditional spotPrice] forKey:@"spotPrice"];
//    
//    
//    NSLog(@"luster = %@",[addittionaly objectForKey:@"lusterPrice"]);
//    [addittionaly synchronize];
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
    
    NSLog(@"newLuster: %@", newPrice.lusterPrice);
    
//    exampleAdditional = [[AddSettingsModel alloc] init];
//
//    NSUserDefaults *addittionaly = [NSUserDefaults standardUserDefaults];
//    [exampleAdditional setLusterPrice:[addittionaly objectForKey:@"lusterPrice"]];
//    [exampleAdditional setBypassPrice:[addittionaly objectForKey:@"bypassPrice"]];
//    [exampleAdditional setSpotPrice:[addittionaly objectForKey:@"spotPrice"]];
    
    return newPrice;
}

@end
