//
//  MatDetaleViewController.h
//  Calculator
//
//  Created by Александр Коровкин on 15.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MathModel.h"

@interface MatDetaleViewController : UIViewController <UITableViewDelegate , UITableViewDataSource> {

    NSMutableArray *items;
    NSArray *_data;
}

@property (weak, nonatomic) IBOutlet UITableView *tbl;
- (void) addNew;

@end
