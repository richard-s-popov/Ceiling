//
//  ProjectsListViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "ProjectModel.h"
#import "ProjectDetailViewController.h"
#import "ProjectServise.h"

@interface ProjectsListViewController : UIViewController <UITableViewDelegate , UITableViewDataSource> {

    NSMutableArray *clientsList;
}

@property (nonatomic) NSArray *savedProjects;

@property (nonatomic, retain) NSMutableArray *clientsList;
@property (strong, nonatomic) IBOutlet UITableView *tbl;
@property (nonatomic, strong) NSNumber *projectsCount;

@end
