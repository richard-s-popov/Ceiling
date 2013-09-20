//
//  MaterialsListViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 16.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Materials.h"
#import "CalcAppDelegate.h"
#import "MaterialCell.h"
#import "MaterialsDetailViewController.h"

@interface MaterialsListViewController : UIViewController <UITableViewDelegate , UITableViewDataSource> {

    NSString *lustName;
    NSNumber *lustWidth;
    NSNumber *lustPrice;
}

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSData *created;


@property (strong, nonatomic) IBOutlet UITableView *tbl;
@property (nonatomic, strong) NSArray *list;

@end
