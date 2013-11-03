//
//  PlotSide.h
//  Calculator
//
//  Created by Александр Коровкин on 02.11.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Plot, PlotDiagonal;

@interface PlotSide : NSManagedObject

@property (nonatomic, retain) NSString * angleFirst;
@property (nonatomic, retain) NSString * angleSecond;
@property (nonatomic, retain) NSNumber * sideWidth;
@property (nonatomic, retain) Plot *sidePlot;
@property (nonatomic, retain) NSSet *sideDiagonal;
@end

@interface PlotSide (CoreDataGeneratedAccessors)

- (void)addSideDiagonalObject:(PlotDiagonal *)value;
- (void)removeSideDiagonalObject:(PlotDiagonal *)value;
- (void)addSideDiagonal:(NSSet *)values;
- (void)removeSideDiagonal:(NSSet *)values;

@end
