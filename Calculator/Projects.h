//
//  Projects.h
//  Calculator
//
//  Created by Александр Коровкин on 04.11.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Plot;

@interface Projects : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * projectAdress;
@property (nonatomic, retain) NSNumber * projectBypass;
@property (nonatomic, retain) NSString * projectExplane;
@property (nonatomic, retain) NSNumber * projectLuster;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSNumber * projectSpot;
@property (nonatomic, retain) NSSet *projectPlot;
@end

@interface Projects (CoreDataGeneratedAccessors)

- (void)addProjectPlotObject:(Plot *)value;
- (void)removeProjectPlotObject:(Plot *)value;
- (void)addProjectPlot:(NSSet *)values;
- (void)removeProjectPlot:(NSSet *)values;

@end
