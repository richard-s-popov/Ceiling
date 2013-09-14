//
//  SettingsService.h
//  Calculator
//
//  Created by Александр Коровкин on 08.07.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsViewController.h"
#import "Contacts.h"
#import "CalcAppDelegate.h"

@interface SettingsService : NSObject

- (void)Save:(Contacts *)model;

- (Contacts *)Read;

@end
