//
//  NewProjectListViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 23.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CalcAppDelegate.h"
#import "Projects.h"
#import "NewProjectDetailViewController.h"

@interface NewProjectListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    NSIndexPath *indexPathSegue;
    int indexPathRow;
    
    NSString *lastName;
    NSString *lastAdress;
    BOOL *_cellSwiped;
}

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *projectArray;
@property (nonatomic, strong) IBOutlet UITableView *tbl;
@property (nonatomic, strong) NSMutableArray *mutableArray;



@end
