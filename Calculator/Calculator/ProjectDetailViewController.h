//
//  ProjectDetailViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectsListViewController.h"
#import "ProjectModel.h"
#import "ProjectServise.h"
#import "CostViewController.h"

#import "Projects.h"

@interface ProjectDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>


@property (nonatomic) int editCount;
@property (strong, nonatomic) IBOutlet UIView *viewProject;
@property (nonatomic, strong) IBOutlet UITextView *explaneTextView;

@property (weak, nonatomic) IBOutlet UIScrollView *settingsScroller;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property ( nonatomic) IBOutlet UITextField *nameClient;
@property (weak, nonatomic) IBOutlet UITextField *adressClient;
@property (weak, nonatomic) IBOutlet UITextField *lusterClient;
@property (weak, nonatomic) IBOutlet UITextField *bypassClient;
@property (weak, nonatomic) IBOutlet UITextField *spotClient;

@property (nonatomic, strong) Projects *project;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)Cost:(id)sender;
- (IBAction)Email:(id)sender;

@end