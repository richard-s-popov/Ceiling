//
//  Projects.h
//  Calculator
//
//  Created by Александр Коровкин on 23.09.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Projects : NSManagedObject

@property (nonatomic, retain) NSString * projectAdress;
@property (nonatomic, retain) NSNumber * projectBypass;
@property (nonatomic, retain) NSString * projectExplane;
@property (nonatomic, retain) NSNumber * projectLuster;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSNumber * projectSpot;
@property (nonatomic, retain) NSDate * created;

@end
