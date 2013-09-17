//
//  AddSettingsViewController.m
//  Calculator
//
//  Created by Александр Коровкин on 31.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import "AddSettingsViewController.h"

@interface AddSettingsViewController ()

@end

@implementation AddSettingsViewController
@synthesize lusterTextField;
@synthesize bypassTextField;
@synthesize spotTextField;
@synthesize managedObjectContext;
@synthesize addPrice;
@synthesize fetchArray;
@synthesize managedObjectId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSManagedObjectContext *)managedObjectContext {
    return [(CalcAppDelegate *)[[UIApplication sharedApplication]delegate] managedObjectContext];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"AddPrice"];
    NSError *error = nil;
    
    fetchArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchArray.count == 0) {
        addPrice = [NSEntityDescription insertNewObjectForEntityForName:@"AddPrice" inManagedObjectContext:self.managedObjectContext];
        
        if (![self.managedObjectContext save:&error]) {
        }
    }
    
    addPrice = [fetchArray objectAtIndex:0];
    if (addPrice != nil) {
        lusterTextField.text = [addPrice.lusterPrice stringValue];
        bypassTextField.text = [addPrice.bypassPrice stringValue];
        spotTextField.text = [addPrice.spotPrice stringValue];
    }
    else {
        lusterTextField.text = @"";
        bypassTextField.text = @"";
        spotTextField.text = @"";
    }
    
    //кнопка редактирования
    UIBarButtonItem *saveButton =[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                  target:self
                                  action:@selector(saveBtn)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveBtn {
    
    addPrice = [fetchArray objectAtIndex:0];
    addPrice.lusterPrice = [NSNumber numberWithInt:[lusterTextField.text intValue]];
    addPrice.bypassPrice = [NSNumber numberWithInt:[bypassTextField.text intValue]];
    addPrice.spotPrice = [NSNumber numberWithInt:[spotTextField.text intValue]];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
    }

    [self.navigationController popViewControllerAnimated:YES];
}
@end
