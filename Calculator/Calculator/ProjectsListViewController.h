//
//  ProjectsListViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectsListViewController : UITableViewController {

    NSMutableArray *clientsList;

}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@property (nonatomic) NSArray *savedProjects;

- (IBAction)menuBtn:(id)sender;
@property (nonatomic, retain) NSMutableArray *clientsList;
@property (strong, nonatomic) IBOutlet UITableView *tbl;

@end