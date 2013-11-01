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
    [defaults setObject:[model userMail] forKey:@"savedUserEmail"];
    
    [defaults setObject:[model managerName] forKey:@"savedManagerName"];
    [defaults setObject:[model managerPhone] forKey:@"savedManagerPhone"];
    [defaults setObject:[model managerMail] forKey:@"savedManagerEmail"];
    
    [defaults setObject:[model manufactoryPhone] forKey:@"savedManufactoryPhone"];
    [defaults setObject:[model manufactoryMail] forKey:@"savedManufactoryEmail"];
    
    [defaults synchronize];
}

- (SettingsOptionsModel *)Read {
    
    SettingsOptionsModel *contacts = [[SettingsOptionsModel alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [contacts setUserName:[defaults objectForKey:@"savedUserName"]];
    [contacts setUserPhone:[defaults objectForKey:@"savedUserPhone"]];
    [contacts setUserMail:[defaults objectForKey:@"savedUserEmail"]];
    
    [contacts setManagerName:[defaults objectForKey:@"savedManagerName"]];
    [contacts setManagerPhone:[defaults objectForKey:@"savedManagerPhone"]];
    [contacts setManagerMail:[defaults objectForKey:@"savedManagerEmail"]];
    
    [contacts setManufactoryPhone:[defaults objectForKey:@"savedManufactoryPhone"]];
    [contacts setManufactoryMail:[defaults objectForKey:@"savedManufactoryEmail"]];
    
    
    return contacts;
}

@end
