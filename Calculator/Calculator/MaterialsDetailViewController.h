//
//  MaterialsDetailViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 16.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalcAppDelegate.h"
#import "Materials.h"
@class MaterialsListViewController;

@interface MaterialsDetailViewController : UIViewController <UITextFieldDelegate> {
    NSArray *list;
}

@property (weak, nonatomic) IBOutlet UILabel *matName;
@property (weak, nonatomic) IBOutlet UILabel *matPrice;

@property (weak, nonatomic) IBOutlet UITextField *editMaterialName;
@property (weak, nonatomic) IBOutlet UITextField *editMaterialWidth;
@property (weak, nonatomic) IBOutlet UITextField *editMaterialPrice;

@property (nonatomic, strong) Materials *material;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectID *managedObjectId;

- (IBAction)saveBtn:(id)sender;
@end
