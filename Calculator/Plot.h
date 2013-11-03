//
//  Plot.h
//  Calculator
//
//  Created by Александр Коровкин on 02.11.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlotDiagonal, PlotSide;

@interface Plot : NSManagedObject

@property (nonatomic, retain) NSString * plotName;
@property (nonatomic, retain) NSSet *plotSide;
@property (nonatomic, retain) NSSet *plotDiagonal;
@end

@interface Plot (CoreDataGeneratedAccessors)

- (void)addPlotSideObject:(PlotSide *)value;
- (void)removePlotSideObject:(PlotSide *)value;
- (void)addPlotSide:(NSSet *)values;
- (void)removePlotSide:(NSSet *)values;

- (void)addPlotDiagonalObject:(PlotDiagonal *)value;
- (void)removePlotDiagonalObject:(PlotDiagonal *)value;
- (void)addPlotDiagonal:(NSSet *)values;
- (void)removePlotDiagonal:(NSSet *)values;

@end
