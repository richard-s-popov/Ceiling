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

#import "CalcAppDelegate.h"
#import "Projects.h"
#import "ProjectDetailViewController.h"
#import "ProjectCell.h"

@interface ProjectsListViewController : UIViewController <UITableViewDelegate , UITableViewDataSource> {

    NSString *lustName;
    NSString *lustAdress;

}

@property (nonatomic) NSArray *savedProjects;
@property (nonatomic, retain) NSMutableArray *clientsList;
@property (nonatomic, strong) NSNumber *projectsCount;
@property (nonatomic, strong) UITextView *explaneText;


@property (nonatomic, strong) NSManagedObjectContext *managedObjectsContent;
@property (strong, nonatomic) IBOutlet UITableView *tbl;
@property (strong, nonatomic) NSArray *projectsArray;

@end
