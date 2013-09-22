//
//  NewProjectDetailViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 23.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewProjectListViewController.h"
#import "CalcAppDelegate.h"
#import "Projects.h"

@interface NewProjectDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>


@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Projects *project;

@property (strong, nonatomic) IBOutlet UITextField *nameClient;
@property (strong, nonatomic) IBOutlet UITextField *adressClient;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *lusterClient;
@property (strong, nonatomic) IBOutlet UITextField *bypassClient;
@property (strong, nonatomic) IBOutlet UITextField *spotClient;
@property (strong, nonatomic) IBOutlet UITextView *explaneClient;


@end
