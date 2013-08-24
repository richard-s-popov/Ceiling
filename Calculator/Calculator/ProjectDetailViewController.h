//
//  ProjectDetailViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDetailViewController : UIViewController <UITextFieldDelegate>

@property ( nonatomic) IBOutlet UITextField *nameClient;
@property (weak, nonatomic) IBOutlet UITextField *adressClient;
@property (nonatomic) int editCount;
@property (strong, nonatomic) IBOutlet UIView *viewProject;
@property (weak, nonatomic) IBOutlet UITextView *explaneTextView;


@end
