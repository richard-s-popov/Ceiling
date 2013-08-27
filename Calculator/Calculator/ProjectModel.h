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
@property (nonatomic) NSString *clientLuster;
@property (nonatomic) NSString *clientSpot;
@property (nonatomic) NSString *clientBypass;
@property (nonatomic, weak) UIImage *clientPlan;
@property (nonatomic, weak) NSString *clientId;
@property (nonatomic, strong) UITextView *clientExplane;


@end
