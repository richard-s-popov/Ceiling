//
//  ProjectServise.h
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectDetailViewController.h"
#import "ProjectsListViewController.h"
#import "ProjectModel.h"

@interface ProjectServise : NSObject

- (void)SaveProject:(NSMutableArray *)projects;
+ (NSMutableArray *)Read;

@end
