//
//  ProjectsListViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectsListViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtn;

- (IBAction)menuBtn:(id)sender;

@end
