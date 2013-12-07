//
//  PlotDiagonal.h
//  Calculator
//
//  Created by Александр Коровкин on 08.12.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Plot, PlotSide;

@interface PlotDiagonal : NSManagedObject

@property (nonatomic, retain) NSString * angleFirst;
@property (nonatomic, retain) NSString * angleSecond;
@property (nonatomic, retain) NSNumber * diagonalWidth;
@property (nonatomic, retain) NSNumber * diagonalWidthFactor;
@property (nonatomic, retain) Plot *diagonalPlot;
@property (nonatomic, retain) PlotSide *diagonalSide;

@end
