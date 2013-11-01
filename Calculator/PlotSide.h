//
//  PlotSide.h
//  Calculator
//
//  Created by Александр Коровкин on 31.10.13.
//  Copyright (c) 2013 Александр Коровкин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Plot;

@interface PlotSide : NSManagedObject

@property (nonatomic, retain) NSString * angleFirst;
@property (nonatomic, retain) NSNumber * sideWidth;
@property (nonatomic, retain) NSString * angleSecond;
@property (nonatomic, retain) Plot *sidePlot;

@end
