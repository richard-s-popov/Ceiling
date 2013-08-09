//
//  SettingsService.h
//  Calculator
//
//  Created by Александр Коровкин on 08.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsOptionsModel.h"
#import "SettingsViewController.h"

@interface SettingsService : NSObject

- (void)Save:(SettingsOptionsModel *)model;

- (SettingsOptionsModel *)Read;

@end
