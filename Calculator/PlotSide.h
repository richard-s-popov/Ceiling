//
//  PlotSide.h
//  Calculator
//
//  Created by Александр Коровкин on 12.07.14.
//  Copyright (c) 2014 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Plot, PlotDiagonal;

@interface PlotSide : NSManagedObject

@property (nonatomic, retain) NSNumber * angle;
@property (nonatomic, retain) NSString * angleFirst;
@property (nonatomic, retain) NSString * angleSecond;
@property (nonatomic, retain) NSNumber * sidePosition;
@property (nonatomic, retain) NSNumber * sideWidth;
@property (nonatomic, retain) NSNumber * sideWidthFactor;
@property (nonatomic, retain) NSNumber * isStartShov;
@property (nonatomic, retain) NSSet *sideDiagonal;
@property (nonatomic, retain) Plot *sidePlot;
@end

@interface PlotSide (CoreDataGeneratedAccessors)

- (void)addSideDiagonalObject:(PlotDiagonal *)value;
- (void)removeSideDiagonalObject:(PlotDiagonal *)value;
- (void)addSideDiagonal:(NSSet *)values;
- (void)removeSideDiagonal:(NSSet *)values;

@end
