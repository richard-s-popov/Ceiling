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

- (void)Save:(AddSettingsModel *)model {
    
    exampleAdditional = [[AddSettingsModel alloc] init];
    exampleAdditional = model;
    
    NSUserDefaults *addittionaly = [NSUserDefaults standardUserDefaults];
    
    [addittionaly setObject:[exampleAdditional lusterPrice] forKey:@"lusterPrice"];
    [addittionaly setObject:[exampleAdditional bypassPrice] forKey:@"bypassPrice"];
    [addittionaly setObject:[exampleAdditional spotPrice] forKey:@"spotPrice"];
    
    
    NSLog(@"luster = %@",[addittionaly objectForKey:@"lusterPrice"]);
    [addittionaly synchronize];
}

- (AddSettingsModel *)Read {
    
    exampleAdditional = [[AddSettingsModel alloc] init];
    
    NSUserDefaults *addittionaly = [NSUserDefaults standardUserDefaults];
    [exampleAdditional setLusterPrice:[addittionaly objectForKey:@"lusterPrice"]];
    [exampleAdditional setBypassPrice:[addittionaly objectForKey:@"bypassPrice"]];
    [exampleAdditional setSpotPrice:[addittionaly objectForKey:@"spotPrice"]];
    
    return exampleAdditional;
}

@end
