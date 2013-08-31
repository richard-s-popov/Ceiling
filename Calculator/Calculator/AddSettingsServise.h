//
//  AddSettingsServise.h
//  Calculator
//
//  Created by Александр Коровкин on 31.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddSettingsModel.h"
#import "AddSettingsViewController.h"

@interface AddSettingsServise : NSObject

@property (strong, nonatomic) AddSettingsModel *exampleAdditional;

- (void)Save:(AddSettingsModel *)model;

- (AddSettingsModel *)Read;

@end
