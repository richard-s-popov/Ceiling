//
//  SettingsService.m
//  Calculator
//
//  Created by Александр Коровкин on 08.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "SettingsService.h"

@implementation SettingsService

- (void)Save:(SettingsOptionsModel *)model {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[model userName] forKey:@"savedUserName"];
    [defaults setObject:[model userPhone] forKey:@"savedUserPhone"];
    [defaults setObject:[model userEmail] forKey:@"savedUserEmail"];
    
    [defaults setObject:[model managerName] forKey:@"savedManagerName"];
    [defaults setObject:[model managerPhone] forKey:@"savedManagerPhone"];
    [defaults setObject:[model managerEmail] forKey:@"savedManagerEmail"];
    
    [defaults setObject:[model manufactoryPhone] forKey:@"savedManufactoryPhone"];
    [defaults setObject:[model manufactoryEmail] forKey:@"savedManufactoryEmail"];
    
    [defaults synchronize];
}

- (SettingsOptionsModel *)Read {

    SettingsOptionsModel * savedModel = [SettingsOptionsModel new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [savedModel setUserName:[defaults objectForKey:@"savedUserName"]];
    [savedModel setUserPhone:[defaults objectForKey:@"savedUserPhone"]];
    [savedModel setUserEmail:[defaults objectForKey:@"savedUserEmail"]];
    
    [savedModel setManagerName:[defaults objectForKey:@"savedManagerName"]];
    [savedModel setManagerPhone:[defaults objectForKey:@"savedManagerPhone"]];
    [savedModel setManagerEmail:[defaults objectForKey:@"savedManagerEmail"]];
    
    [savedModel setManufactoryPhone:[defaults objectForKey:@"savedManufactoryPhone"]];
    [savedModel setManufactoryEmail:[defaults objectForKey:@"savedManufactoryEmail"]];
    
    return savedModel;
}

@end
