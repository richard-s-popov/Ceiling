//
//  ProjectModel.h
//  Calculator
//
//  Created by Александр Коровкин on 22.08.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject

@property (nonatomic, weak) NSString *clientName;
@property (nonatomic, weak) NSString *clientAdress;
@property (nonatomic) NSInteger *clientLuster;
@property (nonatomic) NSInteger *clientSpot;
@property (nonatomic) NSInteger *clientBypass;
@property (nonatomic, weak) UIImage *clientPlan;
@property (nonatomic, weak) NSString *clientId;

@end
