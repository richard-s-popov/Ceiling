//
//  PlotDiagonal.h
//  Calculator
//
//  Created by Александр Коровкин on 17.10.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Plot;

@interface PlotDiagonal : NSManagedObject

@property (nonatomic, retain) NSString * diagonalName;
@property (nonatomic, retain) NSNumber * diagonalWidth;
@property (nonatomic, retain) Plot *diagonalPlot;

@end
