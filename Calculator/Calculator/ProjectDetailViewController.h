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

@interface ProjectDetailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property ( nonatomic) IBOutlet UITextField *nameClient;
@property (weak, nonatomic) IBOutlet UITextField *adressClient;
@property (nonatomic) int editCount;
@property (strong, nonatomic) IBOutlet UIView *viewProject;
@property (nonatomic, strong) IBOutlet UITextView *explaneTextView;
@property (nonatomic, strong) ProjectModel *detail;

@property (weak, nonatomic) IBOutlet UITextField *lusterClient;
@property (weak, nonatomic) IBOutlet UITextField *bypassClient;
@property (weak, nonatomic) IBOutlet UITextField *spotClient;

@property (weak, nonatomic) IBOutlet UIScrollView *settingsScroller;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end