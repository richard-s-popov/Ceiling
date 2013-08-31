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

@property (weak,nonatomic) NSString *countDetailProject;

+ (void)ClearProject;
- (void)SaveProject:(NSMutableArray *)projects;
+ (NSMutableArray *)Read;
+ (ProjectModel *)ZeroProject;

//СЕРВИС ДЛЯ DETAIL
- (void)SaveDetail:(ProjectModel *)newDetail;
- (ProjectModel *)changeDetailProject;
@end
