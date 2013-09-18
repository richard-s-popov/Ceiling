//
//  AddSettingsViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 31.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPrice.h"
#import "CalcAppDelegate.h"

@interface AddSettingsViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *lusterTextField;
@property (weak, nonatomic) IBOutlet UITextField *bypassTextField;
@property (weak, nonatomic) IBOutlet UITextField *spotTextField;

@property (nonatomic, strong) AddPrice *addPrice;
@property (nonatomic, strong) NSArray *fetchArray;
@property (nonatomic, strong) NSManagedObjectID *managedObjectId;

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end
